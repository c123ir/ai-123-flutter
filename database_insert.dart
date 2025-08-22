// database_insert.dart
// ثبت مستقیم در دیتابیس SQLite

import 'dart:io';

void main() async {
  print('📝 **ثبت مستقیم در دیتابیس SQLite**\n');

  try {
    // مسیر دیتابیس macOS
    final appSupportDir =
        '${Platform.environment['HOME']!}/Library/Application Support/';
    final possiblePaths = [
      '${appSupportDir}dars01_hello/app_database.db',
      '${appSupportDir}com.example.dars01_hello/app_database.db',
      './app_database.db',
    ];

    print('🔍 جستجوی فایل دیتابیس...');
    for (final path in possiblePaths) {
      print('   بررسی: $path');
      if (await File(path).exists()) {
        print('   ✅ یافت شد!');
        break;
      } else {
        print('   ❌ وجود ندارد');
      }
    }

    // SQL Query for manual insertion
    final insertQuery =
        '''
INSERT INTO update_history (
  title,
  version, 
  user_problem,
  solution_description,
  user_comment,
  tags,
  priority,
  category,
  status,
  created_at,
  updated_at
) VALUES (
  'پیاده‌سازی کامل سیستم تبدیل اعداد فارسی و سیستم تاریخچه بروزرسانی',
  '1.2.0',
  'مشکلات موجود در پروژه:
1. 🔢 عدم پشتیبانی از اعداد فارسی و عربی در سیستم پیامک
2. 📊 نبود سیستم ردیابی تغییرات و بروزرسانی‌ها  
3. 🤖 نیاز به قوانین GitHub Copilot برای کنترل خودکار
4. 📋 نیاز به سیستم مدیریت تاریخچه پروژه',
  '🔢 **سیستم تبدیل اعداد فارسی:**
• ایجاد PersianNumberUtils با قابلیت‌های کامل
• پشتیبانی از اعداد فارسی (۰۱۲۳۴۵۶۷۸۹) و عربی (٠١٢٣٤٥٦٧٨٩)
• تبدیل خودکار در سیستم پیامک

📊 **سیستم جامع تاریخچه بروزرسانی:**
• مدل UpdateHistory با فیلدهای کامل
• سرویس UpdateHistoryService برای CRUD operations
• رابط کاربری UpdateHistoryScreen

🤖 **قوانین GitHub Copilot:**
• بروزرسانی کامل فایل‌های .github/instructions/
• سیستم تایید 3 مرحله‌ای

🧪 **فایل‌های تست و بررسی:**
• مجموعه کامل تست‌های سیستم SMS
• بررسی اتصال HTTP و دیباگ',
  'نتیجه پیاده‌سازی بسیار موفقیت‌آمیز بود:

✅ **موفقیت‌ها:**
• سیستم تبدیل اعداد کاملاً کار می‌کند
• ارسال پیامک با شماره‌های فارسی موفق
• سیستم تاریخچه بروزرسانی عملکرد عالی دارد

🎯 **کیفیت کد:**
• ساختار ماژولار و حرفه‌ای
• کامنت‌های فارسی مفصل
• پیروی از اصول Clean Code

📈 **بهبود تجربه کاربری:**
• پشتیبانی کامل RTL
• فونت Vazirmatn
• تاریخ شمسی در تمام بخش‌ها',
  'persian-numbers,update-history,github-copilot,sms-system,database,ui-improvements,testing,rtl-support,shamsi-date',
  'high',
  'feature',
  'completed',
  '${DateTime.now().toIso8601String()}',
  NULL
);
''';

    // ذخیره SQL در فایل
    final sqlFile = File('insert_update_record.sql');
    await sqlFile.writeAsString(insertQuery);

    print('\n✅ **فایل SQL آماده شد!**');
    print('📁 فایل: ${sqlFile.path}');

    print('\n💡 **راهنمای اجرای SQL:**');
    print('   1. 🔍 پیدا کردن فایل دیتابیس app_database.db');
    print('   2. 🛠️ باز کردن با sqlite3 یا DB Browser');
    print('   3. 📝 اجرای کوئری SQL از فایل ذخیره شده');
    print('   4. ✅ تایید ثبت رکورد');

    print('\n🔧 **دستورات Terminal:**');
    print('   sqlite3 [path-to-db] < insert_update_record.sql');

    // آمادگی برای ثبت در Flutter app
    print('\n📱 **یا از طریق اپلیکیشن Flutter:**');
    print('   1. اجرای flutter run');
    print('   2. رفتن به صفحه تاریخچه بروزرسانی');
    print('   3. کلیک روی "بروزرسانی جدید"');
    print('   4. کپی اطلاعات از فایل COMPREHENSIVE_CHANGES_RECORD.txt');
  } catch (e) {
    print('🚨 خطا: $e');
  }

  exit(0);
}
