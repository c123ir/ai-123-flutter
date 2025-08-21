// full_service_test.dart
// تست کامل سرویس SMS مشابه UI

import 'dart:io';
import 'lib/services/sms_service.dart';
import 'lib/database/database_helper.dart';

void main() async {
  print('🧪 تست کامل سرویس SMS (مشابه UI)...');

  try {
    // مقداردهی سرویس
    final smsService = SmsService();
    final dbHelper = DatabaseHelper.instance;

    print('✅ سرویس آماده شد');

    // تست ارسال پیامک
    print('\n📱 ارسال پیامک تست...');
    final testMessage = 'تست کامل سرویس - ${DateTime.now()}';

    final result = await smsService.sendSms(
      phone: '09132323123',
      message: testMessage,
    );

    print('\n📊 نتیجه ارسال:');
    print('   🆔 ID: ${result.id}');
    print('   📱 شماره: ${result.recipientPhone}');
    print('   💬 متن: ${result.messageText}');
    print('   📊 وضعیت: ${result.status}');
    print('   📊 وضعیت فارسی: ${result.statusPersian}');
    print('   🔢 کد پاسخ: ${result.responseCode}');
    print('   💬 پیام پاسخ: ${result.responseMessage}');
    print('   🕐 زمان ارسال: ${result.sentAt}');
    print('   🕐 زمان ایجاد: ${result.createdAt}');

    // بررسی وضعیت‌ها
    print('\n🔍 بررسی وضعیت‌ها:');
    print('   ⏳ isPending: ${result.isPending}');
    print('   ✅ isSent: ${result.isSent}');
    print('   📧 isDelivered: ${result.isDelivered}');
    print('   ❌ isFailed: ${result.isFailed}');

    // خواندن مستقیم از دیتابیس
    print('\n📚 بررسی مستقیم در دیتابیس:');
    final db = await dbHelper.database;
    final logs = await db.query('sms_logs', orderBy: 'id DESC', limit: 1);

    if (logs.isNotEmpty) {
      final dbLog = logs.first;
      print('   🆔 DB ID: ${dbLog['id']}');
      print('   📊 DB Status: ${dbLog['status']}');
      print('   🔢 DB Response Code: ${dbLog['response_code']}');
      print('   💬 DB Response Message: ${dbLog['response_message']}');
      print('   🕐 DB Sent At: ${dbLog['sent_at']}');
    }

    // تست تاریخچه
    print('\n📜 تست تاریخچه:');
    final history = await smsService.getSmsHistory(limit: 5);
    print('   📊 تعداد آخرین لاگ‌ها: ${history.length}');

    if (history.isNotEmpty) {
      print('   🔍 آخرین لاگ:');
      final lastLog = history.first;
      print('      📊 وضعیت: ${lastLog.status} (${lastLog.statusPersian})');
      print('      🔢 کد: ${lastLog.responseCode}');
      print('      💬 پیام: ${lastLog.responseMessage}');
      print('      ❌ شکست خورده؟ ${lastLog.isFailed}');
      print('      ✅ ارسال شده؟ ${lastLog.isSent}');
    }
  } catch (e) {
    print('🚨 خطا: $e');
  }

  exit(0);
}
