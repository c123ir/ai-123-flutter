// simple_debug.dart
// تست ساده خطایابی سیستم تاریخچه بدون imports پیچیده

import 'dart:io';
import 'dart:convert';

void main() async {
  print('🔍 شروع خطایابی ساده سیستم تاریخچه...');

  // بررسی وجود فایل JSON
  final jsonPath = 'assets/data/update_history.json';
  final jsonFile = File(jsonPath);

  print('📁 بررسی فایل JSON: $jsonPath');

  if (await jsonFile.exists()) {
    print('✅ فایل JSON موجود است');

    try {
      final content = await jsonFile.readAsString();
      print('📊 محتوای فایل:');
      print(content);

      // تجزیه JSON
      final jsonData = json.decode(content);
      print('✅ JSON معتبر است');
      print('🔢 تعداد رکوردها: ${jsonData['updates']?.length ?? 0}');

      if (jsonData['updates'] != null && jsonData['updates'].isNotEmpty) {
        print('📋 اولین رکورد:');
        print(jsonData['updates'][0]);
      }
    } catch (e) {
      print('❌ خطا در خواندن JSON: $e');
    }
  } else {
    print('❌ فایل JSON موجود نیست');
  }

  print('✅ خطایابی کامل شد');
}
