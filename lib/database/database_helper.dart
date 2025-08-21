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

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
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

    // جدول تاریخچه بروزرسانی
    await db.execute('''
      CREATE TABLE update_history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        version TEXT NOT NULL,
        shamsi_date TEXT NOT NULL,
        shamsi_time TEXT NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        user_problem TEXT NOT NULL,
        solution_description TEXT NOT NULL,
        user_comment TEXT,
        tags TEXT,
        priority TEXT DEFAULT 'medium',
        category TEXT DEFAULT 'feature',
        status TEXT DEFAULT 'completed'
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
        'config_value': 'ZRtn63e*)Od1',
        'is_encrypted': 1,
      },
      {'config_key': 'from', 'config_value': '3000164545', 'is_encrypted': 0},
      {
        'config_key': 'api_url',
        'config_value': 'http://0098sms.com/sendsmslink.aspx',
        'is_encrypted': 0,
      },
      {'config_key': 'domain', 'config_value': '0098', 'is_encrypted': 0},
      {'config_key': 'method', 'config_value': 'GET', 'is_encrypted': 0},
    ];

    for (final config in configs) {
      await db.insert('sms_configs', {'provider_id': providerId, ...config});
    }
  }

  /// بروزرسانی دیتابیس (Migration)
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // اضافه کردن جدول تاریخچه بروزرسانی در نسخه ۲
      await db.execute('''
        CREATE TABLE update_history(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          version TEXT NOT NULL,
          shamsi_date TEXT NOT NULL,
          shamsi_time TEXT NOT NULL,
          created_at TEXT DEFAULT CURRENT_TIMESTAMP,
          user_problem TEXT NOT NULL,
          solution_description TEXT NOT NULL,
          user_comment TEXT,
          tags TEXT,
          priority TEXT DEFAULT 'medium',
          category TEXT DEFAULT 'feature',
          status TEXT DEFAULT 'completed'
        )
      ''');

      // اضافه کردن بروزرسانی اولیه
      await _insertInitialUpdateHistory(db);
    }
  }

  /// اضافه کردن بروزرسانی‌های اولیه
  Future _insertInitialUpdateHistory(Database db) async {
    // بروزرسانی سیستم تبدیل اعداد فارسی
    await db.insert('update_history', {
      'title': 'اضافه کردن سیستم تبدیل اعداد فارسی',
      'version': '1.2.0',
      'shamsi_date': '۱۴۰۴/۰۵/۳۰',
      'shamsi_time': '۲۲:۳۰',
      'created_at': DateTime.now().toIso8601String(),
      'user_problem':
          'کاربر گزارش کرد که وقتی شماره موبایل را به فارسی وارد می‌کند، پیامک ارسال نمی‌شود و خطا دریافت می‌کند.',
      'solution_description':
          '''ایجاد کلاس PersianNumberUtils با قابلیت‌های زیر:
- تبدیل اعداد فارسی و عربی به انگلیسی
- فرمت‌بندی شماره موبایل ایرانی
- اعتبارسنجی شماره‌ها
- حذف کاراکترهای اضافی
- تبدیل خودکار در SmsService
- پشتیبانی از تمام فرمت‌های ورودی (با/بدون صفر، کد کشور، فاصله، خط تیره)
نتیجه: اکنون کاربران می‌توانند از اعداد فارسی استفاده کنند و سیستم خودکار آن‌ها را تبدیل می‌کند.''',
      'user_comment': 'مشکل کاملاً حل شد! عالی بود.',
      'tags': 'پیامک، اعداد فارسی، تبدیل، شماره موبایل',
      'priority': 'high',
      'category': 'feature',
      'status': 'completed',
    });

    // بروزرسانی سیستم مدیریت پیامک
    await db.insert('update_history', {
      'title': 'توسعه سیستم مدیریت پیامک کامل',
      'version': '1.1.0',
      'shamsi_date': '۱۴۰۴/۰۵/۲۹',
      'shamsi_time': '۱۵:۰۰',
      'created_at': DateTime.now()
          .subtract(const Duration(days: 1))
          .toIso8601String(),
      'user_problem':
          'نیاز به سیستم کاملی برای مدیریت پیامک‌ها، ارسال انبوه، لاگ‌گیری و پشتیبانی از چند سامانه.',
      'solution_description': '''طراحی و پیاده‌سازی سیستم جامع مدیریت پیامک:
- جداول sms_providers, sms_configs, sms_logs
- کلاس SmsService با پشتیبانی از سامانه ۰۰۹۸
- رابط کاربری SmsPanel با ۴ تب
- آمار و گزارش‌گیری
- تست اتصال سامانه‌ها
- ارسال تکی و انبوه
- مدیریت تنظیمات سامانه‌ها''',
      'tags': 'پیامک، SMS، سامانه ۰۰۹۸، مدیریت',
      'priority': 'high',
      'category': 'feature',
      'status': 'completed',
    });
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
    // فقط برای جداولی که فیلد updated_at دارند این فیلد را اضافه کن
    if (table != 'sms_logs' && table != 'analytics') {
      data['updated_at'] = DateTime.now().toIso8601String();
    }
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
