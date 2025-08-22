// lib_new/shared/models/provider_configs.dart
// تنظیمات پروایدرهای SMS - Clean Architecture

/// کلاس پایه برای تنظیمات پروایدرها
abstract class ProviderConfig {
  final bool isActive;

  const ProviderConfig({required this.isActive});
}

/// تنظیمات SMS0098
class Sms0098Config extends ProviderConfig {
  final String username;
  final String password;
  final String sender;
  final String baseUrl;

  const Sms0098Config({
    required this.username,
    required this.password,
    required this.sender,
    this.baseUrl = 'https://ippanel.com/api/select',
    super.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'sender': sender,
      'base_url': baseUrl,
      'is_active': isActive,
    };
  }

  factory Sms0098Config.fromMap(Map<String, dynamic> map) {
    return Sms0098Config(
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      sender: map['sender'] ?? '',
      baseUrl: map['base_url'] ?? 'https://ippanel.com/api/select',
      isActive: map['is_active'] ?? true,
    );
  }
}

/// تنظیمات قاصدک
class GhasedakConfig extends ProviderConfig {
  final String apiKey;
  final String lineNumber;
  final String baseUrl;

  const GhasedakConfig({
    required this.apiKey,
    required this.lineNumber,
    this.baseUrl = 'https://api.ghasedak.me/v2/sms/send/simple',
    super.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'api_key': apiKey,
      'line_number': lineNumber,
      'base_url': baseUrl,
      'is_active': isActive,
    };
  }

  factory GhasedakConfig.fromMap(Map<String, dynamic> map) {
    return GhasedakConfig(
      apiKey: map['api_key'] ?? '',
      lineNumber: map['line_number'] ?? '',
      baseUrl: map['base_url'] ?? 'https://api.ghasedak.me/v2/sms/send/simple',
      isActive: map['is_active'] ?? true,
    );
  }
}

/// تنظیمات کاوه‌نگار
class KavenegarConfig extends ProviderConfig {
  final String apiKey;
  final String sender;
  final String baseUrl;

  const KavenegarConfig({
    required this.apiKey,
    required this.sender,
    this.baseUrl = 'https://api.kavenegar.com/v1',
    super.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'api_key': apiKey,
      'sender': sender,
      'base_url': baseUrl,
      'is_active': isActive,
    };
  }

  factory KavenegarConfig.fromMap(Map<String, dynamic> map) {
    return KavenegarConfig(
      apiKey: map['api_key'] ?? '',
      sender: map['sender'] ?? '',
      baseUrl: map['base_url'] ?? 'https://api.kavenegar.com/v1',
      isActive: map['is_active'] ?? true,
    );
  }
}

/// تنظیمات جامع SMS با پشتیبانی همه پروایدرها
class CompleteSmsConfig {
  final Sms0098Config? sms0098Config;
  final GhasedakConfig? ghasedakConfig;
  final KavenegarConfig? kavenegarConfig;
  final int defaultProviderId;
  final int retryAttempts;
  final int timeoutSeconds;

  const CompleteSmsConfig({
    this.sms0098Config,
    this.ghasedakConfig,
    this.kavenegarConfig,
    this.defaultProviderId = 2, // قاصدک به عنوان پیش‌فرض
    this.retryAttempts = 3,
    this.timeoutSeconds = 30,
  });

  /// بررسی اینکه آیا حداقل یک پروایدر فعال است
  bool get hasActiveProvider {
    return (sms0098Config?.isActive ?? false) ||
        (ghasedakConfig?.isActive ?? false) ||
        (kavenegarConfig?.isActive ?? false);
  }

  /// لیست پروایدرهای فعال
  List<int> get activeProviderIds {
    final activeIds = <int>[];
    if (sms0098Config?.isActive ?? false) activeIds.add(1);
    if (ghasedakConfig?.isActive ?? false) activeIds.add(2);
    if (kavenegarConfig?.isActive ?? false) activeIds.add(3);
    return activeIds;
  }

  Map<String, dynamic> toMap() {
    return {
      'sms0098_config': sms0098Config?.toMap(),
      'ghasedak_config': ghasedakConfig?.toMap(),
      'kavenegar_config': kavenegarConfig?.toMap(),
      'default_provider_id': defaultProviderId,
      'retry_attempts': retryAttempts,
      'timeout_seconds': timeoutSeconds,
    };
  }

  factory CompleteSmsConfig.fromMap(Map<String, dynamic> map) {
    return CompleteSmsConfig(
      sms0098Config: map['sms0098_config'] != null
          ? Sms0098Config.fromMap(map['sms0098_config'])
          : null,
      ghasedakConfig: map['ghasedak_config'] != null
          ? GhasedakConfig.fromMap(map['ghasedak_config'])
          : null,
      kavenegarConfig: map['kavenegar_config'] != null
          ? KavenegarConfig.fromMap(map['kavenegar_config'])
          : null,
      defaultProviderId: map['default_provider_id'] ?? 2,
      retryAttempts: map['retry_attempts'] ?? 3,
      timeoutSeconds: map['timeout_seconds'] ?? 30,
    );
  }

  @override
  String toString() {
    return 'CompleteSmsConfig{defaultProvider: $defaultProviderId, hasActive: $hasActiveProvider}';
  }
}
