// lib/database/database_helper.dart
// مدیریت پایگاه داده SQLite - شامل ایجاد و مدیریت جداول

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('smart_assistant.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // جدول کاربران
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        phone TEXT,
        password TEXT NOT NULL,
        role TEXT DEFAULT 'customer',
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // جدول محصولات
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        category TEXT,
        image_url TEXT,
        is_active INTEGER DEFAULT 1,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // جدول مشاوره‌ها
    await db.execute('''
      CREATE TABLE consultations(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        product_id INTEGER,
        message TEXT NOT NULL,
        ai_response TEXT,
        status TEXT DEFAULT 'pending',
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id),
        FOREIGN KEY (product_id) REFERENCES products (id)
      )
    ''');

    // جدول چت‌های AI
    await db.execute('''
      CREATE TABLE ai_chats(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        message TEXT NOT NULL,
        response TEXT,
        chat_type TEXT DEFAULT 'general',
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // جدول فرم‌ها
    await db.execute('''
      CREATE TABLE forms(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        fields TEXT NOT NULL,
        is_active INTEGER DEFAULT 1,
        created_by INTEGER NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (created_by) REFERENCES users (id)
      )
    ''');

    // جدول پاسخ‌های فرم
    await db.execute('''
      CREATE TABLE form_submissions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        form_id INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        responses TEXT NOT NULL,
        submitted_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (form_id) REFERENCES forms (id),
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // جدول تماس‌ها (CRM)
    await db.execute('''
      CREATE TABLE crm_contacts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT,
        phone TEXT,
        company TEXT,
        status TEXT DEFAULT 'lead',
        notes TEXT,
        assigned_to INTEGER,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (assigned_to) REFERENCES users (id)
      )
    ''');

    // جدول آمار و گزارش‌ها
    await db.execute('''
      CREATE TABLE analytics(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        event_type TEXT NOT NULL,
        event_data TEXT,
        user_id INTEGER,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // جدول سامانه‌های پیامکی
    await db.execute('''
      CREATE TABLE sms_providers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        provider_type TEXT NOT NULL,
        description TEXT,
        is_active INTEGER DEFAULT 1,
        priority INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // جدول تنظیمات سامانه‌های پیامکی
    await db.execute('''
      CREATE TABLE sms_configs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        provider_id INTEGER NOT NULL,
        config_key TEXT NOT NULL,
        config_value TEXT NOT NULL,
        is_encrypted INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (provider_id) REFERENCES sms_providers (id),
        UNIQUE(provider_id, config_key)
      )
    ''');

    // جدول لاگ ارسال پیامک‌ها
    await db.execute('''
      CREATE TABLE sms_logs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        provider_id INTEGER NOT NULL,
        recipient_phone TEXT NOT NULL,
        message_text TEXT NOT NULL,
        status TEXT DEFAULT 'pending',
        response_code TEXT,
        response_message TEXT,
        sent_at TEXT,
        delivered_at TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (provider_id) REFERENCES sms_providers (id)
      )
    ''');

    // اضافه کردن داده‌های اولیه
    await _insertInitialData(db);
  }

  Future _insertInitialData(Database db) async {
    // کاربر ادمین
    await db.insert('users', {
      'name': 'مدیر سیستم',
      'email': 'admin@example.com',
      'phone': '09123456789',
      'password': '123456', // در واقعیت باید hash شود
      'role': 'admin',
    });

    // محصولات نمونه
    await db.insert('products', {
      'name': 'محصول نمونه ۱',
      'description': 'توضیحات محصول اول',
      'price': 100000,
      'category': 'الکترونیک',
    });

    await db.insert('products', {
      'name': 'محصول نمونه ۲',
      'description': 'توضیحات محصول دوم',
      'price': 250000,
      'category': 'پوشاک',
    });

    // اضافه کردن سامانه پیامکی ۰۰۹۸
    await _insertSmsProviderData(db);
  }

  Future _insertSmsProviderData(Database db) async {
    // ثبت سامانه ۰۰۹۸
    final providerId = await db.insert('sms_providers', {
      'name': 'سامانه پیامکی ۰۰۹۸',
      'provider_type': '0098sms',
      'description': 'سامانه پیامکی ۰۰۹۸ برای ارسال پیامک انبوه',
      'is_active': 1,
      'priority': 1,
    });

    // تنظیمات سامانه ۰۰۹۸
    final configs = [
      {'config_key': 'username', 'config_value': 'zsms8829', 'is_encrypted': 0},
      {
        'config_key': 'password',
        'config_value': 'j494moo*O^HU',
        'is_encrypted': 1,
      },
      {'config_key': 'from', 'config_value': '3000164545', 'is_encrypted': 0},
      {
        'config_key': 'api_url',
        'config_value': 'https://api.0098sms.com/sendsms.aspx',
        'is_encrypted': 0,
      },
    ];

    for (final config in configs) {
      await db.insert('sms_configs', {'provider_id': providerId, ...config});
    }
  }

  // متدهای کاربردی
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    final db = await instance.database;
    return db.query(table);
  }

  Future<Map<String, dynamic>?> queryById(String table, int id) async {
    final db = await instance.database;
    final result = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> update(String table, Map<String, dynamic> data, int id) async {
    final db = await instance.database;
    data['updated_at'] = DateTime.now().toIso8601String();
    return db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(String table, int id) async {
    final db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
