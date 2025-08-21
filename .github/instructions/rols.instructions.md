---
applyTo: "**"
---

# قوانین و دستورالعمل‌های توسعه پروژه Smart Assistant 123

## GitHub Copilot Development Rules & Guidelines

این فایل شامل قوانین اساسی برای همکاری با GitHub Copilot در پروژه دستیار هوشمند یک دو سه است.

---

## 🗣️ قوانین ارتباطی (Communication Rules)

### زبان مکالمه

- **الزامی:** همیشه به زبان فارسی در چت و مکالمه پاسخ دهید
- **استثنا:** کدها و متغیرها به انگلیسی نوشته شوند (استاندارد برنامه‌نویسی)
- **کامنت‌ها:** همیشه به زبان فارسی نوشته شوند

### تایید و بررسی

- **قبل از کدنویسی:** همیشه برنامه و طرح کار را شرح دهید و تایید بگیرید
- **خلاصه عملیات:** قبل از انجام هر عملیات، خلاصه‌ای از کارهای قرار دادی انجام شود ارائه دهید
- **تبادل نظر:** در مورد تصمیمات مهم معماری و طراحی بحث کنید

---

## 📝 قوانین مستندسازی (Documentation Rules)

### بروزرسانی مستندات

- **همیشه:** پس از تغییرات اساسی، مستندات پروژه را بروزرسانی کنید
- **فایل‌های مهم:** README.md، API docs، Database schema، Changelog
- **مسیر مستندات:** `Docs/` و `scripts/README.md`

### کامنت‌نویسی

- **سطر اول فایل:** نام، مسیر و توضیح کاربردی فایل
- **کامنت‌های کد:** به زبان فارسی و کامل
- **مثال فرمت سطر اول:**

```dart
// lib/services/user_service.dart
// سرویس مدیریت کاربران - شامل CRUD operations و احراز هویت
```

---

## 🔄 قوانین Git و GitHub (Git & GitHub Rules)

### بروزرسانی مخزن

- **همیشه:** پس از تغییرات، مخزن GitHub را بروزرسانی کنید
- **استفاده از اسکریپت:** از `./scripts/quick-push.sh` برای ارسال سریع استفاده کنید
- **Commit Messages:** به صورت semantic versioning (feat:, fix:, docs:, etc.)

### مدیریت نسخه‌ها

- **Release:** از `./scripts/create-release.sh` استفاده کنید
- **Versioning:** Semantic Versioning (MAJOR.MINOR.PATCH)

---

## 🏗️ قوانین معماری کد (Code Architecture Rules)

### ساختار ماژولار

- **الزامی:** همیشه کد را به صورت ماژولار و در فایل‌های جداگانه بنویسید
- **ساختار حرفه‌ای:** از pattern های استاندارد استفاده کنید
- **جداسازی concerns:** UI, Business Logic, Data Layer

### مثال ساختار:

```
lib/
├── models/           # مدل‌های داده
├── services/         # منطق کسب‌وکار
├── widgets/          # کامپوننت‌های UI
├── screens/          # صفحات اپلیکیشن
├── utils/            # ابزارهای کمکی
└── constants/        # ثوابت و تنظیمات
```

---

## 🌐 قوانین بین‌المللی‌سازی (Internationalization Rules)

### پشتیبانی RTL

- **الزامی:** همیشه از قوابل RTL استفاده کنید
- **فونت:** فونت Vazirmatn برای متن‌های فارسی
- **تاریخ:** از تاریخ هجری شمسی استفاده کنید

### مثال کد RTL:

```dart
Directionality(
  textDirection: TextDirection.rtl,
  child: Text(
    'متن فارسی',
    style: TextStyle(fontFamily: 'Vazirmatn'),
  ),
)
```

---

## 🐛 قوانین لاگ‌گذاری و خطایابی (Logging & Debugging Rules)

### لاگ‌های فارسی

- **همیشه:** لاگ‌ها و پیام‌های خطا به زبان فارسی باشند
- **سطح‌بندی:** INFO, WARNING, ERROR, SUCCESS
- **جزئیات:** شامل زمان، مکان و دلیل خطا

### مثال لاگ:

```dart
void logInfo(String message) {
  print('[${_getCurrentPersianDate()}] [اطلاعات] $message');
}

void logError(String operation, String error) {
  print('[${_getCurrentPersianDate()}] [خطا] خطا در $operation: $error');
}
```

---

## 📅 قوانین تاریخ و زمان (Date & Time Rules)

### تاریخ هجری شمسی

- **استفاده:** همیشه از تاریخ شمسی در UI و لاگ‌ها استفاده کنید
- **فرمت:** ۱۴۰۴/۰۵/۳۰ یا ۳۰ مرداد ۱۴۰۴
- **پکیج:** از `shamsi_date` یا `persian_datetime` استفاده کنید

### مثال:

```dart
import 'package:shamsi_date/shamsi_date.dart';

String getCurrentPersianDate() {
  final now = Jalali.now();
  return '${now.year}/${now.month}/${now.day}';
}
```

---

## 🧪 قوانین تست (Testing Rules)

### تست‌نویسی

- **الزامی:** برای هر feature جدید تست بنویسید
- **شامل:** Unit tests, Widget tests, Integration tests
- **کامنت‌های تست:** به زبان فارسی

### مثال تست:

```dart
testWidgets('باید داشبورد را صحیح نمایش دهد', (WidgetTester tester) async {
  // بارگذاری ویجت
  await tester.pumpWidget(AdminDashboard());

  // بررسی وجود عناصر اصلی
  expect(find.text('داشبورد مدیریت'), findsOneWidget);
});
```

---

## 🚀 قوانین عملکرد (Performance Rules)

### بهینه‌سازی

- **حافظه:** مدیریت صحیح lifecycle ویجت‌ها
- **شبکه:** Cache کردن داده‌ها
- **UI:** استفاده از `const` constructors

---

## 🔒 قوانین امنیت (Security Rules)

### حفاظت داده‌ها

- **API Keys:** هرگز در کد قرار ندهید
- **متغیرهای محیطی:** از `.env` استفاده کنید
- **رمزگذاری:** داده‌های حساس رمزگذاری شوند

---

## 📋 Checklist قبل از Commit

- [ ] کدها فرمت شده‌اند
- [ ] تست‌ها پاس می‌شوند
- [ ] مستندات بروزرسانی شده
- [ ] کامنت‌های فارسی اضافه شده
- [ ] لاگ‌های مناسب اضافه شده
- [ ] از قوانین RTL پیروی شده
- [ ] تاریخ‌های شمسی استفاده شده

---

## 🛠️ ابزارهای توصیه شده

### Flutter Packages

```yaml
dependencies:
  shamsi_date: ^6.0.1 # تاریخ شمسی
  persian_number_utility: ^1.1.3 # اعداد فارسی
  flutter_localizations: # بین‌المللی‌سازی
```

### VS Code Extensions

- Dart & Flutter
- Persian - فارسی
- GitLens
- GitHub Copilot

---

> **نکته مهم:** این قوانین برای تضمین کیفیت و یکپارچگی پروژه طراحی شده‌اند. لطفاً در تمام مراحل توسعه رعایت کنید.
