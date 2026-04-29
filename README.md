# NtLfyIraniCore Deployer

یک اسکریپت سبک، مرتب و خودکار برای دپلوی دستی پروژه‌ی **NtLfyIraniCore** روی Netlify، بدون نیاز به اتصال GitHub به Netlify.

این ابزار فقط ۴ مقدار از شما دریافت می‌کند و تمام مراحل نصب، آماده‌سازی، تنظیمات و دپلوی را به‌صورت خودکار انجام می‌دهد.

**Developed by LoaTary**

---

## منبع پروژه اصلی

این Deployer بر پایه پروژه‌ی زیر آماده شده است:

[github.com/B3hnamR/NtLfyIraniCore](https://github.com/B3hnamR/NtLfyIraniCore.git)

سورس اصلی هنگام اجرا به‌صورت خودکار از GitHub دریافت شده و برای دپلوی روی Netlify آماده‌سازی می‌شود.

---

## امکانات

- ساخت خودکار سایت Netlify با نام تصادفی
- دریافت سورس NtLfyIraniCore از GitHub
- تنظیم خودکار `UPSTREAM_BASE`
- تنظیم خودکار `ACCESS_PATH`
- تنظیم خودکار `REQUEST_TIMEOUT_MS`
- تزریق fallback داخل Edge Function برای جلوگیری از خطای ENV
- نصب خودکار Node.js و ابزارهای لازم روی Ubuntu
- دپلوی Production روی Netlify
- نمایش لینک نهایی Relay
- لاگ‌گیری مرتب و قابل بررسی

---

## پیش‌نیاز

برای اجرا فقط به موارد زیر نیاز دارید:

- یک سرور Ubuntu
- یک Netlify Personal Access Token

مسیر ساخت توکن در Netlify:

```text
User settings → Applications → Personal access tokens → New access token
