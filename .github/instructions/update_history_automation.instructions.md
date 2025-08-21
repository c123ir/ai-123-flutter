---
applyTo: "**"
---

# راهنمای اتوماسیون سیستم تاریخچه بروزرسانی

## قوانین کلی تایید و ثبت خودکار

### مراحل اجباری پس از هر تغییر

```markdown
⚠️ **مراحل اجباری پس از تغییرات اساسی:**

1. ✅ **تحلیل تغییرات** - تشخیص نوع و اهمیت تغییرات
2. 🤔 **سوال تایید تاریخچه** - آیا تاریخچه بروزرسانی آپدیت شود؟
3. 📝 **سوال تایید مستندات** - آیا مستندات پروژه بروزرسانی شود؟
4. 🔄 **سوال تایید Git** - آیا فایل‌ها به مخزن Git ارسال شود؟
```

## نحوه ثبت خودکار بروزرسانی

### Template کامل

```dart
// مثال ثبت بروزرسانی بعد از تغییرات مهم
await UpdateHistoryService.autoRegisterUpdate(
  title: 'عنوان مختصر تغییر',
  description: 'توضیح کامل تغییرات انجام شده',
  category: 'Feature|Bug Fix|UI Update|Database|Documentation',
  priority: 'High|Medium|Low',
  version: '1.2.0',
  changes: [
    'تغییر اول انجام شده',
    'تغییر دوم انجام شده',
    'تغییر سوم انجام شده',
  ],
  affectedFiles: [
    'lib/services/new_service.dart',
    'lib/models/new_model.dart',
    'README.md',
  ],
);
```

### دسته‌بندی تغییرات

| نوع تغییر           | دسته‌بندی     | اولویت      |
| ------------------- | ------------- | ----------- |
| افزودن ویژگی جدید   | Feature       | High        |
| رفع باگ             | Bug Fix       | Medium/High |
| تغییرات UI          | UI Update     | Medium      |
| تغییرات پایگاه داده | Database      | High        |
| بروزرسانی مستندات   | Documentation | Low         |
| بهینه‌سازی کد       | Optimization  | Medium      |

## متن‌های پیش‌فرض سوالات

### سوال تاریخچه بروزرسانی

```markdown
🤔 **سوال تایید تاریخچه:**

آیا می‌خواهید این تغییرات در سیستم تاریخچه بروزرسانی ثبت شود؟

✅ در صورت انتخاب "بله":

- رکورد جدید در پایگاه داده ایجاد می‌شود
- جزئیات تغییرات ذخیره می‌شود
- تاریخ و زمان شمسی ثبت می‌شود

❌ در صورت انتخاب "خیر":

- هیچ رکوردی ایجاد نمی‌شود
- تغییرات فقط در کد اعمال می‌شود
```

### سوال بروزرسانی مستندات

```markdown
🤔 **سوال تایید مستندات:**

آیا می‌خواهید مستندات پروژه بروزرسانی شود؟

📚 فایل‌هایی که بروزرسانی خواهند شد:

- README.md
- CHANGELOG.md
- API Documentation
- Database Schema
- فایل‌های Docs/

✅ در صورت انتخاب "بله":

- تمام مستندات مرتبط بروزرسانی می‌شود
- تغییرات در ساختار پروژه منعکس می‌شود

❌ در صورت انتخاب "خیر":

- مستندات دست‌نخورده باقی می‌ماند
- شما بعداً باید آن‌ها را بروزرسانی کنید
```

### سوال ارسال به Git

```markdown
🤔 **سوال تایید Git:**

آیا می‌خواهید تغییرات به مخزن Git ارسال شود؟

🔄 عملیات‌هایی که انجام خواهد شد:

1. git add . (اضافه کردن فایل‌های جدید)
2. git commit -m "پیام commit"
3. git push origin main

✅ در صورت انتخاب "بله":

- تمام تغییرات commit و push می‌شود
- تاریخچه Git بروزرسانی می‌شود

❌ در صورت انتخاب "خیر":

- تغییرات محلی باقی می‌ماند
- شما بعداً باید آن‌ها را commit کنید
```

## نمونه‌های مختلف ثبت

### 1. افزودن ویژگی جدید

```dart
await UpdateHistoryService.autoRegisterUpdate(
  title: 'اضافه کردن سیستم ارسال پیامک',
  description: 'سیستم جامع ارسال پیامک با پشتیبانی از چندین سامانه و ثبت لاگ کامل',
  category: 'Feature',
  priority: 'High',
  version: '1.2.0',
  changes: [
    'افزودن SmsService با قابلیت ارسال پیامک',
    'ایجاد SmsPanel برای مدیریت پیامک‌ها',
    'افزودن مدل‌های SmsProvider و SmsLog',
    'بروزرسانی پایگاه داده با جداول جدید',
  ],
  affectedFiles: [
    'lib/services/sms_service.dart',
    'lib/widgets/sms_panel.dart',
    'lib/models/sms_provider.dart',
    'lib/database/database_helper.dart',
  ],
);
```

### 2. رفع باگ

```dart
await UpdateHistoryService.autoRegisterUpdate(
  title: 'رفع مشکل تبدیل اعداد فارسی',
  description: 'حل مشکل تبدیل نشدن اعداد فارسی و عربی در سیستم ارسال پیامک',
  category: 'Bug Fix',
  priority: 'High',
  version: '1.1.1',
  changes: [
    'افزودن PersianNumberUtils برای تبدیل اعداد',
    'تکمیل منطق تبدیل در SmsService',
    'اصلاح regex برای شناسایی شماره‌های موبایل',
  ],
  affectedFiles: [
    'lib/utils/persian_number_utils.dart',
    'lib/services/sms_service.dart',
  ],
);
```

### 3. بروزرسانی UI

```dart
await UpdateHistoryService.autoRegisterUpdate(
  title: 'بهبود رابط کاربری داشبورد مدیریت',
  description: 'طراحی مجدد داشبورد مدیریت با کارت‌های جدید و منوی بهبود یافته',
  category: 'UI Update',
  priority: 'Medium',
  version: '1.1.2',
  changes: [
    'طراحی مجدد کارت‌های داشبورد',
    'افزودن انیمیشن‌های smooth',
    'بهبود responsive design برای mobile',
    'اضافه کردن dark mode support',
  ],
  affectedFiles: [
    'lib/screens/admin_dashboard.dart',
    'lib/widgets/dashboard_card.dart',
    'lib/utils/theme_data.dart',
  ],
);
```

## اسکریپت خودکار

برای ثبت سریع‌تر، از فایل `auto_register_update.dart` استفاده کنید:

```bash
# اجرای مستقیم
dart run auto_register_update.dart

# یا از طریق Flutter
flutter run auto_register_update.dart
```

> **نکته مهم:** همیشه پس از تغییرات اساسی، این سه سوال را مطرح کنید و عملیات را فقط پس از تایید کاربر انجام دهید.
