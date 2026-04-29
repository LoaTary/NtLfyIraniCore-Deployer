#!/usr/bin/env bash
set -Eeuo pipefail

LOG_FILE="/root/ntlfy-deployer.log"
DEPLOY_LOG="/root/ntlfy-deploy.log"

exec > >(tee "$LOG_FILE") 2>&1

trap 'printf "\n\033[1;31mERROR\033[0m\nLINE: %s\nCOMMAND: %s\nLOG: %s\n" "$LINENO" "$BASH_COMMAND" "$LOG_FILE"; exit 1' ERR

RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
BLUE="\033[1;34m"
YELLOW="\033[1;33m"
RED="\033[1;31m"

box() {
  clear
  printf "%b" "$CYAN"
  cat <<'BANNER'
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║                  NtLfyIraniCore Deployer                    ║
║                                                              ║
║                    Edge Relay Auto Deploy                    ║
║                                                              ║
║                    Developed by LoaTary                      ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
BANNER
  printf "%b" "$RESET"
}

line() {
  printf "%b%s%b\n" "$BLUE" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "$RESET"
}

step() {
  printf "\n"
  line
  printf "%b%s%b\n" "$BOLD" "$1" "$RESET"
  line
}

ok() {
  printf "%b✓%b %s\n" "$GREEN" "$RESET" "$1"
}

warn() {
  printf "%b!%b %s\n" "$YELLOW" "$RESET" "$1"
}

die() {
  printf "%b✗%b %s\n" "$RED" "$RESET" "$1"
  exit 1
}

api_get() {
  curl -4 --http1.1 --connect-timeout 20 --max-time 60 -fsS "$@"
}

api_post() {
  curl -4 --http1.1 --connect-timeout 20 --max-time 60 -fsS -X POST "$@"
}

prompt() {
  local label="$1"
  local value=""
  read -r -p "$(printf "%b%s%b" "$CYAN" "$label" "$RESET")" value
  printf "%s" "$value"
}

[ "$(id -u)" -eq 0 ] || die "Run this script as root or with sudo"

box
printf "\n"
UPSTREAM_BASE="$(prompt 'Upstream Domain: ')"
ACCESS_PATH="$(prompt 'Access Path: ')"
REQUEST_TIMEOUT_MS="$(prompt 'Timeout MS: ')"
NETLIFY_AUTH_TOKEN="$(prompt 'Netlify Token: ')"

UPSTREAM_BASE="$(echo "$UPSTREAM_BASE" | xargs)"
ACCESS_PATH="$(echo "$ACCESS_PATH" | xargs)"
REQUEST_TIMEOUT_MS="$(echo "$REQUEST_TIMEOUT_MS" | xargs)"
NETLIFY_AUTH_TOKEN="$(echo "$NETLIFY_AUTH_TOKEN" | xargs)"

[ -n "$UPSTREAM_BASE" ] || die "Upstream Domain is empty"
[ -n "$ACCESS_PATH" ] || die "Access Path is empty"
[ -n "$REQUEST_TIMEOUT_MS" ] || die "Timeout is empty"
[ -n "$NETLIFY_AUTH_TOKEN" ] || die "Netlify Token is empty"

[[ "$UPSTREAM_BASE" == http://* || "$UPSTREAM_BASE" == https://* ]] || UPSTREAM_BASE="https://$UPSTREAM_BASE"
[[ "$ACCESS_PATH" == /* ]] || ACCESS_PATH="/$ACCESS_PATH"
[[ "$REQUEST_TIMEOUT_MS" =~ ^[0-9]+$ ]] || die "Timeout must be numeric"
[ "$ACCESS_PATH" != "/" ] || die "Access Path cannot be /"

UPSTREAM_BASE="${UPSTREAM_BASE%/}"
export NETLIFY_AUTH_TOKEN
export DEBIAN_FRONTEND=noninteractive

REPO_URL="https://github.com/B3hnamR/NtLfyIraniCore.git"
PROJECT_DIR="/root/NtLfyIraniCore"

step "Preparing system"
apt-get update -qq
apt-get install -y -qq curl git ca-certificates gnupg jq openssl python3 >/dev/null
ok "System packages ready"

SITE_NAME="titus-relay-$(openssl rand -hex 4)"

step "Checking Node.js"
if ! command -v node >/dev/null 2>&1; then
  curl -4 --http1.1 -fsSL https://deb.nodesource.com/setup_22.x | bash - >/dev/null
  apt-get install -y -qq nodejs >/dev/null
fi

NODE_MAJOR="$(node -v | sed 's/^v//' | cut -d. -f1)"
if [ "$NODE_MAJOR" -lt 18 ]; then
  curl -4 --http1.1 -fsSL https://deb.nodesource.com/setup_22.x | bash - >/dev/null
  apt-get install -y -qq nodejs >/dev/null
fi

ok "Node $(node -v)"
ok "NPM $(npm -v)"

step "Checking Netlify account"
NETLIFY_USER="$(api_get -H "Authorization: Bearer ${NETLIFY_AUTH_TOKEN}" https://api.netlify.com/api/v1/user)"
NETLIFY_EMAIL="$(echo "$NETLIFY_USER" | jq -r '.email // "unknown"')"
NETLIFY_NAME="$(echo "$NETLIFY_USER" | jq -r '.full_name // .name // "unknown"')"
ok "$NETLIFY_NAME <$NETLIFY_EMAIL>"

step "Downloading project"
rm -rf "$PROJECT_DIR"
git clone "$REPO_URL" "$PROJECT_DIR" >/dev/null
cd "$PROJECT_DIR"
ok "Project ready"

step "Applying relay configuration"
python3 - "$UPSTREAM_BASE" "$ACCESS_PATH" "$REQUEST_TIMEOUT_MS" <<'PY'
import json
import sys
from pathlib import Path

upstream = sys.argv[1]
access_path = sys.argv[2]
timeout = int(sys.argv[3])

code = f'''
const FALLBACK_UPSTREAM_BASE = {json.dumps(upstream)};
const FALLBACK_ACCESS_PATH = {json.dumps(access_path)};
const FALLBACK_REQUEST_TIMEOUT_MS = {timeout};

function normalizePath(value) {{
  if (!value) return "";
  let path = String(value).trim();
  if (!path.startsWith("/")) path = "/" + path;
  return path.replace(/\\/+$/, "") || "/";
}}

function readPositiveInt(value, fallback) {{
  const n = Number.parseInt(value, 10);
  return Number.isFinite(n) && n > 0 ? n : fallback;
}}

function cleanHeaders(request) {{
  const headers = new Headers(request.headers);
  ["host", "connection", "upgrade", "transfer-encoding", "x-access-key", "x-relay-key"].forEach((key) => headers.delete(key));
  for (const key of [...headers.keys()]) {{
    const k = key.toLowerCase();
    if (k.startsWith("x-netlify-") || k.startsWith("x-nf-")) headers.delete(key);
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

  const timeoutMs = readPositiveInt(
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
    const headers = cleanHeaders(request);
    const init = {{
      method: request.method,
      headers,
      redirect: "manual",
      signal: controller.signal
    }};

    if (!["GET", "HEAD"].includes(request.method)) {{
      init.body = request.body;
    }}

    const response = await fetch(targetUrl, init);
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

Path("netlify/edge-functions/relay.js").write_text(code)
PY
ok "Relay configured"

step "Installing project dependencies"
npm install --no-audit --no-fund >/dev/null
npm install --save-dev netlify-cli --no-audit --no-fund >/dev/null
ok "$(./node_modules/.bin/netlify --version)"

step "Creating Netlify site"
CREATE_JSON="$(api_post "https://api.netlify.com/api/v1/sites" \
  -H "Authorization: Bearer ${NETLIFY_AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  --data "{\"name\":\"${SITE_NAME}\"}")"

SITE_ID="$(echo "$CREATE_JSON" | jq -r '.id // empty')"
SITE_URL="$(echo "$CREATE_JSON" | jq -r '.ssl_url // empty')"
ADMIN_URL="$(echo "$CREATE_JSON" | jq -r '.admin_url // empty')"

[ -n "$SITE_ID" ] || die "Site creation failed"

mkdir -p .netlify
printf '{"siteId":"%s"}\n' "$SITE_ID" > .netlify/state.json
ok "$SITE_NAME"
ok "$SITE_ID"

step "Setting Netlify variables"
./node_modules/.bin/netlify env:set UPSTREAM_BASE "$UPSTREAM_BASE" --site "$SITE_ID" --auth "$NETLIFY_AUTH_TOKEN" --force >/dev/null
./node_modules/.bin/netlify env:set ACCESS_PATH "$ACCESS_PATH" --site "$SITE_ID" --auth "$NETLIFY_AUTH_TOKEN" --force >/dev/null
./node_modules/.bin/netlify env:set REQUEST_TIMEOUT_MS "$REQUEST_TIMEOUT_MS" --site "$SITE_ID" --auth "$NETLIFY_AUTH_TOKEN" --force >/dev/null
ok "Variables saved"

step "Deploying to production"
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
  die "Deploy failed"
fi
ok "Deploy completed"

FINAL_URL="https://${SITE_NAME}.netlify.app${ACCESS_PATH}"

step "Testing relay"
HTTP_CODE="$(curl -4 --http1.1 -k -s -o /tmp/ntlfy-response.txt -w "%{http_code}" "$FINAL_URL" || true)"
printf "HTTP Status: %s\n" "$HTTP_CODE"

printf "\n%b" "$GREEN"
cat <<'DONE'
╔══════════════════════════════════════════════════════════════╗
║                         DEPLOY DONE                         ║
╚══════════════════════════════════════════════════════════════╝
DONE
printf "%b\n" "$RESET"

printf "Developed by : LoaTary\n"
printf "Site Name    : %s\n" "$SITE_NAME"
printf "Site ID      : %s\n" "$SITE_ID"
printf "Relay URL    : %s\n" "$FINAL_URL"
printf "Admin URL    : %s\n" "$ADMIN_URL"
printf "Main Log     : %s\n" "$LOG_FILE"
printf "Deploy Log   : %s\n" "$DEPLOY_LOG"
printf "\nFlow\n%s\n↓\n%s%s\n\n" "$FINAL_URL" "$UPSTREAM_BASE" "$ACCESS_PATH"
