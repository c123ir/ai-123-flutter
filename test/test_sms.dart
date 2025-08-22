// test_sms.dart
// تست سریع سرویس SMS

import '../lib/services/sms_service.dart';

void main() async {
  print('🧪 شروع تست سرویس SMS...');

  final smsService = SmsService();

  try {
    // دریافت لیست سامانه‌های فعال
    print('📋 دریافت لیست سامانه‌های فعال...');
    final providers = await smsService.getActiveProviders();
    print('✅ تعداد سامانه‌های فعال: ${providers.length}');

    for (final provider in providers) {
      print('📡 سامانه: ${provider.name} (نوع: ${provider.providerType})');

      // دریافت تنظیمات سامانه
      final configs = await smsService.getProviderConfigs(provider.id!);
      print('⚙️ تنظیمات موجود: ${configs.keys.join(', ')}');

      // تست جزئیات سامانه
      final testResult = await smsService.testProviderDetailed(provider.id!);
      print('🔍 نتیجه تست: ${testResult['success'] ? '✅ موفق' : '❌ ناموفق'}');

      if (testResult['success'] != true) {
        print('🚨 خطا: ${testResult['error']}');
      }

      print('---');
    }
  } catch (e) {
    print('❌ خطا در تست: $e');
  }
}
