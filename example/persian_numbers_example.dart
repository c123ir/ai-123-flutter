// example/persian_numbers_example.dart
// مثال کاربرد ابزار تبدیل اعداد فارسی و عربی به انگلیسی

import 'package:ai_123/utils/persian_number_utils.dart';
import 'package:ai_123/services/sms_service.dart';

/// مثال کامل استفاده از ابزار تبدیل اعداد فارسی
void main() async {
  print('=== مثال استفاده از ابزار تبدیل اعداد فارسی ===\n');

  // ===== بخش ۱: تبدیل شماره موبایل =====
  print('🔢 ۱. تبدیل شماره موبایل:');

  // شماره‌های مختلف فارسی و عربی
  List<String> phoneNumbers = [
    '۰۹۱۳۲۳۲۳۱۲۳', // فارسی کامل
    '٠٩١٣٢٣٢٣١٢٣', // عربی کامل
    '۰۹۱۳-۲۳۲-۳۱۲۳', // فارسی با خط تیره
    '09۱3۲3۲3۱2۳', // مخلوط
    '+98۹۱۳۲۳۲۳۱۲۳', // با کد کشور
    '۹۱۳۲۳۲۳۱۲۳', // بدون صفر
  ];

  for (String phone in phoneNumbers) {
    String converted = PersianNumberUtils.formatIranianMobile(phone);
    bool isValid = PersianNumberUtils.isValidIranianMobile(phone);
    print('   ورودی: $phone');
    print('   خروجی: $converted');
    print('   صحیح: ${isValid ? "✅" : "❌"}\n');
  }

  // ===== بخش ۲: تبدیل متن مخلوط =====
  print('📝 ۲. تبدیل متن مخلوط:');

  List<String> texts = [
    'کد ورود شما: ۱۲۳۴',
    'شماره سفارش: ۹۸۷۶۵۴۳',
    'مقدار: ۵۰۰ تومان',
    'تاریخ: ۱۴۰۴/۰۵/۳۰',
    'Persian: ۱۲۳ + Arabic: ٤٥٦ = Mixed!',
  ];

  for (String text in texts) {
    String converted = PersianNumberUtils.convertToEnglish(text);
    print('   اصلی: $text');
    print('   تبدیل: $converted\n');
  }

  // ===== بخش ۳: ابزارهای کمکی =====
  print('🛠️ ۳. ابزارهای کمکی:');

  String mixedInput = 'شماره تماس: ۰۹۱۳-۲۳۲-۳۱۲۳، کد: ABC۱۲۳XYZ';
  print('   ورودی: $mixedInput');
  print(
    '   فقط اعداد: ${PersianNumberUtils.extractEnglishNumbers(mixedInput)}',
  );
  print(
    '   بررسی اعداد فارسی: ${PersianNumberUtils.hasPersianOrArabicNumbers(mixedInput)}',
  );
  print('   تاریخ فارسی: ${PersianNumberUtils.getCurrentPersianDate()}\n');

  // ===== بخش ۴: استفاده در سیستم پیامک =====
  print('📱 ۴. استفاده عملی در سیستم پیامک:');

  await demonstrateSmsUsage();

  print('🎉 پایان مثال‌ها!');
}

/// نمایش استفاده در سیستم پیامک
Future<void> demonstrateSmsUsage() async {
  try {
    final smsService = SmsService();

    print('   📤 ارسال پیامک با شماره فارسی...');

    // ارسال پیامک با اعداد فارسی
    String persianPhone = '۰۹۱۳۲۳۲۳۱۲۳';
    String persianMessage = 'کد تایید شما: ۱۲۳۴\nاعتبار: ۵ دقیقه';

    print('   📞 شماره اصلی: $persianPhone');
    print('   💬 پیام اصلی: $persianMessage');

    // نمایش تبدیل خودکار
    String cleanPhone = PersianNumberUtils.formatIranianMobile(persianPhone);
    String cleanMessage = PersianNumberUtils.convertToEnglish(persianMessage);

    print('   📞 شماره تمیز: $cleanPhone');
    print('   💬 پیام تمیز: $cleanMessage');

    // در استفاده واقعی، کد زیر پیامک را ارسال می‌کند:
    /*
    final result = await smsService.sendSms(
      phone: persianPhone,      // سیستم خودکار تبدیل می‌کند
      message: persianMessage,  // سیستم خودکار تبدیل می‌کند
    );
    print('   نتیجه: ${result.status}');
    */

    print('   ✅ سیستم خودکار اعداد را تبدیل کرد!');
  } catch (e) {
    print('   ❌ خطا: $e');
  }
}

/// مثال اعتبارسنجی شماره‌های مختلف
void validatePhoneNumbers() {
  print('\n🔍 اعتبارسنجی شماره‌های مختلف:');

  Map<String, bool> testCases = {
    '۰۹۱۳۲۳۲۳۱۲۳': true, // موبایل صحیح
    '۰۸۱۳۲۳۲۳۱۲۳': false, // تلفن ثابت
    '۰۹': false, // ناقص
    '۰۹۱۳۲۳۲۳۱۲۳۴': false, // طولانی
    '+989132323123': true, // با کد کشور
    '09132323123': true, // انگلیسی
  };

  testCases.forEach((phone, expected) {
    bool actual = PersianNumberUtils.isValidIranianMobile(phone);
    String status = actual == expected ? '✅' : '❌';
    print('   $phone -> $actual $status');
  });
}

/// مثال فرمت‌بندی شماره‌های مختلف
void formatPhoneExamples() {
  print('\n📋 فرمت‌بندی شماره‌های مختلف:');

  List<String> inputs = [
    '۰۹۱۳۲۳۲۳۱۲۳',
    '٠٩١٣٢٣٢٣١٢٣',
    '9132323123',
    '+989132323123',
    '0098 913 232 3123',
    '۰۹۱۳-۲۳۲-۳۱۲۳',
  ];

  for (String input in inputs) {
    String formatted = PersianNumberUtils.formatIranianMobile(input);
    print('   $input -> $formatted');
  }
}

/// مثال کار با کدهای تایید
void verificationCodeExamples() {
  print('\n🔐 مثال کدهای تایید:');

  List<String> codes = ['۱۲۳۴', '٥٦٧٨', 'کد: ۹۰۱۲', 'Your code is ۱۱۱۱'];

  for (String code in codes) {
    String clean = PersianNumberUtils.formatVerificationCode(code);
    print('   "$code" -> "$clean"');
  }
}

/// مثال تبدیل دوطرفه
void bidirectionalConversion() {
  print('\n🔄 تبدیل دوطرفه:');

  String original = '09132323123';
  String toPersian = PersianNumberUtils.convertToPersian(original);
  String backToEnglish = PersianNumberUtils.convertToEnglish(toPersian);

  print('   اصلی: $original');
  print('   به فارسی: $toPersian');
  print('   بازگشت: $backToEnglish');
  print('   مطابقت: ${original == backToEnglish ? "✅" : "❌"}');
}
