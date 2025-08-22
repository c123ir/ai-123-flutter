// direct_database_insert.dart
// ثبت مستقیم رکورد در دیتابیس بدون Flutter

import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

Future<void> main() async {
  print('🤖 شروع ثبت مستقیم در دیتابیس...');

  try {
    // راه‌اندازی sqflite برای desktop
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    // مسیر دیتابیس
    final dbPath = join(Directory.current.path, 'app_database.db');
    print('📁 مسیر دیتابیس: $dbPath');

    // اتصال به دیتابیس
    final db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        // ایجاد جدول در صورت عدم وجود
        await db.execute('''
          CREATE TABLE update_history(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            version TEXT NOT NULL,
            shamsiDate TEXT NOT NULL,
            shamsiTime TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            userProblem TEXT NOT NULL,
            solutionDescription TEXT NOT NULL,
            userComment TEXT,
            tags TEXT,
            priority TEXT DEFAULT 'medium',
            category TEXT DEFAULT 'feature',
            status TEXT DEFAULT 'completed'
          )
        ''');
        print('✅ جدول update_history ایجاد شد');
      },
    );

    // آماده‌سازی داده‌ها
    final now = DateTime.now();
    final shamsiDate = '۱۴۰۴/۰۵/۳۱';
    final shamsiTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final recordData = {
      'title': 'بروزرسانی دستورالعمل‌های GitHub Copilot برای سیستم تاریخچه',
      'version': '1.2.0',
      'shamsiDate': shamsiDate,
      'shamsiTime': shamsiTime,
      'createdAt': now.toIso8601String(),
      'userProblem':
          'GitHub Copilot نیاز به دستورالعمل جامع و دقیق برای ثبت خودکار تاریخچه بروزرسانی‌ها داشت',
      'solutionDescription':
          '''بروزرسانی کامل فایل .github/instructions/update_history_automation.instructions.md شامل:

✨ ویژگی‌های کلیدی:
• مأموریت واضح برای GitHub Copilot
• مدل داده‌ای کامل UpdateHistory 
• ۴ قانون اجباری: تایید کاربر، زمان‌بندی، دسته‌بندی، اولویت‌بندی
• گردش کار ۴ مرحله‌ای: تشخیص → جمع‌آوری → تایید → ثبت
• الگوهای استاندارد برای Feature، Bug Fix، UI Update
• سناریوهای خاص و راه‌حل‌ها
• هشدارها و بهترین شیوه‌ها
• نمونه کد عملی قابل استفاده
• بخش گزارش‌گیری و پیگیری کیفیت

🎯 نتیجه: GitHub Copilot حالا قوانین جامع و دقیقی برای ثبت تاریخچه دارد.''',
      'userComment':
          'دستورالعمل‌های جدید باعث بهبود کیفیت ثبت تاریخچه و مستندسازی بهتر تغییرات می‌شود',
      'tags':
          'github-copilot,documentation,automation,instructions,update-history,guidelines',
      'priority': 'medium',
      'category': 'documentation',
      'status': 'completed',
    };

    // ثبت رکورد
    print('📝 درحال ثبت رکورد...');
    final recordId = await db.insert('update_history', recordData);

    print('✅ رکورد با موفقیت در دیتابیس ثبت شد!');
    print('🆔 شناسه رکورد: $recordId');
    print('📋 عنوان: ${recordData['title']}');
    print('🗂️ دسته‌بندی: ${recordData['category']}');
    print('⭐ اولویت: ${recordData['priority']}');
    print('📅 تاریخ: $shamsiDate - $shamsiTime');

    // بررسی تعداد کل رکوردها
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM update_history'),
    );
    print('📊 تعداد کل رکوردهای تاریخچه: $count');

    // نمایش آخرین رکورد
    final latestRecords = await db.query(
      'update_history',
      orderBy: 'id DESC',
      limit: 1,
    );

    if (latestRecords.isNotEmpty) {
      final latest = latestRecords.first;
      print('📄 آخرین رکورد:');
      print('   • عنوان: ${latest['title']}');
      print('   • تاریخ: ${latest['shamsiDate']} ${latest['shamsiTime']}');
      print('   • دسته‌بندی: ${latest['category']}');
    }

    await db.close();
    print('');
    print('🎉 عملیات ثبت رکورد تاریخچه با موفقیت تکمیل شد!');
  } catch (e) {
    print('❌ خطا در ثبت رکورد: $e');
  }
}
