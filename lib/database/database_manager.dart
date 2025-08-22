// lib/database/database_manager.dart
// مدیریت کننده واحد برای دیتابیس با پشتیبانی از MySQL

import 'database_adapter.dart';

class DatabaseManager {
  static DatabaseManager? _instance;
  static DatabaseAdapter? _adapter;

  DatabaseManager._private();

  factory DatabaseManager() {
    _instance ??= DatabaseManager._private();
    return _instance!;
  }

  static Future<DatabaseAdapter> getAdapter() async {
    if (_adapter != null) return _adapter!;

    print('🗄️ [DatabaseManager] ایجاد WebDatabaseAdapter موقت');

    // موقتاً از WebDatabaseAdapter استفاده می‌کنیم تا MySQL سرور راه‌اندازی شود
    _adapter = DatabaseAdapterFactory.create();

    await _adapter!.init();
    return _adapter!;
  }

  static Future<void> resetAdapter() async {
    if (_adapter != null) {
      await _adapter!.close();
      _adapter = null;
    }
  }
}
