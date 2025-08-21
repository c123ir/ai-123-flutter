---
applyTo: "lib/database/**"
---

# قوانین مدیریت پایگاه داده (Database Management Rules)

## ساختار DatabaseHelper

### فرمت کلی

```dart
// lib/database/database_helper.dart
// کلاس کمکی مدیریت پایگاه داده - SQLite و MySQL integration

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../utils/logger.dart';
import '../utils/persian_date_helper.dart';

/// کلاس مدیریت پایگاه داده
/// شامل: ایجاد جداول، CRUD operations، migration ها
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  /// دریافت instance پایگاه داده
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// راه‌اندازی اولیه پایگاه داده
  Future<Database> _initDatabase() async {
    try {
      Logger.info('پایگاه داده', 'شروع راه‌اندازی');

      String path = join(await getDatabasesPath(), 'smart_assistant_123.db');

      return await openDatabase(
        path,
        version: 1,
        onCreate: _createDatabase,
        onUpgrade: _upgradeDatabase,
      );
    } catch (e) {
      Logger.error('پایگاه داده', 'خطا در راه‌اندازی: $e');
      rethrow;
    }
  }

  /// ایجاد جداول پایگاه داده
  Future<void> _createDatabase(Database db, int version) async {
    try {
      Logger.info('پایگاه داده', 'ایجاد جداول نسخه $version');

      // جدول کاربران
      await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          email TEXT UNIQUE NOT NULL,
          password_hash TEXT NOT NULL,
          role TEXT DEFAULT 'user',
          is_active INTEGER DEFAULT 1,
          profile_image_url TEXT,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');

      // جدول محصولات
      await db.execute('''
        CREATE TABLE products (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          description TEXT,
          price REAL NOT NULL,
          image_url TEXT,
          category_id INTEGER,
          is_available INTEGER DEFAULT 1,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          FOREIGN KEY (category_id) REFERENCES categories (id)
        )
      ''');

      // جدول دسته‌بندی‌ها
      await db.execute('''
        CREATE TABLE categories (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          description TEXT,
          parent_id INTEGER,
          is_active INTEGER DEFAULT 1,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          FOREIGN KEY (parent_id) REFERENCES categories (id)
        )
      ''');

      // اضافه کردن index ها
      await _createIndexes(db);

      Logger.success('پایگاه داده', 'جداول با موفقیت ایجاد شد');
    } catch (e) {
      Logger.error('پایگاه داده', 'خطا در ایجاد جداول: $e');
      rethrow;
    }
  }

  /// ایجاد index ها برای بهبود عملکرد
  Future<void> _createIndexes(Database db) async {
    await db.execute('CREATE INDEX idx_users_email ON users(email)');
    await db.execute('CREATE INDEX idx_products_category ON products(category_id)');
    await db.execute('CREATE INDEX idx_products_available ON products(is_available)');

    Logger.info('پایگاه داده', 'Index ها ایجاد شد');
  }

  /// بروزرسانی پایگاه داده
  Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    Logger.info('پایگاه داده', 'بروزرسانی از نسخه $oldVersion به $newVersion');

    for (int version = oldVersion + 1; version <= newVersion; version++) {
      await _migrateTo(db, version);
    }
  }

  /// اعمال migration برای نسخه خاص
  Future<void> _migrateTo(Database db, int version) async {
    switch (version) {
      case 2:
        await _migrateToV2(db);
        break;
      case 3:
        await _migrateToV3(db);
        break;
      default:
        Logger.warning('پایگاه داده', 'Migration برای نسخه $version وجود ندارد');
    }
  }

  /// Migration به نسخه ۲
  Future<void> _migrateToV2(Database db) async {
    Logger.info('پایگاه داده', 'Migration به نسخه ۲');

    await db.execute('''
      ALTER TABLE users ADD COLUMN phone_number TEXT
    ''');

    await db.execute('''
      ALTER TABLE users ADD COLUMN birth_date TEXT
    ''');
  }
}
```

## قوانین CRUD Operations

### Create (ایجاد)

```dart
/// اضافه کردن رکورد جدید
Future<int> insert(String table, Map<String, dynamic> data) async {
  try {
    final db = await database;

    // اضافه کردن تاریخ‌های ایجاد و بروزرسانی
    data['created_at'] = getCurrentPersianDateTime();
    data['updated_at'] = getCurrentPersianDateTime();

    Logger.info('پایگاه داده', 'درج رکورد جدید در جدول $table');

    final id = await db.insert(table, data);

    Logger.success('پایگاه داده', 'رکورد با شناسه $id درج شد');
    return id;
  } catch (e) {
    Logger.error('پایگاه داده', 'خطا در درج: $e');
    return -1;
  }
}
```

### Read (خواندن)

```dart
/// دریافت همه رکوردها
Future<List<Map<String, dynamic>>> getAll(String table) async {
  try {
    final db = await database;

    Logger.info('پایگاه داده', 'دریافت همه رکوردهای جدول $table');

    final result = await db.query(table);

    Logger.success('پایگاه داده', 'دریافت ${result.length} رکورد');
    return result;
  } catch (e) {
    Logger.error('پایگاه داده', 'خطا در دریافت: $e');
    return [];
  }
}

/// دریافت رکورد با شناسه
Future<Map<String, dynamic>?> getById(String table, int id) async {
  try {
    final db = await database;

    Logger.info('پایگاه داده', 'دریافت رکورد $id از جدول $table');

    final result = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      Logger.success('پایگاه داده', 'رکورد پیدا شد');
      return result.first;
    } else {
      Logger.warning('پایگاه داده', 'رکورد با شناسه $id پیدا نشد');
      return null;
    }
  } catch (e) {
    Logger.error('پایگاه داده', 'خطا در دریافت رکورد: $e');
    return null;
  }
}
```

### Update (بروزرسانی)

```dart
/// بروزرسانی رکورد
Future<bool> update(String table, int id, Map<String, dynamic> data) async {
  try {
    final db = await database;

    // بروزرسانی تاریخ تغییر
    data['updated_at'] = getCurrentPersianDateTime();

    Logger.info('پایگاه داده', 'بروزرسانی رکورد $id در جدول $table');

    final rowsAffected = await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (rowsAffected > 0) {
      Logger.success('پایگاه داده', 'رکورد با موفقیت بروزرسانی شد');
      return true;
    } else {
      Logger.warning('پایگاه داده', 'هیچ رکوردی بروزرسانی نشد');
      return false;
    }
  } catch (e) {
    Logger.error('پایگاه داده', 'خطا در بروزرسانی: $e');
    return false;
  }
}
```

### Delete (حذف)

```dart
/// حذف رکورد
Future<bool> delete(String table, int id) async {
  try {
    final db = await database;

    Logger.info('پایگاه داده', 'حذف رکورد $id از جدول $table');

    final rowsAffected = await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (rowsAffected > 0) {
      Logger.success('پایگاه داده', 'رکورد با موفقیت حذف شد');
      return true;
    } else {
      Logger.warning('پایگاه داده', 'هیچ رکوردی حذف نشد');
      return false;
    }
  } catch (e) {
    Logger.error('پایگاه داده', 'خطا در حذف: $e');
    return false;
  }
}
```

## قوانین Migration

### قواعد Migration

1. هرگز جدول یا ستون موجود را حذف نکنید
2. همیشه ALTER TABLE استفاده کنید
3. Default value برای ستون‌های جدید تعیین کنید
4. Migration ها باید قابل برگشت باشند

### مثال Migration

```dart
Future<void> _migrateToV3(Database db) async {
  Logger.info('پایگاه داده', 'Migration به نسخه ۳ - اضافه کردن جدول سفارشات');

  await db.execute('''
    CREATE TABLE orders (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      total_amount REAL NOT NULL,
      status TEXT DEFAULT 'pending',
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES users (id)
    )
  ''');

  await db.execute('CREATE INDEX idx_orders_user ON orders(user_id)');
  await db.execute('CREATE INDEX idx_orders_status ON orders(status)');
}
```

## بهترین روش‌ها

### Transaction ها

```dart
Future<bool> performComplexOperation() async {
  final db = await database;

  return await db.transaction((txn) async {
    try {
      // عملیات ۱
      await txn.insert('table1', data1);

      // عملیات ۲
      await txn.update('table2', data2, where: 'id = ?', whereArgs: [id]);

      // عملیات ۳
      await txn.delete('table3', where: 'old_id = ?', whereArgs: [oldId]);

      Logger.success('پایگاه داده', 'Transaction با موفقیت انجام شد');
      return true;
    } catch (e) {
      Logger.error('پایگاه داده', 'خطا در Transaction: $e');
      return false;
    }
  });
}
```

### Backup و Restore

```dart
Future<void> backupDatabase() async {
  try {
    final db = await database;
    final path = db.path;

    // کپی فایل پایگاه داده
    final backupPath = '${path}_backup_${getCurrentPersianDate()}';
    // پیاده‌سازی کپی فایل

    Logger.success('پایگاه داده', 'پشتیبان‌گیری در $backupPath ایجاد شد');
  } catch (e) {
    Logger.error('پایگاه داده', 'خطا در پشتیبان‌گیری: $e');
  }
}
```
