# NtLfyIraniCore Deployer

یک اسکریپت سبک و مرتب برای دپلوی دستی پروژه‌ی **NtLfyIraniCore** روی Netlify، بدون اتصال GitHub به Netlify.

این ابزار فقط ۴ مقدار از شما می‌گیرد و بقیه مراحل را خودش انجام می‌دهد:

- دامنه سرور اصلی
- مسیر دسترسی
- زمان Timeout
- توکن Netlify

<p align="center">
  <b>Developed by LoaTary</b>
</p>

---

## امکانات

- ساخت خودکار سایت Netlify با نام تصادفی
- دریافت سورس NtLfyIraniCore از GitHub
- تنظیم خودکار `UPSTREAM_BASE`
- تنظیم خودکار `ACCESS_PATH`
- تنظیم خودکار `REQUEST_TIMEOUT_MS`
- تزریق fallback داخل Edge Function برای جلوگیری از خطای ENV
- نصب خودکار Node.js و ابزارهای لازم روی Ubuntu
- دپلوی Production
- نمایش لینک نهایی Relay
- لاگ‌گیری مرتب

---

## پیش‌نیاز

یک سرور Ubuntu و یک Netlify Personal Access Token کافی است.

مسیر ساخت توکن در Netlify:

```text
User settings → Applications → Personal access tokens → New access token
```

---

## نصب و اجرا روی Ubuntu

```bash
sudo apt update
sudo apt install -y git
git clone https://github.com/LoaTary/NtLfyIraniCore-Deployer.git
cd NtLfyIraniCore-Deployer
chmod +x ntlfy-deployer.sh
sudo ./ntlfy-deployer.sh
```

اگر نام ریپازیتوری متفاوت است، فقط آدرس `git clone` را با آدرس ریپازیتوری خودتان جایگزین کنید.

---

## مقادیر موردنیاز هنگام اجرا

نمونه:

```text
Upstream Domain: https://titus2.babanaghash.ir:443
Access Path: /titus
Timeout MS: 120000
Netlify Token: nfp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

---

## خروجی نهایی

بعد از پایان دپلوی، خروجی شبیه این نمایش داده می‌شود:

```text
Relay URL    : https://titus-relay-xxxxxxxx.netlify.app/titus
Admin URL    : https://app.netlify.com/projects/titus-relay-xxxxxxxx
```

جریان نهایی:

```text
https://titus-relay-xxxxxxxx.netlify.app/titus
↓
https://titus2.babanaghash.ir:443/titus
```

---

## SNI پیشنهادی

```text
kubernetes.io
helm.sh
letsencrypt.org
```

---

## لاگ‌ها

```text
/root/ntlfy-deployer.log
/root/ntlfy-deploy.log
```

مشاهده آخرین خطاها:

```bash
tail -n 120 /root/ntlfy-deployer.log
tail -n 120 /root/ntlfy-deploy.log
```

---

## نکته

اگر تست نهایی با `curl` کد `404` برگرداند، همیشه به معنی خراب بودن Relay نیست. در بعضی سرویس‌ها مسیر upstream برای درخواست GET معمولی پاسخ خاصی نمی‌دهد و تست اصلی باید با کلاینت واقعی انجام شود.
