<div align="center">

# 🚀 NtLfyIraniCore Deployer

### دپلوی تمیز، سریع و دستی NtLfyIraniCore روی Netlify

<br>

![Bash](https://img.shields.io/badge/Bash-Script-121011?style=for-the-badge&logo=gnubash&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-Ready-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Netlify](https://img.shields.io/badge/Netlify-Edge%20Relay-00C7B7?style=for-the-badge&logo=netlify&logoColor=white)
![Deploy](https://img.shields.io/badge/Manual%20Deploy-Automated-22C55E?style=for-the-badge)

<br>

**Developed by LoaTary**

</div>

---

## 📌 معرفی

**NtLfyIraniCore Deployer** یک اسکریپت خودکار برای دپلوی دستی پروژه‌ی **NtLfyIraniCore** روی Netlify است.

این ابزار برای زمانی مناسب است که می‌خواهید پروژه را روی Netlify اجرا کنید، اما نمی‌خواهید اکانت GitHub خود را به Netlify متصل کنید. اسکریپت سورس اصلی را دریافت می‌کند، تنظیمات Relay را آماده می‌کند، سایت Netlify می‌سازد، متغیرهای لازم را ثبت می‌کند و در نهایت دپلوی Production را انجام می‌دهد.

اسکریپت فقط ۴ مقدار از شما می‌گیرد:

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

سورس اصلی هنگام اجرای اسکریپت به‌صورت خودکار از همین مخزن دریافت می‌شود.

---

## ✨ قابلیت‌ها

- ⚡ دپلوی دستی روی Netlify بدون اتصال GitHub به Netlify
- 🌐 ساخت خودکار سایت Netlify با نام تصادفی
- 📦 دریافت خودکار سورس NtLfyIraniCore از GitHub
- 🧩 آماده‌سازی Edge Function برای اجرای پایدارتر
- 🔧 تنظیم خودکار `UPSTREAM_BASE`
- 🛣️ تنظیم خودکار `ACCESS_PATH`
- ⏱️ تنظیم خودکار `REQUEST_TIMEOUT_MS`
- 🛡️ تزریق fallback داخل Edge Function برای کاهش خطای ENV
- 🐧 نصب خودکار ابزارهای لازم روی Ubuntu
- 🚀 دپلوی Production روی Netlify
- 🔍 تست لینک نهایی بعد از دپلوی
- 📄 لاگ‌گیری مرتب و قابل بررسی
- 🧼 خروجی ساده، تمیز و قابل استفاده برای پروژه‌های شخصی

---

## 🧠 نحوه عملکرد

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

نمونه با دامنه‌ی `app.titus.ir`:

```text
https://titus-relay-xxxxxxxx.netlify.app/titus
↓
https://app.titus.ir:443/titus
```

یعنی درخواست ابتدا وارد دامنه Netlify می‌شود و سپس با همان مسیر به سرور اصلی منتقل می‌شود.

---

## 📋 پیش‌نیازها

برای اجرای اسکریپت به این موارد نیاز دارید:

- 🐧 سرور Ubuntu
- 🔐 دسترسی root یا sudo
- 🌍 اینترنت برای نصب پکیج‌ها
- 🧾 Netlify Personal Access Token

---

## 🔑 دریافت Netlify Token

برای اینکه اسکریپت بتواند سایت بسازد، متغیرها را ثبت کند و دپلوی Production انجام دهد، باید یک **Personal Access Token** از Netlify دریافت کنید.

### مسیر ساخت توکن

وارد Netlify شوید و این مسیر را دنبال کنید:

```text
User settings
↓
Applications
↓
Personal access tokens
↓
New access token
```

### مراحل دریافت توکن

1. وارد داشبورد Netlify شوید.
2. روی تصویر پروفایل یا نام کاربری کلیک کنید.
3. وارد بخش **User settings** شوید.
4. از منوی کناری گزینه **Applications** را باز کنید.
5. در بخش **Personal access tokens** روی **New access token** بزنید.
6. برای توکن یک نام وارد کنید.
7. روی **Generate token** بزنید.
8. مقدار توکن را کپی کنید و هنگام اجرای اسکریپت وارد کنید.

نام پیشنهادی برای توکن:

```text
NtLfyIraniCore Deployer
```

نمونه فرمت توکن:

```text
nfp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

---

## 🐧 نصب و اجرا روی Ubuntu

ابتدا ابزار `git` را نصب کنید:

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

اجازه اجرا بدهید:

```bash
chmod +x ntlfy-deployer.sh
```

اسکریپت را اجرا کنید:

```bash
sudo ./ntlfy-deployer.sh
```

### اجرای سریع

```bash
sudo apt update && sudo apt install -y git && git clone https://github.com/LoaTary/NtLfyIraniCore-Deployer.git && cd NtLfyIraniCore-Deployer && chmod +x ntlfy-deployer.sh && sudo ./ntlfy-deployer.sh
```

---

## ⚙️ مقادیر موردنیاز هنگام اجرا

اسکریپت هنگام اجرا این ۴ مقدار را از شما می‌پرسد:

```text
Upstream Domain
Access Path
Timeout MS
Netlify Token
```

نمونه ورودی پیشنهادی:

```text
Upstream Domain: https://app.titus.ir:443
Access Path: /titus
Timeout MS: 120000
Netlify Token: nfp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

---

## 🌐 Upstream Domain

`Upstream Domain` آدرس سرور اصلی است؛ یعنی مقصدی که Netlify باید درخواست‌ها را به آن منتقل کند.

نمونه:

```text
https://app.titus.ir:443
```

نمونه‌های قابل قبول:

```text
https://app.titus.ir:443
app.titus.ir:443
https://api.example.com
```

اگر `https://` را وارد نکنید، اسکریپت به‌صورت خودکار آن را اضافه می‌کند.

---

## 🛣️ Access Path

`Access Path` مسیری است که روی دامنه Netlify فعال می‌شود.

نمونه:

```text
/titus
```

اگر `/` ابتدای مسیر را وارد نکنید، اسکریپت خودش آن را اضافه می‌کند.

نمونه جریان:

```text
Netlify URL:
https://titus-relay-xxxxxxxx.netlify.app/titus

Upstream URL:
https://app.titus.ir:443/titus
```

مقدار `/` برای Access Path مجاز نیست.

---

## ⏱️ Timeout MS

`Timeout MS` مدت‌زمان انتظار برای پاسخ upstream برحسب میلی‌ثانیه است.

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

این مقدار برای انجام این عملیات استفاده می‌شود:

- ساخت سایت Netlify
- ثبت Environment Variables
- اجرای Production Deploy
- دریافت وضعیت اکانت Netlify

نمونه:

```text
nfp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

---

## 🚀 خروجی نهایی

بعد از پایان دپلوی، خروجی مشابه نمونه زیر نمایش داده می‌شود:

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

اگر upstream روی همین مسیر فعال باشد، پاسخ از سرور اصلی برمی‌گردد.

---

## 📡 SNI پیشنهادی

برای تست یا استفاده در تنظیمات مرتبط، می‌توانید از SNIهای زیر استفاده کنید:

```text
kubernetes.io
helm.sh
letsencrypt.org
```

---

## 📄 لاگ‌ها

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

## 🧾 متغیرهای ثبت‌شده در Netlify

اسکریپت این متغیرها را روی سایت Netlify ثبت می‌کند:

```text
UPSTREAM_BASE
ACCESS_PATH
REQUEST_TIMEOUT_MS
```

این مقدارها توسط Edge Function استفاده می‌شوند.

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
