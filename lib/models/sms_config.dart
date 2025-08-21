// lib/models/sms_config.dart
// مدل تنظیمات سامانه پیامکی - مدیریت پیکربندی‌های مختلف

class SmsConfig {
  final int? id;
  final int providerId;
  final String configKey;
  final String configValue;
  final bool isEncrypted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SmsConfig({
    this.id,
    required this.providerId,
    required this.configKey,
    required this.configValue,
    this.isEncrypted = false,
    this.createdAt,
    this.updatedAt,
  });

  factory SmsConfig.fromMap(Map<String, dynamic> map) {
    return SmsConfig(
      id: map['id']?.toInt(),
      providerId: map['provider_id']?.toInt() ?? 0,
      configKey: map['config_key'] ?? '',
      configValue: map['config_value'] ?? '',
      isEncrypted: (map['is_encrypted'] ?? 0) == 1,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'provider_id': providerId,
      'config_key': configKey,
      'config_value': configValue,
      'is_encrypted': isEncrypted ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'SmsConfig{id: $id, providerId: $providerId, configKey: $configKey, isEncrypted: $isEncrypted}';
  }
}
