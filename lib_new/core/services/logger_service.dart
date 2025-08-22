// lib_new/core/services/logger_service.dart
// سرویس لاگ‌گذاری

import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// سرویس لاگ‌گذاری اپلیکیشن
class LoggerService {
  static const String _tag = 'AI123';

  /// لاگ اطلاعات
  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log('[اطلاعات] $message', name: tag ?? _tag, level: 800);
    }
  }

  /// لاگ هشدار
  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log('[هشدار] $message', name: tag ?? _tag, level: 900);
    }
  }

  /// لاگ خطا
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      developer.log(
        '[خطا] $message',
        name: tag ?? _tag,
        level: 1000,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// لاگ موفقیت
  static void success(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log('[موفقیت] $message', name: tag ?? _tag, level: 800);
    }
  }

  /// لاگ عملکرد
  static void performance(String operation, Duration duration, {String? tag}) {
    if (kDebugMode) {
      developer.log(
        '[عملکرد] $operation took ${duration.inMilliseconds}ms',
        name: tag ?? _tag,
        level: 700,
      );
    }
  }
}
