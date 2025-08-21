---
mode: ask
---

# پرامپت اصلی پروژه Smart Assistant 123

## Main Development Prompt for Smart Assistant 123 Project

---

## 🎯 هدف پروژه (Project Objective)

شما در حال کمک به توسعه پروژه "دستیار هوشمند یک دو سه" هستید که یک سیستم مدیریت کسب‌وکار با قابلیت‌های هوش مصنوعی است.

---

## 🗣️ نحوه ارتباط (Communication Guidelines)

### زبان مکالمه

- **همیشه به زبان فارسی** در چت و توضیحات پاسخ دهید
- از اصطلاحات فنی فارسی استفاده کنید
- کدها به انگلیسی اما کامنت‌ها به فارسی

### سبک گفتگو

- محترمانه و دوستانه
- توضیح گام به گام
- پرسش برای تایید قبل از اقدام

---

## 📋 فرآیند کاری (Workflow Process)

### قبل از شروع کدنویسی

1. **شرح برنامه:** توضیح دهید چه کاری قرار است انجام دهید
2. **تایید:** منتظر تایید کاربر باشید
3. **جزئیات:** خلاصه‌ای از مراحل کار ارائه دهید

### مثال فرآیند:

```
🔍 برنامه کاری:
برای اضافه کردن قابلیت احراز هویت، من قصد دارم:
1. ایجاد AuthService در lib/services/
2. اضافه کردن صفحه لاگین
3. بروزرسانی مستندات API
4. نوشتن تست‌های مربوطه

آیا با این برنامه موافق هستید؟
```

---

## 🏗️ استانداردهای کدنویسی (Coding Standards)

### ساختار فایل‌ها

```dart
// lib/services/auth_service.dart
// سرویس احراز هویت کاربران - مدیریت login/logout و token management

import 'package:flutter/material.dart';

/// سرویس مدیریت احراز هویت
class AuthService {
  // کدهای سرویس...
}
```

### کامنت‌نویسی

- سطر اول: نام فایل، مسیر و توضیح کاربرد
- کامنت‌های داخل کد: به فارسی
- DocString ها: شامل توضیح فارسی

### مثال کامنت‌گذاری:

```dart
/// ورود کاربر به سیستم
///
/// [email] ایمیل کاربر
/// [password] رمز عبور
///
/// برمی‌گرداند: true در صورت موفقیت، false در غیر این صورت
Future<bool> login(String email, String password) async {
  try {
    // بررسی اعتبار ایمیل
    if (!_isValidEmail(email)) {
      _logError('ورود', 'فرمت ایمیل نامعتبر است');
      return false;
    }

    // ارسال درخواست به سرور
    final response = await _apiCall(email, password);

    return response.isSuccess;
  } catch (e) {
    _logError('ورود', 'خطا در ارتباط با سرور: $e');
    return false;
  }
}
```

---

## 🌐 قوانین فارسی‌سازی (Persian Localization)

### UI متون

```dart
Text(
  'خوش آمدید',
  textDirection: TextDirection.rtl,
  style: TextStyle(
    fontFamily: 'Vazirmatn',
    fontSize: 16,
  ),
)
```

### تاریخ شمسی

```dart
import 'package:shamsi_date/shamsi_date.dart';

String getCurrentPersianDate() {
  final now = Jalali.now();
  return '${now.day} ${now.monthName} ${now.year}';
}
```

### اعداد فارسی

```dart
import 'package:persian_number_utility/persian_number_utility.dart';

String formatPersianNumber(int number) {
  return number.toString().toPersianDigit();
}
```

---

## 📝 مدیریت مستندات (Documentation Management)

### بروزرسانی اجباری

پس از هر تغییر اساسی، این فایل‌ها باید بروزرسانی شوند:

- `README.md`
- `Docs/api-guide.md`
- `Docs/database-guide.md`
- `CHANGELOG.md`

### فرمت مستندات

````markdown
## نام قابلیت (Feature Name)

### توضیح

توضیح کاملی از عملکرد

### نحوه استفاده

\```dart
// مثال کد
\```

### پارامترها

- `param1`: توضیح پارامتر اول
- `param2`: توضیح پارامتر دوم
````

---

## 🔄 مدیریت Git و GitHub

### Commit Messages

```
feat: اضافه کردن قابلیت احراز هویت
fix: رفع مشکل در صفحه داشبورد
docs: بروزرسانی مستندات API
style: اصلاح فرمت کد و کامنت‌ها
```

### استفاده از Scripts

```bash
# ارسال سریع
./scripts/quick-push.sh "feat: اضافه کردن قابلیت جدید"

# ایجاد release
./scripts/create-release.sh minor
```

---

## 🧪 استانداردهای تست (Testing Standards)

### نام‌گذاری تست‌ها

```dart
group('تست‌های سرویس احراز هویت', () {
  test('باید کاربر را با موفقیت وارد کند', () async {
    // تست کد...
  });

  test('باید خطای مناسب برای رمز اشتباه نمایش دهد', () async {
    // تست کد...
  });
});
```

---

## 🐛 لاگ‌گذاری (Logging)

### سطوح لاگ

```dart
enum LogLevel {
  اطلاعات,    // INFO
  هشدار,      // WARNING
  خطا,        // ERROR
  موفقیت      // SUCCESS
}

void logMessage(LogLevel level, String operation, String message) {
  final persianDate = getCurrentPersianDate();
  final levelText = level.toString().split('.').last;
  print('[$persianDate] [$levelText] $operation: $message');
}
```

### استفاده:

```dart
logMessage(LogLevel.اطلاعات, 'احراز هویت', 'شروع فرآیند ورود کاربر');
logMessage(LogLevel.خطا, 'احراز هویت', 'خطا در اتصال به سرور');
```

---

## 🚀 عملکرد و بهینه‌سازی (Performance)

### بررسی‌های لازم

- استفاده از `const` برای ویجت‌های ثابت
- مدیریت حافظه در `dispose()` methods
- Cache کردن داده‌های تکراری
- بهینه‌سازی تصاویر

---

## 📱 پلتفرم‌های هدف (Target Platforms)

### اولویت توسعه

1. **Web** - اولویت اول (داشبورد مدیریت)
2. **Android** - اولویت دوم (اپ مشتری)
3. **iOS** - اولویت سوم
4. **Desktop** - اولویت چهارم

---

## 🎨 استانداردهای UI/UX

### Material Design 3

- استفاده از `Material 3` components
- رنگ‌بندی consistent
- Animation های smooth

### RTL Support

```dart
MaterialApp(
  localizationsDelegates: [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: [
    Locale('fa', 'IR'),
  ],
)
```

---

## ⚠️ نکات مهم

### قبل از هر کار

1. وضعیت فعلی پروژه را بررسی کنید
2. برنامه کاری خود را شرح دهید
3. تایید کاربر را بگیرید
4. گام به گام پیش بروید

### پس از هر کار

1. کدها را تست کنید
2. مستندات را بروزرسانی کنید
3. تغییرات را commit کنید
4. نتیجه کار را گزارش دهید

---

**یادآوری:** این پرامپت برای تضمین کیفیت و هماهنگی در توسعه پروژه طراحی شده است. لطفاً در تمام مراحل کار رعایت کنید.
