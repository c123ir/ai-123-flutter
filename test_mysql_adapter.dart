// test_mysql_adapter.dart
// تست MySqlDatabaseAdapter

import 'lib/database/mysql_database_adapter.dart';

Future<void> main() async {
  print('🧪 تست MySqlDatabaseAdapter...');

  try {
    final adapter = MySqlDatabaseAdapter();

    print('📋 مقداردهی adapter...');
    await adapter.init();

    print('📝 تست insert...');
    final insertResult = await adapter.insert('update_history', {
      'title': 'تست MySqlDatabaseAdapter',
      'version': '1.2.0',
      'shamsi_date': '۱۴۰۴/۰۶/۰۱',
      'shamsi_time': '۱۲:۰۰',
      'user_problem': 'تست اتصال MySQL',
      'solution_description': 'بررسی عملکرد MySqlDatabaseAdapter',
      'category': 'testing',
      'priority': 'medium',
    });

    print('✅ نتیجه insert: $insertResult');

    print('🔍 تست query...');
    final queryResult = await adapter.query('update_history');
    print('✅ تعداد رکوردها: ${queryResult.length}');

    print('🔒 بستن اتصال...');
    await adapter.close();

    print('🎉 تست MySqlDatabaseAdapter موفق بود!');
  } catch (e) {
    print('❌ خطا در تست: $e');
    print('💡 نکته: برای استفاده از MySQL به API backend نیاز است');
  }
}
