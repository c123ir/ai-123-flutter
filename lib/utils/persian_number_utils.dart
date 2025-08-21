// lib/utils/persian_number_utils.dart
// ابزارهای تبدیل اعداد فارسی و عربی به انگلیسی

class PersianNumberUtils {
  // نقشه تبدیل اعداد فارسی به انگلیسی
  static const Map<String, String> _persianToEnglish = {
    '۰': '0',
    '۱': '1',
    '۲': '2',
    '۳': '3',
    '۴': '4',
    '۵': '5',
    '۶': '6',
    '۷': '7',
    '۸': '8',
    '۹': '9',
  };

  // نقشه تبدیل اعداد عربی به انگلیسی
  static const Map<String, String> _arabicToEnglish = {
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
  };

  /// تبدیل اعداد فارسی و عربی به انگلیسی
  ///
  /// مثال:
  /// ```dart
  /// PersianNumberUtils.convertToEnglish('۰۹۱۳۲۳۲۳۱۲۳'); // '09132323123'
  /// PersianNumberUtils.convertToEnglish('٠٩١٣٢٣٢٣١٢٣'); // '09132323123'
  /// PersianNumberUtils.convertToEnglish('کد ورود: ۱۲۳۴'); // 'کد ورود: 1234'
  /// ```
  static String convertToEnglish(String input) {
    if (input.isEmpty) return input;

    String result = input;

    // تبدیل اعداد فارسی
    _persianToEnglish.forEach((persian, english) {
      result = result.replaceAll(persian, english);
    });

    // تبدیل اعداد عربی
    _arabicToEnglish.forEach((arabic, english) {
      result = result.replaceAll(arabic, english);
    });

    return result;
  }

  /// تبدیل اعداد انگلیسی به فارسی
  ///
  /// مثال:
  /// ```dart
  /// PersianNumberUtils.convertToPersian('09132323123'); // '۰۹۱۳۲۳۲۳۱۲۳'
  /// PersianNumberUtils.convertToPersian('کد ورود: 1234'); // 'کد ورود: ۱۲۳۴'
  /// ```
  static String convertToPersian(String input) {
    if (input.isEmpty) return input;

    String result = input;

    // تبدیل اعداد انگلیسی به فارسی
    _persianToEnglish.forEach((persian, english) {
      result = result.replaceAll(english, persian);
    });

    return result;
  }

  /// بررسی اینکه آیا رشته حاوی اعداد فارسی یا عربی است یا نه
  ///
  /// مثال:
  /// ```dart
  /// PersianNumberUtils.hasPersianOrArabicNumbers('۰۹۱۳'); // true
  /// PersianNumberUtils.hasPersianOrArabicNumbers('٠٩١٣'); // true
  /// PersianNumberUtils.hasPersianOrArabicNumbers('0913'); // false
  /// ```
  static bool hasPersianOrArabicNumbers(String input) {
    for (String persian in _persianToEnglish.keys) {
      if (input.contains(persian)) return true;
    }
    for (String arabic in _arabicToEnglish.keys) {
      if (input.contains(arabic)) return true;
    }
    return false;
  }

  /// استخراج فقط اعداد انگلیسی از رشته (حذف کاراکترهای غیرعددی)
  ///
  /// مثال:
  /// ```dart
  /// PersianNumberUtils.extractEnglishNumbers('شماره: ۰۹۱۳-۲۳۲-۳۱۲۳'); // '09132323123'
  /// PersianNumberUtils.extractEnglishNumbers('کد: ABC123XYZ'); // '123'
  /// ```
  static String extractEnglishNumbers(String input) {
    // ابتدا به انگلیسی تبدیل کن
    String converted = convertToEnglish(input);

    // فقط اعداد انگلیسی را نگه دار
    return converted.replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// فرمت کردن شماره موبایل ایرانی
  ///
  /// مثال:
  /// ```dart
  /// PersianNumberUtils.formatIranianMobile('۰۹۱۳۲۳۲۳۱۲۳'); // '09132323123'
  /// PersianNumberUtils.formatIranianMobile('9132323123'); // '09132323123'
  /// PersianNumberUtils.formatIranianMobile('+989132323123'); // '09132323123'
  /// ```
  static String formatIranianMobile(String input) {
    // تبدیل به انگلیسی و استخراج فقط اعداد
    String numbers = extractEnglishNumbers(input);

    // حذف کدهای کشور
    if (numbers.startsWith('98') && numbers.length == 12) {
      numbers = '0${numbers.substring(2)}';
    } else if (numbers.startsWith('0098') && numbers.length == 14) {
      numbers = '0${numbers.substring(4)}';
    } else if (!numbers.startsWith('0') && numbers.length == 10) {
      numbers = '0$numbers';
    }

    // بررسی فرمت صحیح شماره موبایل ایرانی
    if (numbers.length == 11 && numbers.startsWith('09')) {
      return numbers;
    }

    // اگر فرمت صحیح نبود، همان ورودی را برگردان
    return convertToEnglish(input);
  }

  /// بررسی صحت شماره موبایل ایرانی
  ///
  /// مثال:
  /// ```dart
  /// PersianNumberUtils.isValidIranianMobile('۰۹۱۳۲۳۲۳۱۲۳'); // true
  /// PersianNumberUtils.isValidIranianMobile('0813232312'); // false
  /// ```
  static bool isValidIranianMobile(String input) {
    String formatted = formatIranianMobile(input);

    // بررسی طول و شروع با 09
    if (formatted.length != 11 || !formatted.startsWith('09')) {
      return false;
    }

    // بررسی اینکه دومین رقم یکی از اپراتورهای معتبر باشد
    String secondDigit = formatted.substring(2, 3);
    List<String> validOperators = [
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
    ];

    return validOperators.contains(secondDigit);
  }

  /// تمیز کردن و فرمت کردن کد ملی
  ///
  /// مثال:
  /// ```dart
  /// PersianNumberUtils.formatNationalCode('۱۲۳۴۵۶۷۸۹۰'); // '1234567890'
  /// ```
  static String formatNationalCode(String input) {
    return extractEnglishNumbers(input);
  }

  /// تمیز کردن و فرمت کردن کد تایید
  ///
  /// مثال:
  /// ```dart
  /// PersianNumberUtils.formatVerificationCode('۱۲۳۴'); // '1234'
  /// ```
  static String formatVerificationCode(String input) {
    return extractEnglishNumbers(input);
  }

  /// دریافت تاریخ فعلی به صورت فارسی
  ///
  /// مثال:
  /// ```dart
  /// PersianNumberUtils.getCurrentPersianDate(); // '۱۴۰۴/۰۵/۳۰ ۱۰:۳۰'
  /// ```
  static String getCurrentPersianDate() {
    final now = DateTime.now();
    final year = convertToPersian(now.year.toString());
    final month = convertToPersian(now.month.toString().padLeft(2, '0'));
    final day = convertToPersian(now.day.toString().padLeft(2, '0'));
    final hour = convertToPersian(now.hour.toString().padLeft(2, '0'));
    final minute = convertToPersian(now.minute.toString().padLeft(2, '0'));

    return '$year/$month/$day $hour:$minute';
  }
}
