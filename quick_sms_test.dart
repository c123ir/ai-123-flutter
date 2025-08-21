// quick_sms_test.dart
// تست سریع ارسال پیامک آزمایشی

import 'package:http/http.dart' as http;

void main() async {
  print('🧪 تست مستقیم ارسال پیامک...');

  // اطلاعات API
  final username = 'zsms8829';
  final password = 'ZRtn63e*)Od1';
  final from = '3000164545';
  final to = '09132323123';
  final text = 'تست ارسال پیامک - ${DateTime.now()}';
  final domain = '0098';

  // URL با پارامترهای جدید
  final apiUrl = 'https://0098sms.com/sendsmslink.aspx';

  try {
    // روش 1: GET Request
    print('📡 تست با روش GET...');
    final getUrl = Uri.parse(apiUrl).replace(
      queryParameters: {
        'USERNAME': username,
        'PASSWORD': password,
        'FROM': from,
        'TO': to,
        'TEXT': text,
        'DOMAIN': domain,
      },
    );

    print('🌐 URL: $getUrl');

    final getResponse = await http.get(getUrl);
    print('📊 Status Code: ${getResponse.statusCode}');
    print('📄 Response Body: ${getResponse.body}');

    if (getResponse.statusCode == 200) {
      final responseBody = getResponse.body.trim();
      final firstLine = responseBody.split('\n').first.trim();

      print('📋 اولین خط response: "$firstLine"');

      if (firstLine == '0') {
        print('✅ موفق: عملیات با موفقیت انجام شد');
        print('🎉 پیامک به شماره $to ارسال شد!');
      } else {
        print('❌ خطا: کد $firstLine - ${_getErrorMessage(firstLine)}');
      }
    } else {
      print('🚨 خطا در ارتباط با سرور: ${getResponse.statusCode}');
    }

    print('\n---\n');

    // روش 2: POST Request
    print('📡 تست با روش POST...');
    final postResponse = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'USERNAME': username,
        'PASSWORD': password,
        'FROM': from,
        'TO': to,
        'TEXT': text,
        'DOMAIN': domain,
      },
    );

    print('📊 Status Code: ${postResponse.statusCode}');
    print('📄 Response Body: ${postResponse.body}');

    if (postResponse.statusCode == 200) {
      final responseBody = postResponse.body.trim();
      final firstLine = responseBody.split('\n').first.trim();

      print('📋 اولین خط response: "$firstLine"');

      if (firstLine == '0') {
        print('✅ موفق: عملیات با موفقیت انجام شد');
        print('🎉 پیامک به شماره $to ارسال شد!');
      } else {
        print('❌ خطا: کد $firstLine - ${_getErrorMessage(firstLine)}');
      }
    } else {
      print('🚨 خطا در ارتباط با سرور: ${postResponse.statusCode}');
    }
  } catch (e) {
    print('💥 خطای غیرمنتظره: $e');
  }
}

String _getErrorMessage(String responseCode) {
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
