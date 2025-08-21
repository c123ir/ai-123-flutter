// check_database.dart
// بررسی محتویات دیتابیس

import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

void main() async {
  print('🔍 بررسی محتویات دیتابیس...');

  try {
    // تنظیم sqflite برای دسکتاپ
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    // اتصال به دیتابیس
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'smart_assistant.db');

    final db = await openDatabase(path);

    print('✅ اتصال به دیتابیس برقرار شد');
    print('📍 مسیر دیتابیس: $path');

    // بررسی تنظیمات SMS
    print('\n📊 بررسی تنظیمات SMS:');
    final configs = await db.query('sms_configs');
    for (final config in configs) {
      print('   ${config['config_key']}: ${config['config_value']}');
    }

    // بررسی آخرین لاگ‌های SMS
    print('\n📜 آخرین 5 لاگ SMS:');
    final logs = await db.query('sms_logs', orderBy: 'id DESC', limit: 5);

    if (logs.isEmpty) {
      print('   هیچ لاگی یافت نشد');
    } else {
      for (final log in logs) {
        print('   ───────────────────────');
        print('   🆔 ID: ${log['id']}');
        print('   📱 شماره: ${log['recipient_phone']}');
        print('   📊 وضعیت: ${log['status']}');
        print('   🔢 کد پاسخ: ${log['response_code']}');
        print('   💬 پیام پاسخ: ${log['response_message']}');
        print('   🕐 زمان ارسال: ${log['sent_at']}');
        print('   🕐 زمان ایجاد: ${log['created_at']}');
      }
    }

    await db.close();
  } catch (e) {
    print('🚨 خطا: $e');
  }

  exit(0);
}
