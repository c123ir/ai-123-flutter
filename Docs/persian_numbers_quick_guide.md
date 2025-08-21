# راهنمای سریع: ابزار تبدیل اعداد فارسی

## نصب و استفاده

```dart
import '../utils/persian_number_utils.dart';
```

## توابع اصلی

### 🔢 تبدیل اعداد

```dart
// فارسی/عربی به انگلیسی
String result = PersianNumberUtils.convertToEnglish('کد: ۱۲۳۴');
// نتیجه: 'کد: 1234'

// انگلیسی به فارسی
String result = PersianNumberUtils.convertToPersian('کد: 1234');
// نتیجه: 'کد: ۱۲۳۴'
```

### 📱 شماره موبایل

```dart
// فرمت کردن شماره موبایل ایرانی
String phone = PersianNumberUtils.formatIranianMobile('۰۹۱۳۲۳۲۳۱۲۳');
// نتیجه: '09132323123'

// بررسی صحت شماره
bool isValid = PersianNumberUtils.isValidIranianMobile('۰۹۱۳۲۳۲۳۱۲۳');
// نتیجه: true
```

### 🛠️ ابزارهای کمکی

```dart
// استخراج فقط اعداد
String numbers = PersianNumberUtils.extractEnglishNumbers('شماره: ۰۹۱۳-۲۳۲');
// نتیجه: '0913232'

// کد تایید
String code = PersianNumberUtils.formatVerificationCode('کد: ۱۲۳۴');
// نتیجه: '1234'

// تاریخ فارسی
String date = PersianNumberUtils.getCurrentPersianDate();
// نتیجه: '۱۴۰۴/۰۵/۳۰ ۱۰:۳۰'
```

## فرمت‌های پشتیبانی شده

| نوع | ورودی | خروجی |
|-----|-------|--------|
| فارسی | `۰۱۲۳۴۵۶۷۸۹` | `0123456789` |
| عربی | `٠١٢٣٤٥٦٧٨٩` | `0123456789` |
| موبایل | `۰۹۱۳۲۳۲۳۱۲۳` | `09132323123` |
| با کد کشور | `+98۹۱۳۲۳۲۳۱۲۳` | `09132323123` |
| با فاصله | `۰۹۱۳ ۲۳۲ ۳۱۲۳` | `09132323123` |

## استفاده در سیستم پیامک

```dart
// اکنون می‌توانید اعداد فارسی استفاده کنید
await smsService.sendSms(
  phone: '۰۹۱۳۲۳۲۳۱۲۳',      // ✅ خودکار تبدیل می‌شود
  message: 'کد شما: ۱۲۳۴',    // ✅ خودکار تبدیل می‌شود
);
```

## نکات مهم

- ✅ تبدیل خودکار در تمام سیستم پیامک فعال است
- ✅ تمام فرمت‌های معمول شماره موبایل پشتیبانی می‌شود
- ✅ اعتبارسنجی هوشمند شماره موبایل ایرانی
- ✅ حفظ متن غیر عددی در تبدیل
- ✅ پشتیبانی از اعداد مخلوط فارسی و عربی

## مثال‌های بیشتر

فایل [`example/persian_numbers_example.dart`](../example/persian_numbers_example.dart) را برای مثال‌های کامل‌تر مطالعه کنید.
