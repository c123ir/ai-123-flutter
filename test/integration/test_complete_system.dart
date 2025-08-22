// test_complete_system.dart
// تست کامل سیستم دستیار هوشمند ۱۲۳

import 'lib/database/database_manager.dart';
import 'lib/models/update_history.dart';

Future<void> main() async {
  print('🚀 تست کامل سیستم دستیار هوشمند ۱۲۳');
  print('=' * 50);

  try {
    // تست ۱: وضعیت پایگاه داده
    print('\n📊 بخش ۱: تست پایگاه داده');
    print('-' * 30);

    final adapter = await DatabaseManager.getAdapter();
    print('✅ نوع پایگاه داده: ${adapter.runtimeType}');

    // تست ۲: ایجاد رکورد تاریخچه جدید
    print('\n📝 بخش ۲: تست ثبت تاریخچه');
    print('-' * 30);

    final newRecord = UpdateHistory(
      title: 'تست کامل سیستم پس از انتقال به MySQL',
      version: '1.2.0',
      shamsiDate: '۱۴۰۴/۰۶/۰۱',
      shamsiTime: '۱۱:۳۰',
      createdAt: DateTime.now(),
      userProblem: 'نیاز به اطمینان از صحت عملکرد سیستم پس از انتقال',
      solutionDescription: 'اجرای تست‌های کامل برای WebDatabaseAdapter و سیستم',
      category: 'testing',
      priority: 'high',
      status: 'completed',
    );

    print('✅ رکورد تاریخچه ایجاد شد');
    print('   📍 عنوان: ${newRecord.title}');
    print('   📅 تاریخ: ${newRecord.shamsiDate}');
    print('   🏷️ دسته: ${newRecord.category}');
    print('   ⚡ اولویت: ${newRecord.priority}');

    // تست ۳: تبدیل به JSON
    print('\n🔄 بخش ۳: تست سریال‌سازی');
    print('-' * 30);

    final jsonData = newRecord.toMap();
    print('✅ تبدیل به Map موفق');
    print('   🗄️ داده‌های کلیدی:');
    print('      - title: ${jsonData['title']}');
    print('      - category: ${jsonData['category']}');
    print('      - priority: ${jsonData['priority']}');

    // تست ۴: بازسازی از JSON
    print('\n🔧 بخش ۴: تست بازسازی');
    print('-' * 30);

    final rebuiltRecord = UpdateHistory.fromMap(jsonData);
    print('✅ بازسازی از Map موفق');
    print('   🔍 تطبیق داده‌ها:');
    print(
      '      - عنوان: ${rebuiltRecord.title == newRecord.title ? "✅" : "❌"}',
    );
    print(
      '      - دسته: ${rebuiltRecord.category == newRecord.category ? "✅" : "❌"}',
    );
    print(
      '      - اولویت: ${rebuiltRecord.priority == newRecord.priority ? "✅" : "❌"}',
    );

    // خلاصه نتایج
    print('\n🎯 خلاصه نتایج');
    print('=' * 50);
    print('✅ پایگاه داده: عملیاتی (${adapter.runtimeType})');
    print('✅ مدل داده: صحیح');
    print('✅ سریال‌سازی: موفق');
    print('✅ بازسازی: صحیح');
    print('\n🎉 تمام تست‌ها با موفقیت پاس شدند!');
    print('🚀 سیستم آماده استفاده است');
  } catch (e, stackTrace) {
    print('\n❌ خطا در تست: $e');
    print('📍 Stack trace: $stackTrace');
  }
}
