# تاریخچه تغییرات (CHANGELOG)
## دستیار هوشمند یک دو سه

تمامی تغییرات مهم این پروژه در این فایل مستند می‌شود.

فرمت بر اساس [Keep a Changelog](https://keepachangelog.com/fa/1.0.0/) و این پروژه از [Semantic Versioning](https://semver.org/) پیروی می‌کند.

---

## [1.3.0] - 2025-08-22

### Changed
- 🗄️ **مهاجرت کامل از SQLite به MySQL:**
  - حذف کامل SQLite و dependencies مربوطه
  - پیاده‌سازی MySQLAdapter برای ارتباط با API
  - DatabaseManager بروزرسانی شده با Singleton pattern
  - معماری یکپارچه برای تمام پلتفرم‌ها (Web/Desktop/Mobile)

### Added
- 🔧 **Backend API سرور:**
  - Node.js + Express + MySQL سرور کامل
  - RESTful API endpoints برای SMS و Update History
  - Authentication با API keys
  - CORS handling برای Flutter Web
  - Error handling و logging جامع

- 🏗️ **معماری جدید Database:**
  - `database_adapter.dart`: رابط انتزاعی
  - `mysql_adapter.dart`: HTTP API integration
  - `database_manager.dart`: مدیریت کننده واحد
  - Schema کامل MySQL با بهینه‌سازی

### Enhanced
- ⚡ **بهبود عملکرد:**
  - همگام‌سازی فوری داده‌ها در همه دستگاه‌ها
  - مقیاس‌پذیری برای هزاران کاربر
  - یکپارچگی داده‌ها بین پلتفرم‌ها
  - کاهش پیچیدگی کد

### Removed
- ❌ **حذف Dependencies:**
  - `sqflite_common_ffi`
  - `sqflite_common_ffi_web` 
  - تمام کدهای SQLite محلی

---

## [1.2.0] - 2025-08-21

### Added
- 🔢 **سیستم تبدیل اعداد فارسی (Persian Number Conversion System):**
  - ابزار کامل `PersianNumberUtils` برای تبدیل اعداد فارسی/عربی به انگلیسی
  - تبدیل خودکار در تمام بخش‌های پیامک
  - پشتیبانی از شماره موبایل، کد ملی، کد تایید و متن‌های مخلوط
  - اعتبارسنجی هوشمند شماره موبایل ایرانی
  - فرمت‌بندی خودکار شماره‌ها (حذف فاصله، خط تیره، کد کشور)

- 🛠️ **ابزارهای جدید:**
  - `formatIranianMobile()`: فرمت کردن شماره موبایل ایرانی
  - `convertToEnglish()`: تبدیل اعداد فارسی/عربی به انگلیسی
  - `convertToPersian()`: تبدیل اعداد انگلیسی به فارسی
  - `extractEnglishNumbers()`: استخراج فقط اعداد از متن
  - `isValidIranianMobile()`: بررسی صحت شماره موبایل
  - `getCurrentPersianDate()`: تاریخ فارسی برای لاگ‌ها

### Enhanced
- 📱 **بهبود سیستم پیامک:**
  - ارسال موفق با شماره‌های فارسی/عربی
  - تمیزکاری خودکار ورودی‌ها در `SmsService`
  - نمایش لاگ‌های بهبود یافته با تاریخ فارسی
  - ذخیره شماره‌های تمیز شده در پایگاه داده

- 🔐 **حل مشکل macOS Network Permissions:**
  - اضافه کردن `com.apple.security.network.client` به entitlements
  - رفع خطای "Operation not permitted" در macOS App Sandbox
  - بهبود error handling برای مشکلات شبکه

### Fixed
- ❌ **رفع مشکل ارسال با اعداد فارسی:**
  - قبلاً شماره‌های فارسی باعث خطا می‌شدند
  - اکنون تمام اعداد خودکار به انگلیسی تبدیل می‌شوند
  - پشتیبانی از فرمت‌های مختلف ورودی

- 🔧 **بهبود پایداری:**
  - مدیریت بهتر خطاهای شبکه
  - پیام‌های خطای کاربرپسند
  - لاگ‌گذاری جامع‌تر برای debugging

### Documentation
- 📚 **بروزرسانی مستندات:**
  - اضافه کردن بخش تبدیل اعداد فارسی در `SMS_Documentation.md`
  - بروزرسانی `README.md` با مثال‌های جدید
  - مثال‌های کاربرد ابزار تبدیل اعداد
  - جدول فرمت‌های پشتیبانی شده

## [1.1.0] - 2024-08-22

### Added
- 📱 **سیستم مدیریت پیامک (SMS Management System):**
  - پشتیبانی از سامانه پیامکی ۰۰۹۸
  - ارسال پیامک تکی و انبوه
  - لاگ کامل تمام ارسال‌ها
  - آمار و گزارش‌گیری جامع
  - تست اتصال سامانه‌ها
  - رابط کاربری کامل با ۴ تب مختلف

- 🗄️ **جداول جدید پایگاه داده:**
  - `sms_providers`: مدیریت سامانه‌های پیامکی
  - `sms_configs`: تنظیمات سامانه‌ها
  - `sms_logs`: لاگ ارسال پیامک‌ها

- 📋 **مدل‌های جدید:**
  - `SmsProvider`: مدل سامانه پیامکی
  - `SmsConfig`: مدل تنظیمات
  - `SmsLog`: مدل لاگ پیامک

- 🔧 **سرویس‌ها:**
  - `SmsService`: سرویس کامل مدیریت پیامک
  - پشتیبانی از API سامانه ۰۰۹۸
  - انتخاب خودکار بهترین سامانه بر اساس اولویت

- 🎨 **کامپوننت‌های UI:**
  - `SmsPanel`: پنل کامل مدیریت پیامک
  - تب ارسال تکی
  - تب ارسال انبوه
  - تب تاریخچه با فیلتر
  - تب آمار و تست سامانه‌ها

- 📖 **مستندات:**
  - مستندات کامل سیستم پیامک در `Docs/SMS_Documentation.md`
  - مثال استفاده در `example/sms_example.dart`
  - بروزرسانی README.md

### Enhanced
- 🔄 **GitHub Copilot Integration:**
  - راهنمای کامل توسعه فارسی‌محور
  - قوانین جامع برای مدل‌ها، سرویس‌ها و ویجت‌ها
  - پشتیبانی RTL و تاریخ شمسی
  - الزام استفاده از زبان فارسی در ارتباطات

- 📦 **Dependencies:**
  - اضافه شدن پکیج `http` برای ارتباط با سامانه‌های پیامکی

### Technical Details
- **سامانه ۰۰۹۸ تنظیمات:**
  - Username: `zsms8829`
  - From: `3000164545`
  - API URL: `https://api.0098sms.com/sendsms.aspx`

---

## [1.0.0] - 2024-08-21

### Added
- 🎉 **اولین نسخه رسمی پروژه**
- 🏗️ **معماری کلی پروژه:**
  - پنل مدیریت (Admin Dashboard) با رسپانسیو دیزاین
  - اپلیکیشن مشتری (Customer App) موبایل
  - سیستم routing بر اساس سایز صفحه (>800px = Admin, <800px = Customer)

### Frontend (Flutter)
- ✅ **UI/UX کامل:**
  - Sidebar مدیریت با glassmorphism effect
  - Dashboard cards با آمار real-time
  - نمودارهای تحلیلی (DashboardGraph)
  - طراحی minimal و light theme
  - پشتیبانی کامل RTL برای فارسی

- ✅ **کامپوننت‌های UI:**
  - `AdminSidebar`: منوی کناری با 11 گزینه مختلف
  - `DashboardCard`: کارت‌های آماری با ایکون و گرادیانت
  - `DashboardGraph`: نمودار خطی ساده با CustomPainter
  - Responsive layout برای desktop/mobile

- ✅ **فونت و Typography:**
  - فونت Vazirmatn برای پشتیبانی بهتر فارسی
  - Directionality راست به چپ
  - تنظیمات فونت در pubspec.yaml

### Backend & Database
- 🗄️ **مدل‌های داده:**
  - `User`: مدیریت کاربران با نقش‌های مختلف
  - `Product`: مدیریت محصولات
  - `Consultation`: سیستم مشاوره
  - `AiChat`: چت‌های هوش مصنوعی
  - `CrmContact`: مدیریت ارتباط با مشتری

- 🔧 **سرویس‌ها:**
  - `UserService`: عملیات CRUD کاربران
  - `ProductService`: مدیریت محصولات
  - `AiService`: پردازش پیام‌های AI
  - `ApiService`: کلاینت HTTP برای ارتباط با سرور

- 💾 **بانک اطلاعاتی:**
  - `DatabaseHelper`: مدیریت SQLite محلی
  - Schema کامل با 8 جدول اصلی
  - آماده‌سازی برای همگام‌سازی با MySQL

### Features
- 🤖 **هوش مصنوعی:**
  - چت بات پایه با پاسخ‌های از پیش تعریف شده
  - سیستم توصیه محصول بر اساس کلمات کلیدی
  - ذخیره تاریخچه چت‌ها

- 📊 **داشبورد مدیریت:**
  - نمایش آمار فروش، کاربران، مشاوره‌ها
  - نمودارهای روند فروش و جذب مشتری
  - کارت‌های آماری رنگی با ایکون

- 🎯 **منوهای مدیریت:**
  - داشبورد اصلی
  - مدیریت مشتریان
  - مدیریت فروش
  - دستیار مشاوره
  - مدیریت کاربران
  - مدیریت تگ‌ها
  - مدیریت پرسنل
  - سرمایه‌گذاران
  - مدیریت توکن مانیبل (جدید)
  - گزارشات
  - تنظیمات

### Technical Improvements
- 📱 **پشتیبانی چندپلتفرمه:**
  - Android, iOS (موبایل)
  - Windows, macOS, Linux (دسکتاپ)
  - Chrome, Firefox, Safari (وب)

- 🎨 **طراحی:**
  - Material Design 3
  - Color palette minimal و light
  - Gradient backgrounds
  - Box shadows و border radius های مناسب

- ⚡ **Performance:**
  - ساختار widget های بهینه
  - استفاده از const constructors
  - Lazy loading آماده

### Dependencies
- `flutter`: SDK اصلی
- `cupertino_icons`: آیکون‌های iOS
- `sqflite`: بانک اطلاعاتی محلی
- `path`: مدیریت مسیرها
- `http`: درخواست‌های شبکه
- `json_annotation`: سریالایزیشن JSON

### Development Dependencies  
- `flutter_test`: تست‌های واحد
- `flutter_lints`: بررسی کیفیت کد
- `json_serializable`: تولید کد JSON
- `build_runner`: ابزار build

### Documentation
- 📚 **مستندات کامل:**
  - `README.md`: راهنمای اصلی پروژه
  - `api-guide.md`: مستندات کامل API
  - `database-guide.md`: راهنمای بانک اطلاعاتی
  - `ui-components.md`: مستندات کامپوننت‌های UI
  - `faq.md`: سوالات متداول
  - `CHANGELOG.md`: تاریخچه تغییرات

### Project Structure
```
lib/
├── components/     # کامپوننت‌های عمومی
├── database/       # مدیریت SQLite
├── models/         # مدل‌های داده
├── screens/        # صفحات اصلی
├── services/       # سرویس‌ها و API
├── widgets/        # ویجت‌های سفارشی
└── main.dart       # نقطه ورود
```

### Known Issues
- ⚠️ **Deprecation Warnings:** استفاده از `withOpacity()` که باید به `withValues()` تغییر کند
- 🔧 **AI Service:** فعلاً شبیه‌سازی محلی است، نیاز به اتصال به API واقعی
- 📡 **API Integration:** آماده برای اتصال به سرور اما فعلاً local data

### Planned Features
- 🔄 **همگام‌سازی آفلاین/آنلاین**
- 🔔 **Push Notifications**
- 🧪 **Unit و Integration Tests**
- 🌙 **Dark Theme**
- 📊 **Advanced Analytics**
- 🎨 **Theme Customization**

---

## [نسخه‌های آینده]

### [1.1.0] - پیش‌بینی برای مهر 1404
#### Planned
- 🔗 **اتصال به API واقعی**
- 🤖 **ادغام با OpenAI GPT**
- 📱 **بهبود رابط کاربری موبایل**
- 🔐 **سیستم احراز هویت کامل**

### [1.2.0] - پیش‌بینی برای آبان 1404
#### Planned
- 📋 **سیستم فرم‌ساز کامل**
- 💳 **درگاه پرداخت**
- 📊 **گزارش‌گیری پیشرفته**
- 🎭 **چندزبانه (فارسی/انگلیسی)**

### [2.0.0] - پیش‌بینی برای زمستان 1404
#### Planned
- 🏗️ **معماری Microservices**
- ☁️ **Cloud Integration**
- 📈 **Advanced Analytics Dashboard**
- 🤖 **Custom AI Training**

---

## راهنمای مشارکت

### نوع تغییرات:
- `Added`: ویژگی‌های جدید
- `Changed`: تغییرات در ویژگی‌های موجود
- `Deprecated`: ویژگی‌هایی که به زودی حذف می‌شوند
- `Removed`: ویژگی‌های حذف شده
- `Fixed`: رفع باگ‌ها
- `Security`: رفع مشکلات امنیتی

### Format نسخه‌گذاری:
- `Major.Minor.Patch` (مثال: 1.2.3)
- Major: تغییرات breaking
- Minor: ویژگی‌های جدید
- Patch: رفع باگ‌ها

---

**تیم توسعه:** دستیار هوشمند یک دو سه  
**تاریخ شروع پروژه:** ۳۰ مرداد ۱۴۰۴  
**آخرین به‌روزرسانی:** ۳۰ مرداد ۱۴۰۴
