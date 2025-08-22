// quick_update_register.dart
// ثبت سریع رکورد بروزرسانی

import 'lib/services/json_update_history_service.dart';

void main() async {
  final service = JsonUpdateHistoryService();

  print('🔄 در حال ثبت رکورد بروزرسانی...');

  try {
    final updateData = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'title': 'تست و اعتبارسنجی سیستم تاریخچه بروزرسانی',
      'userProblem':
          'نیاز به تست عملکرد صحیح سیستم تاریخچه و اطمینان از کارکرد فرم جدید',
      'solutionDescription':
          'تست کامل سیستم ثبت رکورد، نمایش در اپلیکیشن و عملکرد فرم پیشرفته انجام شد',
      'category': 'Performance',
      'priority': 'Medium',
      'status': 'completed',
      'version': '1.2.2',
      'tags': 'Test, Validation, System-Check, Performance',
      'userComment': 'تست موفقیت‌آمیز سیستم تاریخچه و تأیید عملکرد صحیح',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };

    final success = await service.addUpdate(updateData);

    if (success) {
      print('✅ رکورد بروزرسانی با موفقیت ثبت شد!');
      print('📋 عنوان: تست و اعتبارسنجی سیستم تاریخچه بروزرسانی');
      print('🎯 دسته‌بندی: Performance');
      print('⚡ اولویت: Medium');
      print('📅 تاریخ: ${DateTime.now().toString().substring(0, 19)}');
      print('🔖 نسخه: 1.2.2');
    } else {
      print('❌ خطا در ثبت رکورد');
    }
  } catch (e) {
    print('❌ خطا: $e');
  }
}
