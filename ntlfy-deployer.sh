#!/usr/bin/env bash
set -Eeuo pipefail

APP_NAME="NtLfyIraniCore Deployer"
AUTHOR="LoaTary"
REPO_URL="https://github.com/B3hnamR/NtLfyIraniCore.git"
WORK_DIR="${WORK_DIR:-/root/NtLfyIraniCore}"
LOG_FILE="${LOG_FILE:-/root/ntlfy-deployer.log}"
DEPLOY_LOG="${DEPLOY_LOG:-/root/ntlfy-deploy.log}"

exec > >(tee "$LOG_FILE") 2>&1

trap 'echo; line; echo "ERROR"; echo "Line: $LINENO"; echo "Command: $BASH_COMMAND"; echo "Log: $LOG_FILE"; exit 1' ERR

line() {
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

banner() {
  clear
  echo "╔════════════════════════════════════════════════════╗"
  echo "║              NtLfyIraniCore Deployer              ║"
  echo "║                Developed by LoaTary                ║"
  echo "╚════════════════════════════════════════════════════╝"
}

step() {
  echo
  line
  echo "$1"
  line
}

ok() {
  echo "✓ $1"
}

stop() {
  echo "✗ $1"
  exit 1
}

trim() {
  echo "$1" | xargs
}

ask() {
  local label="$1"
  local value=""
  read -r -p "$label: " value
  trim "$value"
}

ask_secret() {
  local label="$1"
  local value=""
  read -r -s -p "$label: " value
  echo
  trim "$value"
}

banner
echo

UPSTREAM_BASE="$(ask "Upstream Domain")"
ACCESS_PATH="$(ask "Access Path")"
REQUEST_TIMEOUT_MS="$(ask "Timeout MS")"
NETLIFY_AUTH_TOKEN="$(ask_secret "Netlify Token")"

[ -n "$UPSTREAM_BASE" ] || stop "Upstream Domain is empty"
[ -n "$ACCESS_PATH" ] || stop "Access Path is empty"
[ -n "$REQUEST_TIMEOUT_MS" ] || stop "Timeout MS is empty"
[ -n "$NETLIFY_AUTH_TOKEN" ] || stop "Netlify Token is empty"

[[ "$UPSTREAM_BASE" == http://* || "$UPSTREAM_BASE" == https://* ]] || UPSTREAM_BASE="https://$UPSTREAM_BASE"
[[ "$ACCESS_PATH" == /* ]] || ACCESS_PATH="/$ACCESS_PATH"
[[ "$REQUEST_TIMEOUT_MS" =~ ^[0-9]+$ ]] || stop "Timeout MS must be numeric"
[ "$ACCESS_PATH" != "/" ] || stop "Access Path cannot be /"

UPSTREAM_BASE="${UPSTREAM_BASE%/}"
export NETLIFY_AUTH_TOKEN

step "Preparing system"
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq curl git ca-certificates gnupg jq openssl python3 >/dev/null
ok "System packages ready"

step "Checking Node.js"
if ! command -v node >/dev/null 2>&1; then
  curl -fsSL https://deb.nodesource.com/setup_22.x | bash - >/dev/null
  DEBIAN_FRONTEND=noninteractive apt-get install -y -qq nodejs >/dev/null
fi

NODE_MAJOR="$(node -v | sed 's/^v//' | cut -d. -f1)"
if [ "$NODE_MAJOR" -lt 18 ]; then
  curl -fsSL https://deb.nodesource.com/setup_22.x | bash - >/dev/null
  DEBIAN_FRONTEND=noninteractive apt-get install -y -qq nodejs >/dev/null
fi

ok "Node $(node -v)"
ok "NPM $(npm -v)"

SITE_NAME="titus-relay-$(openssl rand -hex 4)"

step "Checking Netlify account"
NETLIFY_USER="$(curl -fsS -H "Authorization: Bearer ${NETLIFY_AUTH_TOKEN}" https://api.netlify.com/api/v1/user)"
NETLIFY_EMAIL="$(echo "$NETLIFY_USER" | jq -r '.email // "unknown"')"
ok "$NETLIFY_EMAIL"

step "Downloading project"
rm -rf "$WORK_DIR"
git clone "$REPO_URL" "$WORK_DIR" >/dev/null
cd "$WORK_DIR"
ok "Project downloaded"

step "Writing relay configuration"
python3 - "$UPSTREAM_BASE" "$ACCESS_PATH" "$REQUEST_TIMEOUT_MS" <<'PY'
import json
import sys
from pathlib import Path

upstream = sys.argv[1]
access_path = sys.argv[2]
timeout = int(sys.argv[3])

content = f'''
const FALLBACK_UPSTREAM_BASE = {json.dumps(upstream)};
const FALLBACK_ACCESS_PATH = {json.dumps(access_path)};
const FALLBACK_REQUEST_TIMEOUT_MS = {timeout};

function normalizePath(value) {{
  if (!value) return "";
  let path = String(value).trim();
  if (!path.startsWith("/")) path = "/" + path;
  return path.replace(/\\/+$/, "") || "/";
}}

function positiveInt(value, fallback) {{
  const n = Number.parseInt(value, 10);
  return Number.isFinite(n) && n > 0 ? n : fallback;
}}

function forwardHeaders(request) {{
  const headers = new Headers(request.headers);
  [
    "host",
    "connection",
    "upgrade",
    "transfer-encoding",
    "x-access-key",
    "x-relay-key"
  ].forEach((name) => headers.delete(name));

  for (const name of [...headers.keys()]) {{
    const key = name.toLowerCase();
    if (key.startsWith("x-netlify-") || key.startsWith("x-nf-")) headers.delete(name);
  }}

  return headers;
}}

export default async (request) => {{
  const upstreamBase = (
    Netlify.env.get("UPSTREAM_BASE") ||
    Netlify.env.get("TARGET_DOMAIN") ||
    FALLBACK_UPSTREAM_BASE
  ).replace(/\\/$/, "");

  const accessPath = normalizePath(
    Netlify.env.get("ACCESS_PATH") ||
    Netlify.env.get("RELAY_PATH") ||
    FALLBACK_ACCESS_PATH
  );

  const timeoutMs = positiveInt(
    Netlify.env.get("REQUEST_TIMEOUT_MS") ||
    Netlify.env.get("UPSTREAM_TIMEOUT_MS"),
    FALLBACK_REQUEST_TIMEOUT_MS
  );

  const accessKey = Netlify.env.get("ACCESS_KEY") || Netlify.env.get("RELAY_KEY") || "";

  if (!upstreamBase || !accessPath || accessPath === "/") {{
    return new Response("Misconfigured", {{ status: 500 }});
  }}

  const url = new URL(request.url);
  const allowedPath = url.pathname === accessPath || url.pathname.startsWith(accessPath + "/");

  if (!allowedPath) {{
    return new Response("", {{ status: 404 }});
  }}

  if (!["GET", "HEAD", "POST"].includes(request.method)) {{
    return new Response("Method Not Allowed", {{ status: 405 }});
  }}

  if (accessKey) {{
    const provided = request.headers.get("x-access-key") || request.headers.get("x-relay-key") || "";
    if (provided !== accessKey) {{
      return new Response("Forbidden", {{ status: 403 }});
    }}
  }}

  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), timeoutMs);

  try {{
    const targetUrl = upstreamBase + url.pathname + url.search;
    const options = {{
      method: request.method,
      headers: forwardHeaders(request),
      redirect: "manual",
      signal: controller.signal
    }};

    if (!["GET", "HEAD"].includes(request.method)) {{
      options.body = request.body;
    }}

    const response = await fetch(targetUrl, options);
    return new Response(response.body, {{
      status: response.status,
      statusText: response.statusText,
      headers: new Headers(response.headers)
    }});
  }} catch (error) {{
    if (error && error.name === "AbortError") {{
      return new Response("Gateway Timeout", {{ status: 504 }});
    }}
    return new Response("Bad Gateway", {{ status: 502 }});
  }} finally {{
    clearTimeout(timer);
  }}
}};
'''.strip() + "\n"

Path("netlify/edge-functions/relay.js").write_text(content)
PY
ok "Relay configured"

step "Installing project tools"
npm install --no-audit --no-fund >/dev/null
npm install --save-dev netlify-cli --no-audit --no-fund >/dev/null
ok "$(./node_modules/.bin/netlify --version)"

step "Creating Netlify site"
CREATE_JSON="$(curl -fsS -X POST "https://api.netlify.com/api/v1/sites" \
  -H "Authorization: Bearer ${NETLIFY_AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  --data "{\"name\":\"${SITE_NAME}\"}")"

SITE_ID="$(echo "$CREATE_JSON" | jq -r '.id // empty')"
ADMIN_URL="$(echo "$CREATE_JSON" | jq -r '.admin_url // empty')"

[ -n "$SITE_ID" ] || stop "Site creation failed"

mkdir -p .netlify
printf '{"siteId":"%s"}\n' "$SITE_ID" > .netlify/state.json

ok "$SITE_NAME"
ok "$SITE_ID"

step "Saving environment"
./node_modules/.bin/netlify env:set UPSTREAM_BASE "$UPSTREAM_BASE" --site "$SITE_ID" --auth "$NETLIFY_AUTH_TOKEN" --force >/dev/null
./node_modules/.bin/netlify env:set ACCESS_PATH "$ACCESS_PATH" --site "$SITE_ID" --auth "$NETLIFY_AUTH_TOKEN" --force >/dev/null
./node_modules/.bin/netlify env:set REQUEST_TIMEOUT_MS "$REQUEST_TIMEOUT_MS" --site "$SITE_ID" --auth "$NETLIFY_AUTH_TOKEN" --force >/dev/null
ok "Environment saved"

step "Deploying"
set +e
./node_modules/.bin/netlify deploy \
  --prod \
  --build \
  --site "$SITE_ID" \
  --auth "$NETLIFY_AUTH_TOKEN" \
  --message "Manual deploy by LoaTary" >"$DEPLOY_LOG" 2>&1
DEPLOY_EXIT="$?"
set -e

if [ "$DEPLOY_EXIT" -ne 0 ]; then
  cat "$DEPLOY_LOG"
  stop "Deploy failed"
fi

ok "Deploy completed"

FINAL_URL="https://${SITE_NAME}.netlify.app${ACCESS_PATH}"

step "Testing"
HTTP_CODE="$(curl -k -s -o /tmp/ntlfy-response.txt -w "%{http_code}" "$FINAL_URL")"
echo "HTTP Status: $HTTP_CODE"

echo
echo "╔════════════════════════════════════════════════════╗"
echo "║                    DEPLOY DONE                    ║"
echo "╚════════════════════════════════════════════════════╝"
echo
echo "Developed by : $AUTHOR"
echo "Site Name    : $SITE_NAME"
echo "Site ID      : $SITE_ID"
echo "Relay URL    : $FINAL_URL"
echo "Admin URL    : $ADMIN_URL"
echo "Main Log     : $LOG_FILE"
echo "Deploy Log   : $DEPLOY_LOG"
echo
echo "Flow"
echo "$FINAL_URL"
echo "↓"
echo "${UPSTREAM_BASE}${ACCESS_PATH}"
echo
