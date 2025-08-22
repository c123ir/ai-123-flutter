// lib/database/d  static Future<DatabaseAdapter> getAdapter() async {
    if (adapter != null) return adapter!;

    print('🗄️ [DatabaseManager] ایجاد MySQLAdapter');

    // تنظیمات MySQL
    const String baseUrl = 'http://localhost:3000/api'; // آدرس API
    const String apiKey = 'your-api-key-here'; // کلید APImanager.dart
// مدیریت کننده واحد برای دیتابیس با پشتیبانی از MySQL

import 'database_adapter.dart';
import 'mysql_adapter.dart';

class DatabaseManager {
  static DatabaseManager? _instance;
  static DatabaseAdapter? _adapter;

  DatabaseManager._private();

  factory DatabaseManager() {
    _instance ??= DatabaseManager._private();
    return _instance!;
  }

  Future<DatabaseAdapter> getAdapter() async {
    if (_adapter != null) return _adapter!;

    print('�️ [DatabaseManager] ایجاد MySQLAdapter');

    // تنظیمات MySQL
    const String baseUrl = 'http://localhost:3000/api'; // آدرس API
    const String apiKey = 'your-api-key-here'; // کلید API

    _adapter = MySQLAdapter(baseUrl: baseUrl, apiKey: apiKey);

    await _adapter!.init();
    return _adapter!;
  }

  Future<void> resetAdapter() async {
    if (_adapter != null) {
      await _adapter!.close();
      _adapter = null;
    }
  }
}
