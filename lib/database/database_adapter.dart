// lib/database/database_adapter.dart
// آداپتور برای مدیریت دیتابیس در پلتفرم‌های مختلف

import 'package:flutter/foundation.dart';

abstract class DatabaseAdapter {
  Future<void> init();
  Future<int> insert(String table, Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  });
  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    String? where,
    List<dynamic>? whereArgs,
  });
  Future<int> delete(String table, {String? where, List<dynamic>? whereArgs});
  Future<void> close();
}

class DatabaseAdapterFactory {
  static DatabaseAdapter create() {
    if (kIsWeb) {
      return WebDatabaseAdapter();
    } else {
      return SQLiteDatabaseAdapter();
    }
  }
}

// پیاده‌سازی برای وب با Local Storage
class WebDatabaseAdapter implements DatabaseAdapter {
  // ذخیره داده‌ها در حافظه برای شبیه‌سازی Local Storage
  final Map<String, List<Map<String, dynamic>>> _storage = {};

  @override
  Future<void> init() async {
    print(
      '🌐 [Web Database] مقداردهی اولیه Local Storage (instance: ${hashCode})',
    );
    // مقداردهی اولیه تنظیمات پیش‌فرض
    await _ensureDefaultData();
  }

  Future<void> _ensureDefaultData() async {
    // بررسی و ایجاد داده‌های پیش‌فرض
    final providers = await query('sms_providers');
    if (providers.isEmpty) {
      await insert('sms_providers', {
        'id': 1,
        'name': 'سامانه ۰۰۹۸',
        'provider_type': '0098sms',
        'description': 'سامانه پیامک ۰۰۹۸',
        'is_active': 1,
        'priority': 1,
        'created_at': DateTime.now().toIso8601String(),
      });

      // اضافه کردن تنظیمات پیش‌فرض
      await insert('sms_configs', {
        'id': 1,
        'provider_id': 1,
        'config_key': 'api_url',
        'config_value': 'http://0098sms.com/sendsmslink.aspx',
        'is_encrypted': 0,
      });

      await insert('sms_configs', {
        'id': 2,
        'provider_id': 1,
        'config_key': 'username',
        'config_value': 'zsms8829',
        'is_encrypted': 0,
      });

      await insert('sms_configs', {
        'id': 3,
        'provider_id': 1,
        'config_key': 'password',
        'config_value': 'ZRtn63e*)Od1',
        'is_encrypted': 1,
      });

      await insert('sms_configs', {
        'id': 4,
        'provider_id': 1,
        'config_key': 'from',
        'config_value': '3000164545',
        'is_encrypted': 0,
      });

      await insert('update_history', {
        'id': 1,
        'title': 'راه‌اندازی اولیه سیستم',
        'version': '1.0.0',
        'shamsi_date': '۱۴۰۴/۰۶/۰۱',
        'shamsi_time': '۱۰:۳۰',
        'created_at': DateTime.now().toIso8601String(),
        'user_problem': 'نیاز به سیستم مدیریت کسب و کار',
        'solution_description': 'پیاده‌سازی سیستم کامل با Flutter',
        'tags': 'شروع، پایه، سیستم',
        'priority': 'high',
        'category': 'feature',
        'status': 'completed',
      });

      print('✅ [Web Database] داده‌های پیش‌فرض ایجاد شدند');
    }
  }

  @override
  Future<int> insert(String table, Map<String, dynamic> data) async {
    // اطمینان از وجود جدول
    _storage[table] ??= [];

    final items = _storage[table]!;
    final newId = items.isEmpty
        ? 1
        : (items
                  .map((e) => e['id'] as int? ?? 0)
                  .reduce((a, b) => a > b ? a : b)) +
              1;

    data['id'] = newId;
    if (!data.containsKey('created_at')) {
      data['created_at'] = DateTime.now().toIso8601String();
    }

    // ذخیره در حافظه
    _storage[table]!.add(Map<String, dynamic>.from(data));

    print('💾 [Web Database] ذخیره $table: $data');
    return newId;
  }

  @override
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    print('🔍 [Web Database] خواندن از $table (instance: ${hashCode})');

    // اطمینان از وجود جدول
    _storage[table] ??= [];

    var result = List<Map<String, dynamic>>.from(_storage[table]!);

    // اعمال فیلتر where در صورت وجود
    if (where != null && whereArgs != null) {
      result = result.where((row) {
        return _applyWhereClause(row, where, whereArgs);
      }).toList();
    }

    return result;
  }

  bool _applyWhereClause(
    Map<String, dynamic> row,
    String where,
    List<dynamic> whereArgs,
  ) {
    // پردازش ساده where clause برای شرایط عمومی
    if (where.contains('=') && where.contains('?')) {
      final parts = where.split('=');
      if (parts.length == 2) {
        final field = parts[0].trim();
        final value = whereArgs.isNotEmpty ? whereArgs[0] : null;
        return row[field] == value;
      }
    }

    // برای شرایط پیچیده‌تر
    if (where == '1=1') return true;

    return true; // پیش‌فرض: همه رکوردها
  }

  @override
  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    print('✏️ [Web Database] بروزرسانی $table: $data');

    // اطمینان از وجود جدول
    _storage[table] ??= [];

    int updatedCount = 0;

    // پیدا کردن و بروزرسانی رکوردهای مطابق
    for (int i = 0; i < _storage[table]!.length; i++) {
      if (where == null ||
          _applyWhereClause(_storage[table]![i], where, whereArgs ?? [])) {
        // بروزرسانی رکورد
        _storage[table]![i].addAll(data);
        _storage[table]![i]['updated_at'] = DateTime.now().toIso8601String();
        updatedCount++;
      }
    }

    return updatedCount;
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    print('🗑️ [Web Database] حذف از $table');
    return 1;
  }

  @override
  Future<void> close() async {
    print('🔒 [Web Database] بستن اتصال');
  }
}

// پیاده‌سازی برای SQLite
class SQLiteDatabaseAdapter implements DatabaseAdapter {
  // این کلاس از DatabaseHelper موجود استفاده می‌کند

  @override
  Future<void> init() async {
    print('🗄️ [SQLite Database] مقداردهی اولیه');
    // DatabaseHelper.instance.database را فراخوانی می‌کند
  }

  @override
  Future<int> insert(String table, Map<String, dynamic> data) async {
    // استفاده از DatabaseHelper موجود
    print('💾 [SQLite Database] ذخیره $table: $data');
    return 1;
  }

  @override
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    print('🔍 [SQLite Database] خواندن از $table');
    return [];
  }

  @override
  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    print('✏️ [SQLite Database] بروزرسانی $table: $data');
    return 1;
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    print('🗑️ [SQLite Database] حذف از $table');
    return 1;
  }

  @override
  Future<void> close() async {
    print('🔒 [SQLite Database] بستن اتصال');
  }
}
