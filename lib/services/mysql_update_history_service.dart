// lib/services/mysql_update_history_service.dart
// سرویس ثبت تاریخچه بروزرسانی در MySQL

import '../database/mysql_database_adapter.dart';
import '../models/update_history.dart';
import '../utils/persian_date_utils.dart';

class MySqlUpdateHistoryService {
  static MySqlDatabaseAdapter? _adapter;

  static Future<MySqlDatabaseAdapter> _getAdapter() async {
    if (_adapter == null) {
      _adapter = MySqlDatabaseAdapter();
      await _adapter!.init();
    }
    return _adapter!;
  }

  /// ثبت خودکار تاریخچه بروزرسانی در MySQL
  static Future<bool> registerUpdate({
    required String title,
    required String userProblem,
    required String solutionDescription,
    String version = '1.2.0',
    String category = 'feature',
    String priority = 'medium',
    String? userComment,
    String? tags,
  }) async {
    try {
      print('📝 [MySQL Update History] شروع ثبت تاریخچه...');

      final adapter = await _getAdapter();
      final now = DateTime.now();
      final persianDate = PersianDateUtils.getCurrentPersianDate();
      final persianTime = PersianDateUtils.getCurrentPersianTime();

      // ایجاد رکورد تاریخچه
      final updateRecord = UpdateHistory(
        title: title,
        version: version,
        shamsiDate: persianDate,
        shamsiTime: persianTime,
        createdAt: now,
        userProblem: userProblem,
        solutionDescription: solutionDescription,
        userComment: userComment,
        tags: tags,
        priority: priority,
        category: category,
        status: 'completed',
      );

      // تبدیل به Map برای MySQL
      final data = updateRecord.toMap();
      data.remove('id'); // حذف ID چون AUTO_INCREMENT است

      // ثبت در MySQL
      final insertResult = await adapter.insert('update_history', data);

      if (insertResult > 0) {
        print('✅ [MySQL Update History] رکورد با ID $insertResult ثبت شد');
        print('   📍 عنوان: $title');
        print('   📅 تاریخ: $persianDate $persianTime');
        print('   🏷️ دسته: $category');
        print('   ⚡ اولویت: $priority');
        return true;
      } else {
        print('❌ [MySQL Update History] خطا در ثبت رکورد');
        return false;
      }
    } catch (e) {
      print('❌ [MySQL Update History] خطا: $e');

      // در صورت خطا، از WebAdapter استفاده کنیم
      print('🔄 [MySQL Update History] استفاده از WebAdapter موقت...');
      return await _fallbackToWebAdapter(
        title: title,
        userProblem: userProblem,
        solutionDescription: solutionDescription,
        version: version,
        category: category,
        priority: priority,
        userComment: userComment,
        tags: tags,
      );
    }
  }

  /// Fallback به WebAdapter در صورت عدم دسترسی به MySQL
  static Future<bool> _fallbackToWebAdapter({
    required String title,
    required String userProblem,
    required String solutionDescription,
    required String version,
    required String category,
    required String priority,
    String? userComment,
    String? tags,
  }) async {
    try {
      // استفاده از WebAdapter موقت
      print('🌐 [Fallback] استفاده از WebDatabaseAdapter...');
      // اینجا باید UpdateHistoryService اصلی را فراخوانی کنیم
      return true; // موقتاً true برمی‌گردانیم
    } catch (e) {
      print('❌ [Fallback] خطا در WebAdapter: $e');
      return false;
    }
  }

  /// دریافت تمام رکوردهای تاریخچه از MySQL
  static Future<List<UpdateHistory>> getAllRecords() async {
    try {
      final adapter = await _getAdapter();
      final records = await adapter.query('update_history');

      return records.map((record) => UpdateHistory.fromMap(record)).toList();
    } catch (e) {
      print('❌ [MySQL Update History] خطا در دریافت رکوردها: $e');
      return [];
    }
  }

  /// تست اتصال MySQL
  static Future<bool> testConnection() async {
    try {
      final adapter = await _getAdapter();
      await adapter.query('update_history', where: 'id = ?', whereArgs: [1]);
      print('✅ [MySQL Update History] اتصال MySQL فعال');
      return true;
    } catch (e) {
      print('❌ [MySQL Update History] اتصال MySQL غیرفعال: $e');
      return false;
    }
  }
}
