// lib_new/core/services/storage_service.dart
// سرویس ذخیره‌سازی محلی

/// سرویس ذخیره‌سازی محلی
class StorageService {
  static bool _initialized = false;

  /// مقداردهی اولیه
  static Future<void> initialize() async {
    if (_initialized) return;

    // TODO: پیاده‌سازی SharedPreferences
    await Future.delayed(const Duration(milliseconds: 100));

    _initialized = true;
  }

  /// بررسی وضعیت مقداردهی
  static bool get isInitialized => _initialized;
}
