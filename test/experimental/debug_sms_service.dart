// debug_sms_service.dart
// تست دقیق سرویس SMS برای تشخیص مشکل

import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  print('🔍 تست دقیق سرویس SMS برای تشخیص مشکل...');

  try {
    // تست مشابه سرویس اصلی
    final result = await _send0098Sms(
      '09132323123',
      'تست دیباگ سرویس - ${DateTime.now()}',
    );

    print('📊 نتیجه کامل:');
    print('   🔢 کد: ${result['code']}');
    print('   💬 پیام: ${result['message']}');
    print('   📚 Reference: ${result['reference']}');

    // تست منطق تصمیم‌گیری
    final responseCode = result['code'] ?? '';
    final status = responseCode == '0' ? 'sent' : 'failed';

    print('\n🎯 منطق تصمیم‌گیری:');
    print('   📋 responseCode: "$responseCode"');
    print('   ✅ responseCode == "0": ${responseCode == '0'}');
    print('   📊 status: $status');

    if (status == 'sent') {
      print('\n🎉 بر اساس منطق سرویس: ارسال موفق!');
    } else {
      print('\n❌ بر اساس منطق سرویس: ارسال ناموفق!');
      print('   🔍 دلیل: ${result['message']}');
    }
  } catch (e) {
    print('🚨 خطا: $e');
  }

  exit(0);
}

Future<Map<String, String>> _send0098Sms(String phone, String message) async {
  // تنظیمات ثابت (مشابه دیتابیس)
  const username = 'zsms8829';
  const password = 'ZRtn63e*)Od1';
  const from = '3000164545';
  const domain = '0098';
  const apiUrl = 'https://0098sms.com/sendsmslink.aspx';

  final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');

  print('📡 ارسال با تنظیمات:');
  print('   👤 Username: $username');
  print('   🔐 Password: $password');
  print('   📞 From: $from');
  print('   📱 To: $cleanPhone');
  print('   🌐 Domain: $domain');
  print('   💬 Message: $message');

  http.Response response;

  try {
    // ارسال با روش GET (مطابق مستندات جدید)
    final url = Uri.parse(apiUrl).replace(
      queryParameters: {
        'USERNAME': username,
        'PASSWORD': password,
        'FROM': from,
        'TO': cleanPhone,
        'TEXT': message,
        'DOMAIN': domain,
      },
    );

    print('\n🌐 URL نهایی: $url');

    response = await http.get(url);

    print('\n📊 پاسخ سرور:');
    print('   🔢 Status Code: ${response.statusCode}');
    print('   📄 Body کامل:\n${response.body}');

    if (response.statusCode == 200) {
      final responseBody = response.body.trim();

      // استخراج اولین خط response (کد واقعی)
      final firstLine = responseBody.split('\n').first.trim();

      print('\n🔍 تحلیل پاسخ:');
      print('   📋 اولین خط: "$firstLine"');
      print('   📏 طول اولین خط: ${firstLine.length}');
      print('   🔤 کاراکترهای اولین خط: ${firstLine.codeUnits}');

      // تحلیل پاسخ سامانه ۰۰۹۸ (کد موفقیت = 0)
      if (firstLine == '0') {
        return {
          'code': '0',
          'message': 'عملیات با موفقیت به پایان رسید',
          'reference': '',
        };
      } else {
        return {'code': firstLine, 'message': _get0098ErrorMessage(firstLine)};
      }
    } else {
      throw Exception('خطا در ارتباط با سرور: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('خطا در ارسال پیامک: $e');
  }
}

String _get0098ErrorMessage(String responseCode) {
  final errorMap = {
    '0': 'عملیات با موفقیت به پایان رسید',
    '1': 'شماره گیرنده اشتباه است',
    '2': 'گیرنده تعریف نشده است',
    '3': 'فرستنده تعریف نشده است',
    '4': 'متن تنظیم نشده است',
    '5': 'نام کاربری تنظیم نشده است',
    '6': 'کلمه عبور تنظیم نشده است',
    '7': 'نام دامین تنظیم نشده است',
    '8': 'مجوز شما باطل شده است',
    '9': 'اعتبار پیامک شما کافی نیست',
    '10': 'برای این شماره لینک تعریف نشده است',
    '11': 'عدم مجوز برای اتصال لینک',
    '12': 'نام کاربری و کلمه ی عبور اشتباه است',
    '13': 'کاراکتر غیرمجاز در متن وجود دارد',
    '14': 'سقف ارسال روزانه پر شده است',
    '16': 'عدم مجوز شماره برای ارسال از لینک',
    '17': 'خطا در شماره پنل. لطفا با پشیانی تماس بگیرید',
    '18': 'اتمام تاریخ اعتبار شماره پنل. برای استفاده تمدید شود',
    '19': 'تنظیمات کد opt انجام نشده است',
    '20': 'فرمت کد opt صحیح نیست',
    '21': 'تنظیمات کد opt توسط ادمین تایید نشده است',
    '22': 'اطلاعات مالک شماره ثبت و تایید نشده است',
    '23': 'هنوز اجازه ارسال به این شماره پنل داده نشده است',
    '24': 'ارسال از IP غیرمجاز انجام شده است',
  };

  return errorMap[responseCode] ?? 'خطای نامشخص: $responseCode';
}
