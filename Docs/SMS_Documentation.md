# مستندات سیستم مدیریت پیامک (SMS)

## نگاه کلی

سیستم مدیریت پیامک یک ماژول جامع برای ارسال، دریافت و مدیریت پیامک‌ها در اپلیکیشن دستیار هوشمند یک دو سه است. این سیستم از چندین سامانه پیامکی پشتیبانی می‌کند و امکان انتخاب خودکار بهترین سامانه بر اساس اولویت را فراهم می‌کند.

## ویژگی‌ها

- ✅ پشتیبانی از چندین سامانه پیامکی
- ✅ ارسال پیامک تکی و انبوه
- ✅ لاگ کامل تمام ارسال‌ها
- ✅ آمار و گزارش‌گیری
- ✅ انتخاب خودکار سامانه بر اساس اولویت
- ✅ پشتیبانی از سامانه ۰۰۹۸
- ✅ رابط کاربری فارسی و RTL
- ✅ تست اتصال سامانه‌ها

## معماری سیستم

### 1. Database Schema

```sql
-- جدول سامانه‌های پیامکی
CREATE TABLE sms_providers(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    provider_type TEXT NOT NULL,
    description TEXT,
    is_active INTEGER DEFAULT 1,
    priority INTEGER DEFAULT 0,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- جدول تنظیمات سامانه‌ها
CREATE TABLE sms_configs(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    provider_id INTEGER NOT NULL,
    config_key TEXT NOT NULL,
    config_value TEXT NOT NULL,
    is_encrypted INTEGER DEFAULT 0,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (provider_id) REFERENCES sms_providers (id),
    UNIQUE(provider_id, config_key)
);

-- جدول لاگ ارسال پیامک‌ها
CREATE TABLE sms_logs(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    provider_id INTEGER NOT NULL,
    recipient_phone TEXT NOT NULL,
    message_text TEXT NOT NULL,
    status TEXT DEFAULT 'pending',
    response_code TEXT,
    response_message TEXT,
    sent_at TEXT,
    delivered_at TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (provider_id) REFERENCES sms_providers (id)
);
```

### 2. Models

#### SmsProvider
```dart
class SmsProvider {
  final int? id;
  final String name;
  final String providerType;
  final String? description;
  final bool isActive;
  final int priority;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
```

#### SmsConfig
```dart
class SmsConfig {
  final int? id;
  final int providerId;
  final String configKey;
  final String configValue;
  final bool isEncrypted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
```

#### SmsLog
```dart
class SmsLog {
  final int? id;
  final int providerId;
  final String recipientPhone;
  final String messageText;
  final String status;
  final String? responseCode;
  final String? responseMessage;
  final DateTime? sentAt;
  final DateTime? deliveredAt;
  final DateTime? createdAt;
}
```

### 3. Services

#### SmsService
سرویس اصلی مدیریت پیامک شامل متدهای زیر:

- `getActiveProviders()`: دریافت لیست سامانه‌های فعال
- `sendSms()`: ارسال پیامک تکی
- `sendBulkSms()`: ارسال پیامک انبوه
- `getSmsHistory()`: دریافت تاریخچه پیامک‌ها
- `getSmsStats()`: دریافت آمار پیامک‌ها
- `testProvider()`: تست اتصال سامانه

### 4. Widgets

#### SmsPanel
رابط کاربری کامل مدیریت پیامک شامل:

- تب ارسال تکی
- تب ارسال انبوه
- تب تاریخچه
- تب آمار و تست سامانه‌ها

## راهنمای نصب و راه‌اندازی

### 1. Dependencies

در فایل `pubspec.yaml`:

```yaml
dependencies:
  http: ^1.1.0
  sqflite: ^2.3.0
  path: ^1.8.3
```

### 2. Database Setup

پایگاه داده به صورت خودکار با اولین اجرا ایجاد می‌شود و سامانه ۰۰۹۸ به عنوان سامانه پیش‌فرض اضافه می‌شود.

### 3. Configuration

تنظیمات سامانه ۰۰۹۸ در دیتابیس ذخیره می‌شوند:

```dart
{
  'username': 'zsms8829',
  'password': 'j494moo*O^HU',
  'from': '3000164545',
  'api_url': 'https://api.0098sms.com/sendsms.aspx'
}
```

## راهنمای استفاده

### 1. ارسال پیامک ساده

```dart
import '../services/sms_service.dart';

final smsService = SmsService();

// ارسال پیامک تکی
final result = await smsService.sendSms(
  phone: '09123456789',
  message: 'سلام، این یک پیامک تست است.'
);

if (result.isSent) {
  print('پیامک ارسال شد');
} else {
  print('خطا: ${result.responseMessage}');
}
```

### 2. ارسال پیامک انبوه

```dart
final results = await smsService.sendBulkSms(
  phones: ['09123456789', '09987654321', '09111111111'],
  message: 'پیامک انبوه تست'
);

for (final result in results) {
  print('${result.recipientPhone}: ${result.statusPersian}');
}
```

### 3. دریافت آمار

```dart
final stats = await smsService.getSmsStats();
print('کل پیامک‌ها: ${stats['total']}');
print('ارسال شده: ${stats['sent']}');
print('ناموفق: ${stats['failed']}');
```

### 4. استفاده از رابط کاربری

```dart
import '../widgets/sms_panel.dart';

// در Navigator
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const SmsPanel()),
);
```

## API سامانه ۰۰۹۸

### URL
```
https://api.0098sms.com/sendsms.aspx
```

### Parameters
- `username`: نام کاربری
- `password`: رمز عبور  
- `from`: شماره فرستنده
- `to`: شماره گیرنده
- `text`: متن پیامک

### Response Codes
- `1|reference`: موفق
- `2`: نام کاربری یا رمز عبور اشتباه
- `3`: اعتبار ناکافی
- `4`: شماره فرستنده نامعتبر
- `5`: شماره گیرنده نامعتبر
- `6`: متن خالی
- `7`: متن طولانی
- `8`: شماره در بلک لیست
- `9`: خطای سرور
- `10`: درخواست نامعتبر

## مثال کامل

```dart
import 'package:flutter/material.dart';
import '../widgets/sms_panel.dart';
import '../services/sms_service.dart';

class SmsExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نمونه سیستم پیامک',
      theme: ThemeData(fontFamily: 'Vazirmatn'),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: Text('مدیریت پیامک')),
          body: SmsPanel(),
        ),
      ),
    );
  }
}
```

## خطایابی و عیب‌یابی

### مشکلات متداول:

1. **خطای اتصال به اینترنت**
   - بررسی اتصال اینترنت دستگاه
   - بررسی تنظیمات فایروال

2. **خطای احراز هویت**
   - بررسی نام کاربری و رمز عبور
   - تماس با پشتیبانی سامانه ۰۰۹۸

3. **خطای اعتبار ناکافی**
   - شارژ حساب سامانه پیامکی

4. **شماره نامعتبر**
   - بررسی فرمت شماره تلفن
   - حذف کاراکترهای اضافی

## گسترش سیستم

### اضافه کردن سامانه جدید:

1. در جدول `sms_providers` سامانه جدید اضافه کنید
2. تنظیمات در جدول `sms_configs` ثبت کنید  
3. در `SmsService._sendXXXSms()` متد جدید اضافه کنید
4. در `switch` statement نوع جدید اضافه کنید

```dart
case 'newsms':
  final result = await _sendNewSms(provider.id!, phone, message);
  break;
```

## امنیت

- رمزهای عبور در دیتابیس رمزگذاری می‌شوند
- لاگ‌ها شامل اطلاعات حساس نیستند
- تمام ارتباطات از طریق HTTPS انجام می‌شوند

## پشتیبانی

برای مشکلات فنی و پشتیبانی با تیم توسعه تماس بگیرید.

## نسخه

نسخه فعلی: 1.0.0

## License

این پروژه تحت مجوز MIT منتشر شده است.
