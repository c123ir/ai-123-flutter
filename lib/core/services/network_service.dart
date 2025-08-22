// lib_new/core/services/network_service.dart
// سرویس شبکه

/// سرویس مدیریت شبکه
class NetworkService {
  static bool _initialized = false;

  /// مقداردهی اولیه
  static void initialize() {
    if (_initialized) return;

    // TODO: پیاده‌سازی تنظیمات شبکه

    _initialized = true;
  }

  /// بررسی وضعیت اتصال
  static bool get isInitialized => _initialized;
}
