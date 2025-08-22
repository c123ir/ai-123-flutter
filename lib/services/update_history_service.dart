// lib/services/update_history_service.dart
// سرویس مدیریت تاریخچه بروزرسانی - CRUD operations و منطق کسب‌وکار

import '../database/database_manager.dart';
import '../models/update_history.dart';
import '../utils/persian_number_utils.dart';

class UpdateHistoryService {
  // Singleton pattern
  static UpdateHistoryService? _instance;
  static UpdateHistoryService get instance {
    _instance ??= UpdateHistoryService._internal();
    return _instance!;
  }

  // Private constructor
  UpdateHistoryService._internal();

  /// ثبت بروزرسانی جدید
  Future<int> addUpdate({
    required String title,
    required String version,
    required String userProblem,
    required String solutionDescription,
    String? userComment,
    String? tags,
    String priority = 'medium',
    String category = 'feature',
    String status = 'completed',
  }) async {
    try {
      // دریافت تاریخ و زمان فارسی
      final now = DateTime.now();
      final shamsiDate = _getCurrentShamsiDate();
      final shamsiTime = _getCurrentShamsiTime();

      final update = UpdateHistory(
        title: title,
        version: version,
        shamsiDate: shamsiDate,
        shamsiTime: shamsiTime,
        createdAt: now,
        userProblem: userProblem,
        solutionDescription: solutionDescription,
        userComment: userComment,
        tags: tags,
        priority: priority,
        category: category,
        status: status,
      );

      final adapter = await DatabaseManager.getAdapter();
      final id = await adapter.insert('update_history', update.toMap());

      print('✅ [تاریخچه] بروزرسانی جدید ثبت شد: $title (ID: $id)');
      return id;
    } catch (e) {
      print('❌ [تاریخچه] خطا در ثبت بروزرسانی: $e');
      throw Exception('خطا در ثبت بروزرسانی: $e');
    }
  }

  /// دریافت تمام بروزرسانی‌ها (مرتب‌سازی بر اساس تاریخ)
  Future<List<UpdateHistory>> getAllUpdates({
    String? category,
    String? priority,
    int? limit,
  }) async {
    try {
      String whereClause = '';
      List<dynamic> whereArgs = [];

      if (category != null) {
        whereClause += 'category = ?';
        whereArgs.add(category);
      }

      if (priority != null) {
        if (whereClause.isNotEmpty) whereClause += ' AND ';
        whereClause += 'priority = ?';
        whereArgs.add(priority);
      }

      // ساخت شرط WHERE برای query
      String? where;
      List<dynamic>? whereParams;

      if (category != null && priority != null) {
        where = 'category = ? AND priority = ?';
        whereParams = [category, priority];
      } else if (category != null) {
        where = 'category = ?';
        whereParams = [category];
      } else if (priority != null) {
        where = 'priority = ?';
        whereParams = [priority];
      }

      final adapter = await DatabaseManager.getAdapter();
      final data = await adapter.query(
        'update_history',
        where: where,
        whereArgs: whereParams,
      );

      // مرتب‌سازی بر اساس تاریخ (نزولی)
      data.sort((a, b) {
        final aDate =
            DateTime.tryParse(a['created_at'] ?? '') ?? DateTime(1970);
        final bDate =
            DateTime.tryParse(b['created_at'] ?? '') ?? DateTime(1970);
        return bDate.compareTo(aDate);
      });

      // محدود کردن تعداد نتایج
      final limitedData = limit != null && limit < data.length
          ? data.take(limit).toList()
          : data;

      return limitedData.map((map) => UpdateHistory.fromMap(map)).toList();
    } catch (e) {
      print('❌ [تاریخچه] خطا در دریافت بروزرسانی‌ها: $e');
      return [];
    }
  }

  /// دریافت بروزرسانی بر اساس ID
  Future<UpdateHistory?> getUpdateById(int id) async {
    try {
      final adapter = await DatabaseManager.getAdapter();
      final data = await adapter.query(
        'update_history',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (data.isNotEmpty) {
        return UpdateHistory.fromMap(data.first);
      }
      return null;
    } catch (e) {
      print('❌ [تاریخچه] خطا در دریافت بروزرسانی: $e');
      return null;
    }
  }

  /// بروزرسانی یک رکورد
  Future<bool> updateHistory(UpdateHistory update) async {
    try {
      final adapter = await DatabaseManager.getAdapter();
      final result = await adapter.update(
        'update_history',
        update.toMap(),
        where: 'id = ?',
        whereArgs: [update.id],
      );

      print('✅ [تاریخچه] بروزرسانی ویرایش شد: ${update.title}');
      return result > 0;
    } catch (e) {
      print('❌ [تاریخچه] خطا در ویرایش بروزرسانی: $e');
      return false;
    }
  }

  /// افزودن نظر کاربر به بروزرسانی
  Future<bool> addUserComment(int updateId, String comment) async {
    try {
      final update = await getUpdateById(updateId);
      if (update == null) return false;

      final updatedHistory = update.copyWith(userComment: comment);

      return await updateHistory(updatedHistory);
    } catch (e) {
      print('❌ [تاریخچه] خطا در افزودن نظر: $e');
      return false;
    }
  }

  /// حذف بروزرسانی
  Future<bool> deleteUpdate(int id) async {
    try {
      final adapter = await DatabaseManager.getAdapter();
      final result = await adapter.delete(
        'update_history',
        where: 'id = ?',
        whereArgs: [id],
      );
      print('✅ [تاریخچه] بروزرسانی حذف شد (ID: $id)');
      return result > 0;
    } catch (e) {
      print('❌ [تاریخچه] خطا در حذف بروزرسانی: $e');
      return false;
    }
  }

  /// دریافت آمار بروزرسانی‌ها
  Future<Map<String, int>> getUpdateStats() async {
    try {
      final all = await getAllUpdates();

      Map<String, int> stats = {
        'total': all.length,
        'features': 0,
        'bugfixes': 0,
        'enhancements': 0,
        'this_month': 0,
      };

      final now = DateTime.now();
      final thisMonth =
          '${now.year.toString().padLeft(4, '0')}/${now.month.toString().padLeft(2, '0')}';

      for (var update in all) {
        // شمارش بر اساس دسته‌بندی
        switch (update.category) {
          case 'feature':
            stats['features'] = stats['features']! + 1;
            break;
          case 'bugfix':
            stats['bugfixes'] = stats['bugfixes']! + 1;
            break;
          case 'enhancement':
            stats['enhancements'] = stats['enhancements']! + 1;
            break;
        }

        // شمارش این ماه
        if (update.shamsiDate.startsWith(thisMonth)) {
          stats['this_month'] = stats['this_month']! + 1;
        }
      }

      return stats;
    } catch (e) {
      print('❌ [تاریخچه] خطا در دریافت آمار: $e');
      return {'total': 0};
    }
  }

  /// جستجو در بروزرسانی‌ها
  Future<List<UpdateHistory>> searchUpdates(String query) async {
    try {
      // دریافت تمام رکوردها و فیلتر کردن آن‌ها در Dart
      final allUpdates = await getAllUpdates();

      final filteredUpdates = allUpdates.where((update) {
        final searchQuery = query.toLowerCase();
        return update.title.toLowerCase().contains(searchQuery) ||
            update.userProblem.toLowerCase().contains(searchQuery) ||
            update.solutionDescription.toLowerCase().contains(searchQuery);
      }).toList();

      return filteredUpdates;
    } catch (e) {
      print('❌ [تاریخچه] خطا در جستجو: $e');
      return [];
    }
  }

  /// ثبت خودکار بروزرسانی (برای GitHub Copilot)
  Future<int> autoRegisterUpdate({
    required String title,
    required String version,
    required String userProblem,
    required String solutionDescription,
    String? tags,
    String category = 'feature',
  }) async {
    print('🤖 [تاریخچه] ثبت خودکار بروزرسانی: $title');

    return await addUpdate(
      title: title,
      version: version,
      userProblem: userProblem,
      solutionDescription: solutionDescription,
      tags: tags,
      category: category,
      priority: 'medium',
      status: 'completed',
    );
  }

  /// دریافت تاریخ شمسی فعلی
  String _getCurrentShamsiDate() {
    final now = DateTime.now();
    // تبدیل به تاریخ شمسی - فعلاً ساده‌سازی شده
    return PersianNumberUtils.convertToPersian(
      '${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}',
    );
  }

  /// دریافت زمان فارسی فعلی
  String _getCurrentShamsiTime() {
    final now = DateTime.now();
    return PersianNumberUtils.convertToPersian(
      '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
    );
  }

  /// دریافت بروزرسانی‌های اخیر (۱۰ تای آخر)
  Future<List<UpdateHistory>> getRecentUpdates() async {
    return await getAllUpdates(limit: 10);
  }

  /// دریافت بروزرسانی‌ها بر اساس نسخه
  Future<List<UpdateHistory>> getUpdatesByVersion(String version) async {
    try {
      final adapter = await DatabaseManager.getAdapter();
      final data = await adapter.query(
        'update_history',
        where: 'version = ?',
        whereArgs: [version],
      );

      // مرتب‌سازی بر اساس تاریخ (نزولی)
      data.sort((a, b) {
        final aDate =
            DateTime.tryParse(a['created_at'] ?? '') ?? DateTime(1970);
        final bDate =
            DateTime.tryParse(b['created_at'] ?? '') ?? DateTime(1970);
        return bDate.compareTo(aDate);
      });

      return data.map((map) => UpdateHistory.fromMap(map)).toList();
    } catch (e) {
      print('❌ [تاریخچه] خطا در دریافت بروزرسانی‌های نسخه: $e');
      return [];
    }
  }
}
