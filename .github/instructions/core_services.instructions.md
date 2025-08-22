---
applyTo: "lib_new/core/**"
---

# Core Services Instructions - سرویس‌های اساسی

## 🎯 مأموریت

توسعه سرویس‌های اساسی و زیرساخت‌های مشترک پروژه

## 📂 ساختار الزامی

```
core/
├── network/               # شبکه و API
│   ├── api_client.dart   # HTTP client اصلی
│   ├── api_endpoints.dart # URL endpoints
│   ├── api_interceptors.dart # Request/Response interceptors
│   ├── network_info.dart # بررسی اتصال شبکه
│   └── network.dart      # Export file
├── database/             # پایگاه داده
│   ├── database_helper.dart # SQLite helper
│   ├── database_tables.dart # تعریف جداول
│   ├── database_migrations.dart # Migration ها
│   ├── mysql_adapter.dart # MySQL adapter
│   └── database.dart     # Export file
├── storage/              # ذخیره‌سازی محلی
│   ├── secure_storage.dart # ذخیره امن
│   ├── shared_preferences.dart # تنظیمات
│   ├── file_storage.dart # فایل‌های محلی
│   └── storage.dart      # Export file
├── services/             # سرویس‌های اصلی
│   ├── auth_service.dart # احراز هویت
│   ├── notification_service.dart # اعلان‌ها
│   ├── analytics_service.dart # آنالیتیکس
│   ├── logging_service.dart # لاگ‌گیری
│   ├── sms_service.dart  # مدیریت پیامک
│   └── services.dart     # Export file
├── errors/               # مدیریت خطاها
│   ├── exceptions.dart   # استثناهای سفارشی
│   ├── failures.dart     # مدل‌های شکست
│   ├── error_handler.dart # مدیریت خطاها
│   └── errors.dart       # Export file
├── localization/         # چندزبانه‌ای
│   ├── app_localizations.dart # تنظیمات l10n
│   ├── persian_utils.dart # ابزارهای فارسی
│   └── localization.dart # Export file
└── core.dart            # Main export file
```

## 🌐 Network Templates

### API Client

```dart
// network/api_client.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../errors/exceptions.dart';
import 'api_endpoints.dart';

/// HTTP Client اصلی برای ارتباط با API
class ApiClient {
  final http.Client _httpClient;
  final String _baseUrl;
  String? _authToken;

  ApiClient({
    required String baseUrl,
    http.Client? httpClient,
  })  : _baseUrl = baseUrl,
        _httpClient = httpClient ?? http.Client();

  /// تنظیم توکن احراز هویت
  void setAuthToken(String token) {
    _authToken = token;
  }

  /// حذف توکن احراز هویت
  void clearAuthToken() {
    _authToken = null;
  }

  /// درخواست GET
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParameters,
  }) async {
    final uri = _buildUri(endpoint, queryParameters);

    try {
      final response = await _httpClient.get(
        uri,
        headers: _buildHeaders(),
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('اتصال شبکه برقرار نیست');
    } on HttpException {
      throw NetworkException('خطا در درخواست HTTP');
    } catch (e) {
      throw ServerException('خطای غیرمنتظره: ${e.toString()}');
    }
  }

  /// درخواست POST
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
  }) async {
    final uri = _buildUri(endpoint, queryParameters);

    try {
      final response = await _httpClient.post(
        uri,
        headers: _buildHeaders(),
        body: body != null ? json.encode(body) : null,
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('اتصال شبکه برقرار نیست');
    } on HttpException {
      throw NetworkException('خطا در درخواست HTTP');
    } catch (e) {
      throw ServerException('خطای غیرمنتظره: ${e.toString()}');
    }
  }

  /// درخواست PUT
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
  }) async {
    final uri = _buildUri(endpoint, queryParameters);

    try {
      final response = await _httpClient.put(
        uri,
        headers: _buildHeaders(),
        body: body != null ? json.encode(body) : null,
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('اتصال شبکه برقرار نیست');
    } on HttpException {
      throw NetworkException('خطا در درخواست HTTP');
    } catch (e) {
      throw ServerException('خطای غیرمنتظره: ${e.toString()}');
    }
  }

  /// درخواست DELETE
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? queryParameters,
  }) async {
    final uri = _buildUri(endpoint, queryParameters);

    try {
      final response = await _httpClient.delete(
        uri,
        headers: _buildHeaders(),
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException('اتصال شبکه برقرار نیست');
    } on HttpException {
      throw NetworkException('خطا در درخواست HTTP');
    } catch (e) {
      throw ServerException('خطای غیرمنتظره: ${e.toString()}');
    }
  }

  Uri _buildUri(String endpoint, Map<String, String>? queryParameters) {
    final path = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return Uri.parse('$_baseUrl$path').replace(
      queryParameters: queryParameters,
    );
  }

  Map<String, String> _buildHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      try {
        return json.decode(response.body) as Map<String, dynamic>;
      } catch (e) {
        return {'data': response.body};
      }
    }

    switch (statusCode) {
      case 401:
        throw UnauthorizedException('احراز هویت انجام نشده');
      case 403:
        throw ForbiddenException('دسترسی غیرمجاز');
      case 404:
        throw NotFoundException('منبع یافت نشد');
      case 500:
        throw ServerException('خطای داخلی سرور');
      default:
        throw ServerException('خطای سرور: $statusCode');
    }
  }

  void dispose() {
    _httpClient.close();
  }
}
```

### API Endpoints

```dart
// network/api_endpoints.dart

/// تعریف endpoint های API
class ApiEndpoints {
  // Base URLs
  static const String baseUrl = 'https://api.example.com/v1';
  static const String authBaseUrl = '$baseUrl/auth';
  static const String userBaseUrl = '$baseUrl/users';
  static const String adminBaseUrl = '$baseUrl/admin';

  // Authentication
  static const String login = '$authBaseUrl/login';
  static const String logout = '$authBaseUrl/logout';
  static const String register = '$authBaseUrl/register';
  static const String refreshToken = '$authBaseUrl/refresh';
  static const String forgotPassword = '$authBaseUrl/forgot-password';

  // User Management
  static const String users = userBaseUrl;
  static String userById(int id) => '$userBaseUrl/$id';
  static const String updateProfile = '$userBaseUrl/profile';

  // Admin
  static const String adminDashboard = '$adminBaseUrl/dashboard';
  static const String adminUsers = '$adminBaseUrl/users';
  static const String adminReports = '$adminBaseUrl/reports';
  static const String adminSettings = '$adminBaseUrl/settings';

  // SMS
  static const String smsProviders = '$baseUrl/sms/providers';
  static const String sendSms = '$baseUrl/sms/send';
  static const String smsHistory = '$baseUrl/sms/history';

  // Consultation
  static const String consultations = '$baseUrl/consultations';
  static String consultationById(int id) => '$consultations/$id';

  // AI Chat
  static const String aiChat = '$baseUrl/ai/chat';
  static const String aiChatHistory = '$baseUrl/ai/chat/history';
}
```

## 🗄️ Database Templates

### Database Helper

```dart
// database/database_helper.dart
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'database_tables.dart';

/// کلاس کمکی برای مدیریت SQLite
class DatabaseHelper {
  static const String _databaseName = 'ai_123.db';
  static const int _databaseVersion = 1;

  static Database? _database;

  /// دریافت instance دیتابیس
  static Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// مقداردهی دیتابیس
  static Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// ایجاد جداول
  static Future<void> _onCreate(Database db, int version) async {
    // ایجاد جداول یکی یکی
    for (final table in DatabaseTables.allTables) {
      await db.execute(table);
    }
  }

  /// بروزرسانی دیتابیس
  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // منطق migration ها
    if (oldVersion < 2) {
      // migration for version 2
    }
  }

  /// درج رکورد
  static Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  /// بروزرسانی رکورد
  static Future<int> update(
    String table,
    Map<String, dynamic> data, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    return await db.update(table, data, where: where, whereArgs: whereArgs);
  }

  /// حذف رکورد
  static Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  /// جستجو
  static Future<List<Map<String, dynamic>>> query(
    String table, {
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    return await db.query(
      table,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  /// اجرای SQL خام
  static Future<void> execute(String sql) async {
    final db = await database;
    await db.execute(sql);
  }

  /// بستن دیتابیس
  static Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
```

## 🔐 Auth Service Template

```dart
// services/auth_service.dart
import 'dart:convert';

import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../storage/secure_storage.dart';
import '../errors/exceptions.dart';

/// سرویس احراز هویت
class AuthService {
  final ApiClient _apiClient;
  final SecureStorage _secureStorage;

  AuthService({
    required ApiClient apiClient,
    required SecureStorage secureStorage,
  })  : _apiClient = apiClient,
        _secureStorage = secureStorage;

  /// ورود کاربر
  Future<AuthResult> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        body: {
          'email': email,
          'password': password,
        },
      );

      final authResult = AuthResult.fromJson(response);

      // ذخیره توکن
      await _secureStorage.write('auth_token', authResult.token);
      await _secureStorage.write('user_data', json.encode(authResult.user.toJson()));

      // تنظیم توکن در API client
      _apiClient.setAuthToken(authResult.token);

      return authResult;
    } catch (e) {
      throw AuthException('خطا در ورود: ${e.toString()}');
    }
  }

  /// خروج کاربر
  Future<void> logout() async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
    } catch (e) {
      // ادامه خروج حتی در صورت خطا
    } finally {
      // پاک کردن داده‌های محلی
      await _secureStorage.delete('auth_token');
      await _secureStorage.delete('user_data');
      _apiClient.clearAuthToken();
    }
  }

  /// بررسی وضعیت احراز هویت
  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read('auth_token');
    return token != null && token.isNotEmpty;
  }

  /// دریافت کاربر فعلی
  Future<User?> getCurrentUser() async {
    final userData = await _secureStorage.read('user_data');
    if (userData == null) return null;

    try {
      final userJson = json.decode(userData) as Map<String, dynamic>;
      return User.fromJson(userJson);
    } catch (e) {
      return null;
    }
  }

  /// تمدید توکن
  Future<void> refreshToken() async {
    try {
      final response = await _apiClient.post(ApiEndpoints.refreshToken);
      final newToken = response['token'] as String;

      await _secureStorage.write('auth_token', newToken);
      _apiClient.setAuthToken(newToken);
    } catch (e) {
      throw AuthException('خطا در تمدید توکن: ${e.toString()}');
    }
  }
}

/// نتیجه احراز هویت
class AuthResult {
  final String token;
  final User user;

  AuthResult({
    required this.token,
    required this.user,
  });

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    return AuthResult(
      token: json['token'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
```

## 📋 Export Files الزامی

### Core Main Export

```dart
// core.dart
export 'network/network.dart';
export 'database/database.dart';
export 'storage/storage.dart';
export 'services/services.dart';
export 'errors/errors.dart';
export 'localization/localization.dart';
```

### Services Export

```dart
// services/services.dart
export 'auth_service.dart';
export 'notification_service.dart';
export 'analytics_service.dart';
export 'logging_service.dart';
export 'sms_service.dart';
```

## 🔍 Validation Rules

### قبل از ایجاد هر Service:

1. ✅ تعیین مسئولیت واضح
2. ✅ طراحی interface مناسب
3. ✅ پیاده‌سازی error handling
4. ✅ اضافه کردن logging
5. ✅ نوشتن tests
6. ✅ documentation کامل

### Service باید:

- ✅ Single responsibility داشته باشد
- ✅ Testable باشد
- ✅ Error handling کامل داشته باشد
- ✅ Thread-safe باشد
- ✅ Performance optimized باشد

## 🎯 نکات مهم

1. **همه services باید singleton یا dependency injection استفاده کنند**
2. **Error handling جامع الزامی است**
3. **Logging برای debug کردن ضروری است**
4. **Network calls باید timeout داشته باشند**
5. **Local caching را در نظر بگیرید**
6. **Security اولویت اول است**
