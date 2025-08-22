# 🤖 Smart Assistant 123 - هوشمند 123

[![Flutter CI/CD](https://github.com/c123ir/ai-123-flutter├── models/            # مدل‌های داده
│   ├── user.dart
│   ├── product.dart
│   ├── consultation.dart
│   ├── ai_chat.dart
│   ├── crm_contact.dart
│   ├── sms_provider.dart    # جدید: مدل سامانه پیامک
│   ├── sms_config.dart      # جدید: تنظیمات پیامک
│   ├── sms_log.dart         # جدید: لاگ پیامک
│   └── update_history.dart  # جدید: مدل تاریخچه بروزرسانیworkflows/flutter.yml/badge.svg)](https://github.com/c1- 📖 [راهنمای کامل](./Docs/README.md)
- 🔌 [راهنمای API](./Docs/api-guide.md)
- 🗄️ [راهنمای پایگاه داده](./Docs/database-guide.md)
- 🎨 [راهنمای کامپوننت‌ها](./Docs/ui-components.md)
- 📱 [مستندات سیستم پیامک](./Docs/SMS_Documentation.md) **جدید**
- 🔢 [راهنمای سریع تبدیل اعداد فارسی](./Docs/persian_numbers_quick_guide.md) **جدید**
- 📋 [سوالات متداول](./Docs/faq.md)i-123-flutter/actions/workflows/flutter.yml)
[![Release](https://github.com/c123ir/ai-123-flutter/actions/workflows/release.yml/badge.svg)](https://github.com/c123ir/ai-123-flutter/actions/workflows/release.yml)
[![Flutter Version](https://img.shields.io/badge/Flutter-3.8.1-blue.svg)](https://flutter.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

> سیستم مدیریت هوشمند با رابط کاربری مدرن و قابلیت‌های پیشرفته

## 🌟 ویژگی‌ها

- 🎨 **رابط کاربری مدرن** با Material Design 3
- 📱 **پشتیبانی چند پلتفرم** (Android, iOS, Web, Desktop)
- 🗃️ **مدیریت پایگاه داده MySQL** با API یکپارچه
- 🔐 **سیستم احراز هویت** کاربران
- 📊 **داشبورد مدیریت** با نمودارها و آمار
- 🌐 **پشتیبانی RTL** و فونت فارسی
- 🤖 **ماژول هوش مصنوعی** قابل توسعه
- 📝 **مدیریت محتوا** و فرم‌ها
- 📱 **سیستم مدیریت پیامک** کامل با پشتیبانی چند سامانه (SMS0098، قاصدک، کاوه‌نگار)
- 📈 **آمار و گزارش‌گیری** جامع
- 🏗️ **معماری Clean Architecture** با جداسازی کامل concerns
- 🔄 **GitHub Actions** برای CI/CD خودکار
- 📋 **سیستم تاریخچه بروزرسانی** برای ردیابی تغییرات پروژه
- 🔢 **تبدیل خودکار اعداد فارسی/عربی** به انگلیسی

## 🚀 مشاهده زنده

- **🌐 نسخه وب:** [ai-123-flutter.github.io](https://c123ir.github.io/ai-123-flutter/)
- **📱 دانلود APK:** [Releases](https://github.com/c123ir/ai-123-flutter/releases/latest)

## 📋 محتویات

- [نصب و راه‌اندازی](#-نصب-و-راه‌اندازی)
- [ساختار پروژه](#-ساختار-پروژه)
- [مستندات](#-مستندات)
- [مشارکت](#-مشارکت)
- [لایسنس](#-لایسنس)

## 🛠 نصب و راه‌اندازی

### پیش‌نیازها

```bash
# Flutter SDK (3.8.1 یا بالاتر)
flutter --version

# Dart SDK 
dart --version

# Git
git --version
```

### نصب

```bash
# کلون کردن پروژه
git clone https://github.com/c123ir/ai-123-flutter.git
cd ai-123-flutter

# نصب وابستگی‌ها
flutter pub get

# اجرای پروژه
flutter run
```

### Build برای Production

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Desktop (Windows/macOS/Linux)
flutter build windows --release
flutter build macos --release
flutter build linux --release
```

## 📁 ساختار پروژه

```
lib_new/                      # معماری Clean Architecture جدید
├── core/                     # هسته سیستم  
│   ├── services/
│   │   ├── sms_service.dart         # سرویس جامع مدیریت پیامک
│   │   └── update_history_service.dart
│   ├── exceptions/
│   │   └── app_exception.dart       # مدیریت استثناها
│   └── constants/
├── features/                 # ویژگی‌های کاربردی
│   ├── admin/
│   │   ├── domain/
│   │   ├── data/
│   │   ├── presentation/
│   │   │   └── screens/
│   │   │       ├── admin_dashboard_screen.dart
│   │   │       └── sms_panel_screen.dart  # پنل مدیریت پیامک
│   │   └── screens/
│   │       └── sms_panel_screen.dart
│   └── user/
├── shared/                   # اجزای مشترک
│   ├── models/
│   │   ├── provider_configs.dart    # تنظیمات سامانه‌های پیامک
│   │   └── sms_models.dart          # مدل‌های پیامک
│   ├── widgets/
│   │   └── responsive_layout.dart
│   ├── utils/
│   │   ├── persian_number_utils.dart # تبدیل اعداد فارسی/عربی
│   │   └── theme_helper.dart
│   └── constants/
└── app/                      # تنظیمات اپلیکیشن
    ├── app.dart
    └── theme/

lib/                          # ساختار قدیمی (در حال انتقال)
├── database/                 # مدیریت پایگاه داده MySQL
│   ├── database_adapter.dart     # رابط انتزاعی دیتابیس
│   ├── mysql_adapter.dart        # آداپتور MySQL با API
│   └── database_manager.dart     # مدیریت کننده واحد
├── models/            # مدل‌های داده
│   ├── user.dart
│   ├── product.dart
│   ├── consultation.dart
│   ├── ai_chat.dart
│   ├── crm_contact.dart
│   ├── sms_provider.dart    # جدید: مدل سامانه پیامک
│   ├── sms_config.dart      # جدید: تنظیمات پیامک
│   ├── sms_log.dart         # جدید: لاگ پیامک
│   └── update_history.dart  # جدید: مدل تاریخچه بروزرسانی
│   ├── api_service.dart
│   ├── chat_service.dart
│   ├── sms_service.dart            # جدید: سرویس مدیریت پیامک
│   └── update_history_service.dart # جدید: سرویس تاریخچه بروزرسانی
├── screens/          # صفحات اپلیکیشن
│   ├── admin_dashboard.dart
│   ├── chat_screen.dart
│   ├── sms_management_screen.dart  # جدید: صفحه مدیریت پیامک
│   └── update_history_screen.dart  # جدید: صفحه تاریخچه بروزرسانی
├── widgets/           # کامپوننت‌های UI
│   ├── user_profile.dart
│   ├── product_card.dart
│   ├── chat_widget.dart
│   ├── sms_panel.dart       # جدید: پنل مدیریت پیامک
│   ├── update_history_card.dart  # جدید: کارت نمایش بروزرسانی
│   └── add_update_dialog.dart    # جدید: دیالوگ افزودن بروزرسانی
├── utils/             # ابزارهای کمکی
│   ├── constants.dart
│   ├── helpers.dart
│   ├── validators.dart
│   └── persian_number_utils.dart  # جدید: تبدیل اعداد فارسی/عربی به انگلیسی

backend/              # Backend API سرور
├── server.js         # Node.js + Express API
├── schema.sql        # MySQL Database Schema
└── package.json      # Node.js Dependencies
```
├── scripts/           # اسکریپت‌های کمکی
│   ├── auto_register_update.dart  # جدید: ثبت خودکار بروزرسانی
│   ├── quick-push.sh
│   └── create-release.sh
└── main.dart

.github/
├── workflows/         # GitHub Actions
│   ├── flutter.yml    # CI/CD workflow
│   ├── release.yml    # Release automation
│   └── auto-update.yml
├── instructions/      # راهنمای GitHub Copilot
│   ├── rols.instructions.md
│   ├── models.instructions.md
│   ├── services.instructions.md
│   ├── widgets.instructions.md
│   └── database.instructions.md
└── prompts/          # Prompts برای AI
    ├── prompt01.prompt.md
    └── testing.prompt.md

scripts/              # اسکریپت‌های اتوماسیون
├── quick-push.sh     # ارسال سریع به Git
├── create-release.sh # ایجاد نسخه جدید
└── sync-upstream.sh  # همگام‌سازی با upstream

Docs/                 # مستندات
├── API_Documentation.md
├── Database_Schema.md
├── Deployment_Guide.md
├── SMS_Documentation.md  # جدید: مستندات سیستم پیامک
└── Contributing.md

example/              # مثال‌های کاربرد
├── basic_usage.dart
└── sms_example.dart  # جدید: مثال استفاده از SMS
```
├── widgets/           # کامپوننت‌های UI
│   ├── admin_sidebar.dart
│   ├── dashboard_card.dart
│   └── dashboard_graph.dart
└── main.dart          # نقطه شروع برنامه
```

## 📚 مستندات

مستندات کامل در پوشه [`Docs/`](./Docs/) موجود است:

- 📖 [راهنمای کامل](./Docs/README.md)
- 🔌 [راهنمای API](./Docs/api-guide.md)
- 🗄️ [راهنمای پایگاه داده](./Docs/database-guide.md)
- 🎨 [راهنمای کامپوننت‌ها](./Docs/ui-components.md)
- � [مستندات سیستم پیامک](./Docs/SMS_Documentation.md) **جدید**
- �📋 [سوالات متداول](./Docs/faq.md)
- 🔄 [تاریخچه تغییرات](./Docs/CHANGELOG.md)
- 🤝 [راهنمای مشارکت](./Docs/CONTRIBUTING.md)
- 📦 [راهنمای Git و GitHub](./Docs/git-github-guide.md)

## 📱 سیستم مدیریت پیامک جامع

### 🏗️ معماری Clean Architecture

سیستم پیامک بر اساس Clean Architecture پیاده‌سازی شده با جداسازی کامل concerns:

- **Core Layer**: سرویس‌های اصلی و منطق کسب‌وکار
- **Features Layer**: ویژگی‌های کاربردی (Admin Panel)
- **Shared Layer**: اجزای مشترک و ابزارهای کمکی

### ✨ ویژگی‌های کلیدی
- 🔄 **چند سامانه**: SMS0098، قاصدک (Ghasedak)، کاوه‌نگار (Kavenegar)
- 📤 **ارسال تکی و انبوه**: ارسال به یک یا چندین مخاطب
- 📊 **آمار real-time**: نمایش آنی آمار ارسال و دریافت
- 🔍 **لاگ جامع**: ثبت تمام فعالیت‌ها با جزئیات کامل
- 🎯 **انتخاب هوشمند**: انتخاب خودکار بهترین سامانه
- 🧪 **تست اتصال**: آزمایش عملکرد تمام سامانه‌ها
- 🔢 **تبدیل اعداد هوشمند**: تبدیل خودکار اعداد فارسی/عربی به انگلیسی
- ✅ **اعتبارسنجی شماره**: بررسی صحت شماره موبایل ایرانی
- 📱 **Responsive Design**: سازگار با تمام اندازه‌های صفحه
- 🎨 **Material Design 3**: طراحی مدرن و زیبا

### 📡 سامانه‌های پشتیبانی شده

#### 1. SMS0098 (پیش‌فرض)
```dart
Sms0098Config(
  apiKey: 'your-api-key',
  lineNumber: 'your-line-number',
)
```

#### 2. قاصدک (Ghasedak)
```dart
GhasedakConfig(
  apiKey: 'your-api-key',
  lineNumber: 'your-line-number',
)
```

#### 3. کاوه‌نگار (Kavenegar)
```dart
KavenegarConfig(
  apiKey: 'your-api-key',
  sender: 'your-sender-number',
)
```

### 🚀 استفاده سریع

```dart
import 'package:ai_123/lib_new/core/services/sms_service.dart';
import 'package:ai_123/lib_new/shared/utils/persian_number_utils.dart';
import 'package:ai_123/lib_new/shared/models/provider_configs.dart';

// مقداردهی اولیه سرویس
final smsService = SmsService();

// تنظیم سامانه‌های پیامک
await smsService.setupProvider(
  SmsProviderType.sms0098,
  Sms0098Config(
    apiKey: 'your-api-key',
    lineNumber: 'your-line-number',
  ),
);

// ارسال پیامک ساده
final result = await smsService.sendSms(
  phone: '۰۹۱۳۲۳۲۳۱۲۳',  // شماره فارسی (خودکار تبدیل می‌شود)
  message: 'کد تایید شما: ۱۲۳۴',  // اعداد فارسی خودکار تبدیل می‌شوند
  provider: SmsProviderType.sms0098,
);

if (result.isSuccess) {
  print('پیامک با موفقیت ارسال شد');
} else {
  print('خطا: ${result.error}');
}

// ارسال انبوه
await smsService.sendBulkSms(
  phones: ['۰۹۱۲۳۴۵۶۷۸۹', '۰۹۸۷۶۵۴۳۲۱'],
  message: 'پیام انبوه برای همه',
);

// دریافت آمار
final stats = await smsService.getStatistics();
print('تعداد ارسال موفق: ${stats.successCount}');
print('تعداد ارسال ناموفق: ${stats.failedCount}');
```

### 🎨 رابط کاربری Admin Panel

```dart
import 'package:ai_123/lib_new/features/admin/screens/sms_panel_screen.dart';

// نمایش پنل مدیریت پیامک
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const SmsPanelScreen(),
  ),
);
```

#### قابلیت‌های Panel:
- **فرم ارسال پیامک**: با validation کامل
- **آمار real-time**: نمایش آنی وضعیت سامانه‌ها
- **لیست لاگ‌ها**: مشاهده تاریخچه ارسال‌ها
- **تست اتصال**: بررسی وضعیت تمام سامانه‌ها
- **Responsive Layout**: سازگار با دسکتاپ و موبایل

### 🔧 تنظیمات پیشرفته

#### تبدیل اعداد فارسی/عربی
```dart
import 'package:ai_123/lib_new/shared/utils/persian_number_utils.dart';

// تبدیل شماره موبایل
String phone = PersianNumberUtils.formatIranianMobile('۰۹۱۳۲۳۲۳۱۲۳');
// نتیجه: "09132323123"

// تبدیل متن
String text = PersianNumberUtils.convertToEnglish('کد: ۱۲۳۴');
// نتیجه: "کد: 1234"

// اعتبارسنجی شماره
bool isValid = PersianNumberUtils.isValidIranianMobile('۰۹۱۳۲۳۲۳۱۲۳');
// نتیجه: true
```

### 📋 مثال‌های کامل
- [`lib_new/features/admin/screens/sms_panel_screen.dart`](./lib_new/features/admin/screens/sms_panel_screen.dart): پنل مدیریت کامل
- [`lib_new/core/services/sms_service.dart`](./lib_new/core/services/sms_service.dart): سرویس جامع SMS
- [`example/sms_example.dart`](./example/sms_example.dart): مثال‌های کاربردی
- [`example/persian_numbers_example.dart`](./example/persian_numbers_example.dart): مثال‌های تبدیل اعداد

## 🔧 تنظیمات توسعه

### VS Code Extensions

```json
{
  "recommendations": [
    "dart-code.flutter",
    "dart-code.dart-code",
    "ms-vscode.vscode-json",
    "bradlc.vscode-tailwindcss"
  ]
}
```

### GitHub Actions

پروژه شامل workflow های خودکار برای:

- ✅ **CI/CD Pipeline** - تست و build خودکار
- 🚀 **Release Management** - انتشار نسخه جدید
- 🔄 **Auto Update** - بروزرسانی وابستگی‌ها
- 🔒 **Security Audit** - بررسی امنیتی

### GitHub Copilot Integration

پروژه شامل قوانین کامل برای GitHub Copilot:

- 🤖 **Instructions** - قوانین توسعه برای مدل‌ها، سرویس‌ها، ویجت‌ها و دیتابیس
- 🎯 **Prompts** - راهنماهای جامع برای کدنویسی و تست‌نویسی
- 🗣️ **Persian-First** - الزام استفاده از زبان فارسی در ارتباطات
- 🌐 **RTL Support** - پشتیبانی کامل از راست‌به‌چپ و فونت Vazirmatn
- 📅 **Shamsi Date** - استفاده از تاریخ هجری شمسی

## 🤝 مشارکت

ما از مشارکت شما استقبال می‌کنیم! لطفاً:

1. پروژه را Fork کنید
2. Branch جدید ایجاد کنید (`git checkout -b feature/AmazingFeature`)
3. تغییرات را Commit کنید (`git commit -m 'Add: Amazing Feature'`)
4. Branch را Push کنید (`git push origin feature/AmazingFeature`)
5. Pull Request ایجاد کنید

برای اطلاعات بیشتر [راهنمای مشارکت](./Docs/CONTRIBUTING.md) را مطالعه کنید.

## 📱 اسکرین‌شات‌ها

| داشبورد مدیریت | پنل کاربری | رابط موبایل |
|---|---|---|
| ![Admin Dashboard](https://via.placeholder.com/300x200?text=Admin+Dashboard) | ![User Panel](https://via.placeholder.com/300x200?text=User+Panel) | ![Mobile UI](https://via.placeholder.com/300x200?text=Mobile+UI) |

## 🏆 ویژگی‌های پیشرفته

- 🎯 **Performance Optimized** - بهینه‌سازی حافظه و سرعت
- 🔒 **Security First** - رمزگذاری و امنیت داده‌ها
- 📊 **Analytics Ready** - آماده برای تحلیل داده
- 🌍 **Internationalization** - پشتیبانی چند زبانه
- ♿ **Accessibility** - سازگار با ابزارهای کمکی

## 📋 مدیریت تاریخچه بروزرسانی

### 🔄 ثبت خودکار تغییرات در MySQL

پروژه از سیستم تاریخچه بروزرسانی مبتنی بر MySQL استفاده می‌کند. برای ثبت تغییرات جدید:

```bash
# ثبت مستقیم در MySQL (روش ساده و سریع)
mysql -u root ai_123 -e "
INSERT INTO update_history (
    title, 
    version, 
    shamsi_date, 
    shamsi_time, 
    user_problem, 
    solution_description, 
    tags, 
    priority, 
    category, 
    status
) VALUES (
    'عنوان تغییر',
    'نسخه پروژه',
    'تاریخ شمسی',
    'زمان',
    'شرح مشکل یا نیاز',
    'شرح راه‌حل پیاده‌سازی شده',
    'برچسب‌ها جدا شده با کاما',
    'low|medium|high|critical',
    'feature|bugfix|enhancement|security|testing',
    'completed|in_progress|planned'
);"
```

### 📊 مشاهده تاریخچه

```bash
# نمایش آخرین تغییرات
mysql -u root ai_123 -e "
SELECT id, title, version, shamsi_date, priority, category 
FROM update_history 
ORDER BY id DESC 
LIMIT 10;"

# آمار کلی تاریخچه
mysql -u root ai_123 -e "
SELECT 
    category,
    COUNT(*) as count,
    priority
FROM update_history 
GROUP BY category, priority 
ORDER BY count DESC;"
```

### 🎯 مثال ثبت تغییر

```bash
# مثال کامل ثبت یک تغییر
mysql -u root ai_123 -e "
INSERT INTO update_history (
    title, 
    version, 
    shamsi_date, 
    shamsi_time, 
    user_problem, 
    solution_description, 
    tags, 
    priority, 
    category, 
    status
) VALUES (
    'اضافه کردن API جدید کاربران',
    '1.3.0',
    '۱۴۰۴/۰۶/۰۲',
    '۱۰:۳۰',
    'نیاز به API CRUD برای مدیریت کاربران',
    'پیاده‌سازی UserController با متدهای GET, POST, PUT, DELETE و validation کامل',
    'api، کاربران، crud، validation',
    'high',
    'feature',
    'completed'
);"
```

### 🔧 تنظیمات دیتابیس

دیتابیس `ai_123` با جدول `update_history` آماده است:

```sql
-- ساختار جدول تاریخچه
CREATE TABLE update_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    version VARCHAR(50) NOT NULL,
    shamsi_date VARCHAR(20) NOT NULL,
    shamsi_time VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_problem TEXT NOT NULL,
    solution_description TEXT NOT NULL,
    user_comment TEXT,
    tags TEXT,
    priority ENUM('low', 'medium', 'high', 'critical') DEFAULT 'medium',
    category ENUM('feature', 'bugfix', 'enhancement', 'security', 'testing') DEFAULT 'feature',
    status ENUM('completed', 'in_progress', 'planned') DEFAULT 'completed'
);
```

## 📞 پشتیبانی

- 📧 **ایمیل:** [support@company.com](mailto:support@company.com)
- 💬 **تلگرام:** [@username](https://t.me/username)
- 🐛 **گزارش باگ:** [Issues](https://github.com/c123ir/ai-123-flutter/issues)
- 💡 **درخواست ویژگی:** [Feature Request](https://github.com/c123ir/ai-123-flutter/issues/new?template=feature_request.md)

## 📄 لایسنس

این پروژه تحت لایسنس MIT منتشر شده است. فایل [LICENSE](LICENSE) را برای جزئیات بیشتر مطالعه کنید.

## 🙏 تشکر ویژه

- 💙 **Flutter Team** - برای framework عالی
- 🎨 **Material Design** - برای راهنمای طراحی
- 📝 **Contributors** - برای مشارکت در پروژه

---

<div align="center">
  <b>ساخته شده با ❤️ در ایران</b>
  <br>
  <sub>Smart Assistant 123 © 2025</sub>
</div>
