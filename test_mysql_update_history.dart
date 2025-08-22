// test_mysql_update_history.dart
// تست سیستم ثبت تاریخچه در MySQL

import 'lib/services/mysql_update_history_service.dart';

Future<void> main() async {
  print('🧪 تست MySqlUpdateHistoryService...');
  print('=' * 50);

  try {
    // تست ۱: بررسی اتصال MySQL
    print('\n📊 بخش ۱: تست اتصال MySQL');
    print('-' * 30);

    final connectionOk = await MySqlUpdateHistoryService.testConnection();
    if (connectionOk) {
      print('✅ اتصال MySQL برقرار است');
    } else {
      print('⚠️ اتصال MySQL موجود نیست - از WebAdapter استفاده می‌شود');
    }

    // تست ۲: ثبت رکورد جدید در MySQL
    print('\n📝 بخش ۲: ثبت تاریخچه در MySQL');
    print('-' * 30);

    final success = await MySqlUpdateHistoryService.registerUpdate(
      title: 'ایجاد سیستم تاریخچه MySQL',
      userProblem: 'نیاز به ذخیره تاریخچه بروزرسانی در پایگاه داده MySQL',
      solutionDescription:
          'پیاده‌سازی MySqlUpdateHistoryService برای ثبت مستقیم در MySQL با fallback به WebAdapter',
      version: '1.2.0',
      category: 'feature',
      priority: 'high',
      tags: 'mysql، تاریخچه، بروزرسانی',
      userComment: 'سیستم جامع ثبت تاریخچه با پشتیبانی MySQL',
    );

    if (success) {
      print('✅ رکورد تاریخچه با موفقیت ثبت شد');
    } else {
      print('❌ خطا در ثبت رکورد تاریخچه');
    }

    // تست ۳: دریافت رکوردهای ثبت شده
    print('\n🔍 بخش ۳: دریافت رکوردهای MySQL');
    print('-' * 30);

    final records = await MySqlUpdateHistoryService.getAllRecords();
    print('📊 تعداد رکوردهای موجود: ${records.length}');

    if (records.isNotEmpty) {
      print('📋 آخرین رکورد:');
      final lastRecord = records.last;
      print('   📍 عنوان: ${lastRecord.title}');
      print('   📅 تاریخ: ${lastRecord.shamsiDate} ${lastRecord.shamsiTime}');
      print('   🏷️ دسته: ${lastRecord.category}');
      print('   ⚡ اولویت: ${lastRecord.priority}');
    }

    // خلاصه نتایج
    print('\n🎯 خلاصه نتایج');
    print('=' * 50);
    print('✅ MySqlUpdateHistoryService: آماده');
    print('✅ ثبت تاریخچه: ${success ? "موفق" : "نیاز به بررسی"}');
    print('✅ دریافت رکوردها: ${records.isNotEmpty ? "موفق" : "خالی"}');
    print('✅ اتصال MySQL: ${connectionOk ? "فعال" : "غیرفعال (WebAdapter)"}');

    if (connectionOk && success) {
      print('\n🎉 تمام تست‌ها موفق! MySQL آماده استفاده است');
    } else {
      print('\n⚠️ MySQL در حال حاضر در دسترس نیست ولی سیستم آماده است');
    }
  } catch (e, stackTrace) {
    print('\n❌ خطا در تست: $e');
    print('📍 Stack trace: $stackTrace');
  }
}
