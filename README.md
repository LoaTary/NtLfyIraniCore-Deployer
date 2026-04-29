<div align="center">

# 🚀 NtLfyIraniCore Deployer

### دپلوی خودکار و تمیز NtLfyIraniCore روی Netlify

<br>

![Bash](https://img.shields.io/badge/Bash-Script-121011?style=for-the-badge&logo=gnubash&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-Supported-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Netlify](https://img.shields.io/badge/Netlify-Edge%20Relay-00C7B7?style=for-the-badge&logo=netlify&logoColor=white)
![Status](https://img.shields.io/badge/Manual%20Deploy-Ready-22C55E?style=for-the-badge)

<br>

**Developed by LoaTary**

</div>

---

## 📌 معرفی

**NtLfyIraniCore Deployer** یک اسکریپت سبک، مرتب و خودکار برای دپلوی دستی پروژه‌ی **NtLfyIraniCore** روی Netlify است.

با این ابزار نیازی نیست اکانت GitHub خود را به Netlify متصل کنید. اسکریپت سورس اصلی را از GitHub دریافت می‌کند، فایل Edge Function را آماده‌سازی می‌کند، سایت Netlify می‌سازد، متغیرهای لازم را ثبت می‌کند و در پایان دپلوی Production را انجام می‌دهد.

این ابزار فقط ۴ مقدار از شما می‌گیرد:

```text
Upstream Domain
Access Path
Timeout MS
Netlify Token
```

---

## 🔗 منبع پروژه اصلی

این Deployer برای پروژه‌ی اصلی زیر آماده شده است:

```text
https://github.com/B3hnamR/NtLfyIraniCore.git
```

سورس اصلی هنگام اجرای اسکریپت به‌صورت خودکار از این مخزن دریافت می‌شود.

---

## ✨ امکانات

- ⚡ دپلوی دستی روی Netlify بدون اتصال GitHub به Netlify
- 🌐 ساخت خودکار سایت Netlify با نام تصادفی
- 📦 دریافت خودکار سورس NtLfyIraniCore از GitHub
- 🧩 آماده‌سازی Edge Function برای اجرای پایدارتر
- 🔧 تنظیم خودکار `UPSTREAM_BASE`
- 🛣️ تنظیم خودکار `ACCESS_PATH`
- ⏱️ تنظیم خودکار `REQUEST_TIMEOUT_MS`
- 🛡️ تزریق fallback داخل Edge Function برای جلوگیری از خطای ENV
- 🐧 نصب خودکار ابزارهای لازم روی Ubuntu
- 🚀 دپلوی Production روی Netlify
- 🔍 تست لینک نهایی بعد از دپلوی
- 📄 ذخیره لاگ‌های مرتب و قابل بررسی
- 🧼 خروجی تمیز و مناسب استفاده شخصی یا پروژه‌ای

---

## 🧠 نحوه کار

جریان کلی درخواست به این شکل است:

```text
Client
↓
Netlify Edge Relay
↓
Upstream Server
↓
Response
```

نمونه با دامنه‌ی فرضی:

```text
https://titus-relay-xxxxxxxx.netlify.app/titus
↓
https://app.titus.ir:443/titus
```

یعنی درخواست وارد دامنه Netlify می‌شود و سپس با همان مسیر به سرور اصلی منتقل می‌شود.

---

## 📁 ساختار پیشنهادی ریپازیتوری

```text
NtLfyIraniCore-Deployer
├── ntlfy-deployer.sh
└── README.md
```

---

## 📋 پیش‌نیازها

برای اجرا به موارد زیر نیاز دارید:

- 🐧 یک سرور Ubuntu
- 🔐 دسترسی root یا sudo
- 🌍 اینترنت برای نصب پکیج‌ها
- 🧾 یک Netlify Personal Access Token

---

## 🔑 آموزش ساخت Netlify Token

برای اینکه اسکریپت بتواند سایت Netlify بسازد، ENVها را تنظیم کند و دپلوی Production انجام دهد، باید یک **Personal Access Token** بسازید.

### مسیر ساخت توکن

وارد Netlify شوید و مسیر زیر را دنبال کنید:

```text
User settings
↓
Applications
↓
Personal access tokens
↓
New access token
```

### مراحل ساخت

1. وارد پنل Netlify شوید.
2. روی تصویر پروفایل یا نام کاربری کلیک کنید.
3. وارد بخش **User settings** شوید.
4. از منوی کناری وارد بخش **Applications** شوید.
5. در قسمت **Personal access tokens** روی **New access token** بزنید.
6. برای توکن یک نام وارد کنید.
7. روی **Generate token** بزنید.
8. توکن ساخته‌شده را کپی کنید.

نام پیشنهادی برای توکن:

```text
NtLfyIraniCore Deployer
```

نمونه فرمت توکن:

```text
nfp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

> توکن را داخل GitHub، فایل README، لاگ عمومی یا چت عمومی قرار ندهید. اگر توکن لو رفت، آن را از Netlify حذف یا Regenerate کنید.

---

## 🐧 نصب و اجرا روی Ubuntu

برای نصب و اجرای Deployer روی Ubuntu، این دستورات را وارد کنید:

```bash
sudo apt update
sudo apt install -y git
```

سپس پروژه را کلون کنید:

```bash
git clone https://github.com/LoaTary/NtLfyIraniCore-Deployer.git
```

وارد پوشه پروژه شوید:

```bash
cd NtLfyIraniCore-Deployer
```

سطح دسترسی اجرا بدهید:

```bash
chmod +x ntlfy-deployer.sh
```

اسکریپت را اجرا کنید:

```bash
sudo ./ntlfy-deployer.sh
```

اگر نام ریپازیتوری شما متفاوت است، فقط آدرس `git clone` را با آدرس ریپازیتوری خودتان جایگزین کنید.

---

## ⚙️ مقادیر موردنیاز هنگام اجرا

اسکریپت هنگام اجرا فقط ۴ مقدار از شما می‌خواهد:

```text
Upstream Domain
Access Path
Timeout MS
Netlify Token
```

---

## 🌐 Upstream Domain

`Upstream Domain` آدرس سرور اصلی است؛ یعنی مقصدی که Netlify درخواست‌ها را به آن منتقل می‌کند.

نمونه پیشنهادی:

```text
https://app.titus.ir:443
```

اگر `https://` را وارد نکنید، اسکریپت به‌صورت خودکار آن را اضافه می‌کند.

نمونه‌های معتبر:

```text
https://app.titus.ir:443
app.titus.ir:443
https://api.example.com
```

---

## 🛣️ Access Path

`Access Path` مسیری است که روی دامنه Netlify فعال می‌شود.

نمونه:

```text
/titus
```

اگر `/` ابتدای مسیر را وارد نکنید، اسکریپت خودش آن را اضافه می‌کند.

جریان نهایی با این مقدار:

```text
Netlify URL:
https://titus-relay-xxxxxxxx.netlify.app/titus

Upstream URL:
https://app.titus.ir:443/titus
```

مقدار `/` برای Access Path مجاز نیست؛ چون باعث باز شدن کل مسیرهای upstream می‌شود.

---

## ⏱️ Timeout MS

`Timeout MS` زمان انتظار برای پاسخ upstream برحسب میلی‌ثانیه است.

مقدار پیشنهادی:

```text
120000
```

یعنی:

```text
120 seconds
```

اگر upstream دیر پاسخ دهد، Relay ممکن است پاسخ زیر برگرداند:

```text
504 Gateway Timeout
```

---

## 🔐 Netlify Token

`Netlify Token` همان Personal Access Token است که از پنل Netlify دریافت می‌کنید.

این توکن برای کارهای زیر استفاده می‌شود:

- ساخت سایت Netlify
- ثبت Environment Variables
- اجرای Production Deploy
- دریافت وضعیت اکانت Netlify

نمونه:

```text
nfp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

---

## 🧪 نمونه اجرای کامل

بعد از اجرای اسکریپت، مقادیر را به این شکل وارد کنید:

```text
Upstream Domain: https://app.titus.ir:443
Access Path: /titus
Timeout MS: 120000
Netlify Token: nfp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

---

## ✅ خروجی نهایی

در پایان، خروجی مشابه نمونه زیر نمایش داده می‌شود:

```text
DEPLOY DONE

Developed by : LoaTary
Site Name    : titus-relay-xxxxxxxx
Site ID      : xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Relay URL    : https://titus-relay-xxxxxxxx.netlify.app/titus
Admin URL    : https://app.netlify.com/projects/titus-relay-xxxxxxxx
Main Log     : /root/ntlfy-deployer.log
Deploy Log   : /root/ntlfy-deploy.log
```

---

## 🔄 جریان نهایی

نمونه مسیر نهایی:

```text
https://titus-relay-xxxxxxxx.netlify.app/titus
↓
https://app.titus.ir:443/titus
```

اگر upstream شما روی همین مسیر فعال باشد، پاسخ از سرور اصلی برمی‌گردد.

---

## 📡 SNI پیشنهادی

برای تست یا استفاده در تنظیمات مرتبط، می‌توانید از SNIهای زیر استفاده کنید:

```text
kubernetes.io
helm.sh
letsencrypt.org
```

---

## 📄 فایل‌های لاگ

اسکریپت دو فایل لاگ ایجاد می‌کند:

```text
/root/ntlfy-deployer.log
/root/ntlfy-deploy.log
```

مشاهده لاگ اصلی:

```bash
tail -n 120 /root/ntlfy-deployer.log
```

مشاهده لاگ دپلوی:

```bash
tail -n 120 /root/ntlfy-deploy.log
```

---

## 🧰 خطاهای رایج

### ❌ خطای 500

اگر با این پیام مواجه شدید:

```text
Misconfigured: UPSTREAM_BASE/TARGET_DOMAIN is not set
```

یعنی Edge Function مقدارهای ENV را دریافت نکرده است.

در این Deployer علاوه‌بر ثبت ENV روی Netlify، مقدارها به‌عنوان fallback داخل Edge Function هم تزریق می‌شوند تا احتمال این خطا کمتر شود.

---

### ❌ خطای 404

اگر تست نهایی با `curl` کد `404` برگرداند، همیشه به معنی خراب بودن Relay نیست.

در بعضی سرویس‌ها مسیر upstream برای درخواست GET معمولی پاسخ خاصی ندارد. در این حالت باید عملکرد اصلی را با کلاینت واقعی بررسی کنید.

برای تست مستقیم upstream:

```bash
curl -k -i https://app.titus.ir:443/titus
```

اگر upstream مستقیم هم `404` بدهد، Relay هم همان پاسخ را برمی‌گرداند.

---

### ❌ خطای 502

این خطا یعنی Netlify نتوانسته به upstream متصل شود.

موارد قابل بررسی:

- آدرس upstream
- پورت
- SSL
- DNS
- Firewall
- وضعیت سرور اصلی

---

### ❌ خطای 504

این خطا یعنی upstream دیر پاسخ داده یا زمان انتظار تمام شده است.

راهکارها:

- افزایش مقدار `Timeout MS`
- بررسی وضعیت سرور اصلی
- بررسی کندی شبکه
- بررسی پاسخ‌دهی upstream

---

## 🔎 تست دستی

بعد از دپلوی می‌توانید Relay URL را تست کنید:

```bash
curl -k -i https://titus-relay-xxxxxxxx.netlify.app/titus
```

برای تست مستقیم upstream:

```bash
curl -k -i https://app.titus.ir:443/titus
```

اگر خروجی هر دو مشابه باشد، Relay مسیر را درست منتقل می‌کند.

---

## 🔐 نکات امنیتی

- توکن Netlify را داخل ریپازیتوری قرار ندهید.
- توکن را در اختیار افراد دیگر نگذارید.
- بعد از تست‌های عمومی، توکن استفاده‌شده را حذف یا Regenerate کنید.
- برای هر پروژه بهتر است یک توکن جداگانه بسازید.
- اگر توکن لو رفت، سریع آن را از Netlify حذف کنید.
- فایل‌های لاگ را قبل از انتشار عمومی بررسی کنید.

---

## 🧹 حذف سایت از Netlify

برای حذف سایت ساخته‌شده:

```text
Netlify Dashboard
↓
Projects
↓
Select Project
↓
Project configuration
↓
General
↓
Delete project
```

---

## ♻️ اجرای مجدد

هر بار اجرای اسکریپت یک سایت جدید با نام تصادفی می‌سازد.

نمونه نام سایت:

```text
titus-relay-a1b2c3d4
```

اگر می‌خواهید روی سایت قبلی Redeploy کنید، باید اسکریپت را تغییر دهید و `SITE_ID` همان پروژه را وارد کنید.

---

## 🧾 متغیرهای ثبت‌شده در Netlify

اسکریپت این متغیرها را روی سایت Netlify ثبت می‌کند:

```text
UPSTREAM_BASE
ACCESS_PATH
REQUEST_TIMEOUT_MS
```

این مقدارها در Edge Function استفاده می‌شوند.

---

## 🧩 پروژه اصلی

```text
NtLfyIraniCore
```

Repository:

```text
https://github.com/B3hnamR/NtLfyIraniCore.git
```

---

## 👤 توسعه‌دهنده

```text
Developed by LoaTary
```

---

## ⚠️ نکته پایانی

این ابزار برای ساده‌تر کردن دپلوی دستی NtLfyIraniCore روی Netlify طراحی شده است. خروجی نهایی به تنظیم صحیح upstream، مسیر و سرویس مقصد وابسته است.

اگر upstream به درخواست GET معمولی پاسخ `404` بدهد، تست `curl` هم همان پاسخ را نمایش می‌دهد. در این حالت باید عملکرد نهایی را با کلاینت اصلی بررسی کنید.
