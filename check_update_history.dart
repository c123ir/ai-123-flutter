// check_update_history.dart
// بررسی وضعیت سیستم تاریخچه بروزرسانی

import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

void main() async {
  print('🔍 بررسی سیستم تاریخچه بروزرسانی...\n');

  try {
    // تنظیم sqflite برای دسکتاپ
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    // اتصال به دیتابیس
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'smart_assistant.db');

    final db = await openDatabase(path);

    print('✅ اتصال به دیتابیس برقرار شد');
    print('📍 مسیر دیتابیس: $path\n');

    // بررسی وجود جدول update_history
    final tables = await db.query(
      'sqlite_master',
      where: 'type = ? AND name = ?',
      whereArgs: ['table', 'update_history'],
    );

    if (tables.isEmpty) {
      print('❌ جدول update_history وجود ندارد!');
      print('💡 باید migration را اجرا کنید تا جدول ایجاد شود\n');
    } else {
      print('✅ جدول update_history موجود است\n');

      // بررسی ساختار جدول
      final columns = await db.rawQuery('PRAGMA table_info(update_history)');
      print('📊 ساختار جدول update_history:');
      for (final column in columns) {
        print('   - ${column['name']}: ${column['type']}');
      }
      print('');

      // بررسی تعداد رکوردها
      final countResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM update_history',
      );
      final totalCount = countResult.first['count'] as int;
      print('📈 تعداد کل رکوردها: $totalCount\n');

      if (totalCount > 0) {
        // نمایش آخرین 5 بروزرسانی
        print('📜 آخرین 5 بروزرسانی:');
        print('─' * 80);

        final latestUpdates = await db.query(
          'update_history',
          orderBy: 'created_at DESC',
          limit: 5,
        );

        for (int i = 0; i < latestUpdates.length; i++) {
          final update = latestUpdates[i];
          print('${i + 1}. 📝 ${update['title']}');
          print('   🏷️ نسخه: ${update['version']}');
          print('   📁 دسته‌بندی: ${update['category']}');
          print('   ⭐ اولویت: ${update['priority']}');
          print('   🕐 تاریخ: ${update['created_at']}');
          print('   📝 توضیح: ${update['solution_description']}');

          if (update['tags'] != null) {
            print('   🏷️ برچسب‌ها: ${update['tags']}');
          }

          print('');
        }

        // آمارهای کلی
        print('📊 آمار دسته‌بندی‌ها:');
        final categoryStats = await db.rawQuery('''
          SELECT category, COUNT(*) as count 
          FROM update_history 
          GROUP BY category 
          ORDER BY count DESC
        ''');

        for (final stat in categoryStats) {
          print('   📁 ${stat['category']}: ${stat['count']} مورد');
        }
        print('');

        // آمار اولویت‌ها
        print('📊 آمار اولویت‌ها:');
        final priorityStats = await db.rawQuery('''
          SELECT priority, COUNT(*) as count 
          FROM update_history 
          GROUP BY priority 
          ORDER BY 
            CASE priority 
              WHEN 'high' THEN 1 
              WHEN 'medium' THEN 2 
              WHEN 'low' THEN 3 
            END
        ''');

        for (final stat in priorityStats) {
          final emoji = stat['priority'] == 'high'
              ? '🔴'
              : stat['priority'] == 'medium'
              ? '🟡'
              : '🟢';
          print('   $emoji ${stat['priority']}: ${stat['count']} مورد');
        }
        print('');

        // بررسی تغییرات اخیر (آخرین 24 ساعت)
        final recentChanges = await db.rawQuery('''
          SELECT COUNT(*) as count 
          FROM update_history 
          WHERE datetime(created_at) > datetime('now', '-1 day')
        ''');

        final recentCount = recentChanges.first['count'] as int;
        print('📅 تغییرات آخرین 24 ساعت: $recentCount مورد');

        if (recentCount > 0) {
          final recentList = await db.query(
            'update_history',
            where: "datetime(created_at) > datetime('now', '-1 day')",
            orderBy: 'created_at DESC',
          );

          print('🕐 آخرین تغییرات:');
          for (final recent in recentList) {
            print('   • ${recent['title']} (${recent['created_at']})');
          }
        }
      } else {
        print('ℹ️ هیچ رکوردی در تاریخچه بروزرسانی وجود ندارد');
        print('💡 احتمالاً هنوز هیچ بروزرسانی‌ای ثبت نشده است');
      }
    }

    await db.close();
  } catch (e) {
    print('🚨 خطا در بررسی: $e');
  }

  exit(0);
}
