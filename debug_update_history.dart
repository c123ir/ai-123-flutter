// debug_update_history.dart
// خطایابی کامل سیستم تاریخچه بروزرسانی

import 'lib/services/update_history_service.dart';
import 'lib/services/json_update_history_service.dart';

Future<void> main() async {
  print('🔍 شروع خطایابی سیستم تاریخچه بروزرسانی...');
  print('');

  // 1. بررسی سرویس JSON
  print('📊 تست سرویس JSON:');
  final jsonService = JsonUpdateHistoryService();
  try {
    final jsonUpdates = await jsonService.getAllUpdatesFromJson();
    print('✅ سرویس JSON: ${jsonUpdates.length} رکورد');
    for (var update in jsonUpdates) {
      print('   - ${update.title}');
      print('     دسته: ${update.category}, اولویت: ${update.priority}');
      print('     تاریخ: ${update.shamsiDate} ${update.shamsiTime}');
    }
  } catch (e) {
    print('❌ خطا در سرویس JSON: $e');
  }

  print('');

  // 2. بررسی سرویس دیتابیس
  print('🗄️ تست سرویس دیتابیس:');
  final dbService = UpdateHistoryService();
  try {
    final dbUpdates = await dbService.getAllUpdates();
    print('✅ سرویس DB: ${dbUpdates.length} رکورد');
    for (var update in dbUpdates) {
      print('   - ${update.title}');
      print('     دسته: ${update.category}, اولویت: ${update.priority}');
      print('     تاریخ: ${update.shamsiDate} ${update.shamsiTime}');
    }
  } catch (e) {
    print('❌ خطا در سرویس DB: $e');
  }

  print('');

  // 3. تست ترکیب داده‌ها (مثل آنچه در UI انجام می‌شود)
  print('🔄 تست ترکیب داده‌ها:');
  try {
    final jsonUpdates = await jsonService.getAllUpdatesFromJson();
    final dbUpdates = await dbService.getAllUpdates();

    final allUpdates = [...jsonUpdates];

    // افزودن رکوردهای دیتابیس که در JSON نیستند
    for (final dbUpdate in dbUpdates) {
      final exists = jsonUpdates.any(
        (jsonUpdate) =>
            jsonUpdate.title == dbUpdate.title &&
            jsonUpdate.createdAt.day == dbUpdate.createdAt.day,
      );
      if (!exists) {
        allUpdates.add(dbUpdate);
      }
    }

    // مرتب‌سازی بر اساس تاریخ
    allUpdates.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    print('✅ مجموع نهایی: ${allUpdates.length} رکورد');
    print('📋 فهرست کامل:');
    for (int i = 0; i < allUpdates.length; i++) {
      print('   ${i + 1}. ${allUpdates[i].title}');
      print(
        '      تاریخ: ${allUpdates[i].shamsiDate} ${allUpdates[i].shamsiTime}',
      );
      print(
        '      منبع: ${jsonUpdates.contains(allUpdates[i]) ? 'JSON' : 'Database'}',
      );
      print('');
    }
  } catch (e) {
    print('❌ خطا در ترکیب داده‌ها: $e');
  }

  print('🎯 خطایابی تکمیل شد!');
}
