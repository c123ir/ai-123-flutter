// lib_new/app/app_config.dart
// تنظیمات و پیکربندی اصلی اپلیکیشن

/// محیط‌های مختلف اپلیکیشن
enum Environment { development, staging, production }

/// کلاس مدیریت تنظیمات اپلیکیشن
class AppConfig {
  static Environment _environment = Environment.development;

  static Environment get environment => _environment;

  static void setEnvironment(Environment env) {
    _environment = env;
  }

  // API Configuration
  static String get baseUrl {
    switch (_environment) {
      case Environment.development:
        return 'http://localhost:3000';
      case Environment.staging:
        return 'https://staging-api.ai123.com';
      case Environment.production:
        return 'https://api.ai123.com';
    }
  }

  // Database Configuration
  static String get databaseUrl {
    switch (_environment) {
      case Environment.development:
        return 'mysql://localhost:3306/ai_123_dev';
      case Environment.staging:
        return 'mysql://staging-db.ai123.com:3306/ai_123_staging';
      case Environment.production:
        return 'mysql://prod-db.ai123.com:3306/ai_123_prod';
    }
  }

  // SMS Configuration
  static Map<String, String> get smsConfig {
    switch (_environment) {
      case Environment.development:
        return {'provider': 'mock', 'apiKey': 'dev-key'};
      case Environment.staging:
        return {
          'provider': '0098sms',
          'apiKey': const String.fromEnvironment('SMS_API_KEY_STAGING'),
        };
      case Environment.production:
        return {
          'provider': '0098sms',
          'apiKey': const String.fromEnvironment('SMS_API_KEY_PROD'),
        };
    }
  }

  // Debug Configuration
  static bool get debugMode => _environment == Environment.development;
  static bool get enableLogging => _environment != Environment.production;
  static bool get enablePerformanceOverlay =>
      _environment == Environment.development;

  // App Information
  static const String appName = 'دستیار هوشمند یک دو سه';
  static const String version = '1.2.0';
  static const String buildNumber = '1';

  // UI Configuration
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1440.0;
}
