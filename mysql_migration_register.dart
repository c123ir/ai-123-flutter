// mysql_migration_register.dart
// ثبت تاریخچه بروزرسانی برای مهاجرت به MySQL

import 'lib/services/json_update_history_service.dart';

void main() async {
  final service = JsonUpdateHistoryService();

  print('🔄 در حال ثبت رکورد مهاجرت MySQL...');

  final success = await service.addUpdate({
    'title': 'مهاجرت از SQLite به MySQL',
    'userProblem':
        'نیاز به یکپارچگی دیتابیس در همه پلتفرم‌ها و حل مشکل عدم همگام‌سازی بین وب و دسکتاپ',
    'solutionDescription': '''
پیاده‌سازی کامل سیستم MySQL با آداپتور جدید:
• MySQLAdapter برای ارتباط با API
• DatabaseManager بروزرسانی شده 
• Backend API با Node.js + MySQL
• حذف وابستگی‌های SQLite
• Schema کامل MySQL
• راهنمای مهاجرت
    ''',
    'tags': 'MySQL, Database Migration, API, Backend, Architecture',
    'category': 'Database',
    'priority': 'High',
    'version': '1.3.0',
    'status': 'completed',
    'createdAt': DateTime.now().toIso8601String(),
  });

  if (success) {
    print('✅ رکورد مهاجرت MySQL با موفقیت ثبت شد');
    print('📋 جزئیات:');
    print('   📂 دسته: Database Migration');
    print('   🔺 اولویت: High');
    print('   📊 نسخه: 1.3.0');
    print('   📅 تاریخ: ${DateTime.now()}');
  } else {
    print('❌ خطا در ثبت رکورد');
  }
}
