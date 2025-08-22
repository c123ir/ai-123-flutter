// check_update_history_simple.dart
// بررسی ساده سیستم تاریخچه بروزرسانی با سرویس موجود

import 'dart:io';
import 'lib/services/update_history_service.dart';

void main() async {
  print('🔍 بررسی سیستم تاریخچه بروزرسانی...\n');

  try {
    final service = UpdateHistoryService();

    // بررسی تعداد کل رکوردها
    print('📊 دریافت آمار کلی...');
    final allUpdates = await service.getAllUpdates();
    final totalCount = allUpdates.length;

    print('📈 تعداد کل بروزرسانی‌ها: $totalCount\n');

    if (totalCount > 0) {
      print('📜 آخرین 5 بروزرسانی:');
      print('─' * 80);

      // نمایش آخرین 5 بروزرسانی
      final latestUpdates = allUpdates.take(5).toList();

      for (int i = 0; i < latestUpdates.length; i++) {
        final update = latestUpdates[i];
        print('${i + 1}. 📝 ${update.title}');
        print('   🏷️ نسخه: ${update.version}');
        print('   📁 دسته‌بندی: ${update.category}');
        print('   ⭐ اولویت: ${update.priority}');
        print('   🕐 تاریخ: ${update.createdAt}');

        if (update.solutionDescription.isNotEmpty) {
          print('   📝 توضیح: ${update.solutionDescription}');
        }

        if (update.tags?.isNotEmpty == true) {
          print('   🏷️ برچسب‌ها: ${update.tags}');
        }

        print('');
      }

      // آمارهای کلی
      print('📊 آمار دسته‌بندی‌ها:');
      final categoryMap = <String, int>{};
      for (final update in allUpdates) {
        categoryMap[update.category] = (categoryMap[update.category] ?? 0) + 1;
      }

      for (var entry in categoryMap.entries) {
        print('   📁 ${entry.key}: ${entry.value} مورد');
      }
      print('');

      // آمار اولویت‌ها
      print('📊 آمار اولویت‌ها:');
      final priorityMap = <String, int>{};
      for (final update in allUpdates) {
        priorityMap[update.priority] = (priorityMap[update.priority] ?? 0) + 1;
      }

      for (var entry in priorityMap.entries) {
        final emoji = entry.key == 'high'
            ? '🔴'
            : entry.key == 'medium'
            ? '🟡'
            : '🟢';
        print('   $emoji ${entry.key}: ${entry.value} مورد');
      }
      print('');

      // بررسی آخرین بروزرسانی
      if (allUpdates.isNotEmpty) {
        final latest = allUpdates.first;
        print('🕐 آخرین بروزرسانی: ${latest.title}');
        print('📅 تاریخ آخرین بروزرسانی: ${latest.createdAt}');

        // بررسی اینکه آیا امروز بروزرسانی‌ای انجام شده یا نه
        final today = DateTime.now();
        final latestDate = latest.createdAt;
        final isToday =
            latestDate.year == today.year &&
            latestDate.month == today.month &&
            latestDate.day == today.day;

        if (isToday) {
          print('✅ امروز بروزرسانی انجام شده است');
        } else {
          final daysPassed = today.difference(latestDate).inDays;
          print('⏰ آخرین بروزرسانی $daysPassed روز پیش بوده');
        }
      }
    } else {
      print('ℹ️ هیچ رکوردی در تاریخچه بروزرسانی وجود ندارد');
      print('💡 احتمالاً هنوز هیچ بروزرسانی‌ای ثبت نشده است');
      print('\n🔧 برای تست سیستم، یک بروزرسانی نمونه اضافه می‌کنم...');

      // اضافه کردن یک بروزرسانی نمونه
      await service.addUpdate(
        title: 'بررسی سیستم تاریخچه بروزرسانی',
        version: '1.0.0',
        userProblem: 'بررسی اینکه سیستم تاریخچه بروزرسانی کار می‌کند یا نه',
        solutionDescription: 'اجرای اسکریپت بررسی و اضافه کردن رکورد تست',
        userComment: 'سیستم با موفقیت کار می‌کند',
        priority: 'medium',
        category: 'test',
        tags: 'test,system-check',
      );

      print('✅ رکورد نمونه اضافه شد! دوباره بررسی کنید.');
    }
  } catch (e) {
    print('🚨 خطا در بررسی: $e');
    print('💡 احتمالاً جدول update_history هنوز ایجاد نشده است');
    print('🔧 برای حل مشکل، migration دیتابیس را اجرا کنید');
  }

  exit(0);
}
