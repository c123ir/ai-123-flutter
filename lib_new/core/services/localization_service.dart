// lib_new/core/services/localization_service.dart
// سرویس چندزبانگی

import 'package:flutter/material.dart';

/// سرویس چندزبانگی
class LocalizationService {
  static bool _initialized = false;

  /// مقداردهی اولیه
  static Future<void> initialize() async {
    if (_initialized) return;

    // TODO: پیاده‌سازی localization
    await Future.delayed(const Duration(milliseconds: 100));

    _initialized = true;
  }

  /// زبان‌های پشتیبانی شده
  static List<Locale> get supportedLocales => [
    const Locale('fa', 'IR'), // فارسی
    const Locale('en', 'US'), // انگلیسی
  ];

  /// Localization delegates
  static List<LocalizationsDelegate<dynamic>> get localizationsDelegates => [
    // TODO: اضافه کردن delegates
  ];

  /// بررسی وضعیت مقداردهی
  static bool get isInitialized => _initialized;
}

/// Provider برای مدیریت زبان
class LocalizationProvider extends ChangeNotifier {
  Locale _locale = const Locale('fa', 'IR');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
