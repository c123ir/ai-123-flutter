// test_persian_numbers.dart
// تست تابع تبدیل اعداد فارسی به انگلیسی

import 'lib/utils/persian_number_utils.dart';

void main() {
  print('=== تست تبدیل اعداد فارسی به انگلیسی ===');

  // تست شماره موبایل فارسی
  print('\n🔢 تست شماره موبایل:');
  String persianPhone = '۰۹۱۳۲۳۲۳۱۲۳';
  String englishPhone = PersianNumberUtils.formatIranianMobile(persianPhone);
  print('ورودی فارسی: $persianPhone');
  print('خروجی انگلیسی: $englishPhone');

  // تست شماره موبایل عربی
  print('\n🔢 تست شماره موبایل عربی:');
  String arabicPhone = '٠٩١٣٢٣٢٣١٢٣';
  String englishPhone2 = PersianNumberUtils.formatIranianMobile(arabicPhone);
  print('ورودی عربی: $arabicPhone');
  print('خروجی انگلیسی: $englishPhone2');

  // تست شماره با فاصله و خط تیره
  print('\n🔢 تست شماره با فرمت:');
  String formattedPhone = '۰۹۱۳-۲۳۲-۳۱۲۳';
  String cleanPhone = PersianNumberUtils.formatIranianMobile(formattedPhone);
  print('ورودی فرمت شده: $formattedPhone');
  print('خروجی تمیز: $cleanPhone');

  // تست کد ملی
  print('\n🆔 تست کد ملی:');
  String persianNationalCode = '۱۲۳۴۵۶۷۸۹۰';
  String englishNationalCode = PersianNumberUtils.formatNationalCode(
    persianNationalCode,
  );
  print('کد ملی فارسی: $persianNationalCode');
  print('کد ملی انگلیسی: $englishNationalCode');

  // تست کد تایید
  print('\n🔐 تست کد تایید:');
  String persianVerification = '۱۲۳۴';
  String englishVerification = PersianNumberUtils.formatVerificationCode(
    persianVerification,
  );
  print('کد تایید فارسی: $persianVerification');
  print('کد تایید انگلیسی: $englishVerification');

  // تست متن مخلوط
  print('\n📝 تست متن مخلوط:');
  String mixedText = 'کد ورود شما: ۱۲۳۴ و شماره موبایل: ۰۹۱۳۲۳۲۳۱۲۳';
  String convertedText = PersianNumberUtils.convertToEnglish(mixedText);
  print('متن اصلی: $mixedText');
  print('متن تبدیل شده: $convertedText');

  // تست بررسی صحت شماره موبایل
  print('\n✅ تست صحت شماره موبایل:');
  List<String> testPhones = [
    '۰۹۱۳۲۳۲۳۱۲۳',
    '۰۸۱۳۲۳۲۳۱۲۳',
    '۹۱۳۲۳۲۳۱۲۳',
    '09132323123',
    '+989132323123',
    '0098132323123',
  ];

  for (String phone in testPhones) {
    bool isValid = PersianNumberUtils.isValidIranianMobile(phone);
    String formatted = PersianNumberUtils.formatIranianMobile(phone);
    print('شماره: $phone -> فرمت: $formatted -> صحیح: ${isValid ? "✅" : "❌"}');
  }

  // تست تاریخ فارسی
  print('\n📅 تست تاریخ فارسی:');
  String persianDate = PersianNumberUtils.getCurrentPersianDate();
  print('تاریخ فعلی: $persianDate');

  print('\n🎉 تست‌ها به پایان رسید!');
}
