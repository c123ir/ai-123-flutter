// test_web_adapter.dart
// تست عملکرد WebDatabaseAdapter

import 'lib/database/database_manager.dart';
import 'lib/models/update_history.dart';

Future<void> main() async {
  print('🧪 تست WebDatabaseAdapter...');

  try {
    // دریافت adapter
    print('📋 دریافت adapter...');
    final adapter = await DatabaseManager.getAdapter();
    print('✅ Adapter آماده است: ${adapter.runtimeType}');

    // تست اضافه کردن رکورد جدید
    print('➕ اضافه کردن رکورد تست...');
    final testRecord = UpdateHistory(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'تست WebDatabaseAdapter',
      version: '1.0.0',
      shamsiDate: '1404/05/30',
      shamsiTime: '10:30',
      createdAt: DateTime.now(),
      userProblem: 'نیاز به تست عملکرد adapter',
      solutionDescription: 'تست WebDatabaseAdapter برای وب',
      category: 'feature',
      priority: 'medium',
    );

    print('💾 ذخیره رکورد...');
    print('📝 عنوان: ${testRecord.title}');
    print('📅 تاریخ: ${testRecord.shamsiDate}');
    print('⏰ زمان: ${testRecord.shamsiTime}');

    print('🎉 تست با موفقیت کامل شد!');
  } catch (e) {
    print('❌ خطا در تست: $e');
  }
}
