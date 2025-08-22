// test_sms_service.dart
// تست سرویس SMS اصلی پروژه

import 'dart:io';
import 'lib/services/sms_service.dart';
import 'lib/database/database_helper.dart';

void main() async {
  print('🧪 تست سرویس SMS اصلی...');

  try {
    // مقداردهی دیتابیس
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.database;
    print('✅ دیتابیس آماده شد');

    // مقداردهی سرویس SMS
    final smsService = SmsService();
    print('✅ سرویس SMS آماده شد');

    print('📱 در حال ارسال پیامک به 09132323123...');
    final testMessage = 'تست سرویس SMS اصلی - ${DateTime.now()}';
    print(' متن پیامک: $testMessage');

    // ارسال پیامک
    final result = await smsService.sendSms(
      phone: '09132323123',
      message: testMessage,
      specificProviderId: 1, // استفاده از سامانه 0098sms
    );

    print('🎉 پیامک ارسال شد!');
    print('📊 شناسه لاگ: ${result.id}');
    print('📱 شماره: ${result.recipientPhone}');
    print('� متن: ${result.messageText}');
    print('📡 سامانه: ${result.providerId}');
    print('📊 وضعیت: ${result.status}');
    print('🕐 زمان: ${result.sentAt}');

    if (result.responseCode != null) {
      print('� کد پاسخ: ${result.responseCode}');
    }
    if (result.responseMessage != null) {
      print('� پیام پاسخ: ${result.responseMessage}');
    }
  } catch (e) {
    print('🚨 خطای غیرمنتظره: $e');
  }

  // خروج از برنامه
  exit(0);
}
