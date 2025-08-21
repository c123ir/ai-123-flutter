// test_http_connection.dart
// تست اتصال HTTP برای تشخیص مشکل

import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  print('🧪 تست اتصال HTTP...');

  // تست‌های مختلف برای تشخیص مشکل
  await testConnection('https://www.google.com', 'Google HTTPS');
  await testConnection('http://www.google.com', 'Google HTTP');
  await testConnection('https://0098sms.com', '0098SMS HTTPS');
  await testConnection('http://0098sms.com', '0098SMS HTTP');
  await testConnection(
    'http://0098sms.com/sendsmslink.aspx',
    '0098SMS API HTTP',
  );

  exit(0);
}

Future<void> testConnection(String url, String name) async {
  print('\n🔗 تست $name...');
  print('   URL: $url');

  try {
    final client = http.Client();
    final response = await client
        .get(Uri.parse(url), headers: {'User-Agent': 'SmartAssistant/1.0'})
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception('Timeout');
          },
        );

    print('   ✅ موفق - Status: ${response.statusCode}');
    print('   📊 Content Length: ${response.body.length}');

    client.close();
  } catch (e) {
    print('   ❌ خطا: $e');

    // تحلیل نوع خطا
    final errorStr = e.toString();
    if (errorStr.contains('SocketException')) {
      print('   🔍 نوع خطا: مشکل اتصال شبکه');
      if (errorStr.contains('Operation not permitted')) {
        print('   💡 راه‌حل: بررسی فایروال یا VPN');
      }
    } else if (errorStr.contains('Timeout')) {
      print('   🔍 نوع خطا: زمان اتصال تمام شد');
    } else if (errorStr.contains('Certificate')) {
      print('   🔍 نوع خطا: مشکل گواهی SSL');
    }
  }
}
