// lib_new/core/services/database_service.dart
// سرویس پایگاه داده

/// سرویس پایگاه داده
class DatabaseService {
  static bool _initialized = false;

  /// مقداردهی اولیه
  static Future<void> initialize() async {
    if (_initialized) return;

    // TODO: پیاده‌سازی اتصال به MySQL
    await Future.delayed(const Duration(milliseconds: 100));

    _initialized = true;
  }

  /// بررسی وضعیت اتصال
  static bool get isInitialized => _initialized;
}
