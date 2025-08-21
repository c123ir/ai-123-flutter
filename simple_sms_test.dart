// simple_sms_test.dart
// تست ساده بدون dependency های Flutter

import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  print('🧪 تست ساده سیستم SMS با اعتبارات جدید...');

  try {
    // اطلاعات اتصال
    const username = 'zsms8829';
    const password = 'ZRtn63e*)Od1';
    const from = '3000164545';
    const to = '09132323123';
    const domain = '0098';
    final text = 'تست SMS سرویس اصلی - ${DateTime.now()}';

    print('📱 ارسال پیامک به $to...');
    print('💬 متن: $text');

    // ساخت URL
    final encodedText = Uri.encodeComponent(text);
    final encodedPassword = Uri.encodeComponent(password);

    final url =
        'https://0098sms.com/sendsmslink.aspx'
        '?USERNAME=$username'
        '&PASSWORD=$encodedPassword'
        '&FROM=$from'
        '&TO=$to'
        '&TEXT=$encodedText'
        '&DOMAIN=$domain';

    print('🌐 URL: $url');

    // ارسال درخواست
    final response = await http.get(Uri.parse(url));

    print('📊 Status Code: ${response.statusCode}');
    print('📄 Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final responseBody = response.body.trim();
      final firstLine = responseBody.split('\n').first.trim();

      print('📋 اولین خط response: "$firstLine"');

      if (firstLine == '0') {
        print('✅ موفق: پیامک با موفقیت ارسال شد!');
        print('🎉 سیستم SMS کاملاً آماده است!');
      } else {
        print('❌ خطا: کد $firstLine');
        print(_getErrorMessage(firstLine));
      }
    } else {
      print('🚨 خطا در ارتباط با سرور: ${response.statusCode}');
    }
  } catch (e) {
    print('🚨 خطای غیرمنتظره: $e');
  }

  exit(0);
}

String _getErrorMessage(String code) {
  switch (code) {
    case '0':
      return 'موفق - پیامک ارسال شد';
    case '1':
      return 'خطا در نام کاربری یا رمز عبور';
    case '2':
      return 'اعتبار کافی نیست';
    case '3':
      return 'محدودیت روزانه';
    case '4':
      return 'محدودیت حجمی';
    case '5':
      return 'شماره فرستنده نامعتبر';
    case '6':
      return 'سیستم در حال بروزرسانی';
    case '7':
      return 'متن پیام نادرست';
    case '8':
      return 'شماره گیرنده نادرست';
    case '9':
      return 'پیام شامل کلمات فیلتر شده';
    case '10':
      return 'کاربر غیر فعال';
    default:
      return 'خطای نامشخص: $code';
  }
}
