// lib_new/shared/models/sms_config.dart
// مدل تنظیمات سامانه پیامکی - Clean Architecture

/// مدل تنظیمات سامانه پیامکی
class SmsConfig {
  final int? id;
  final int providerId;
  final String configKey;
  final String configValue;
  final bool isEncrypted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SmsConfig({
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

  SmsConfig copyWith({
    int? id,
    int? providerId,
    String? configKey,
    String? configValue,
    bool? isEncrypted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SmsConfig(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      configKey: configKey ?? this.configKey,
      configValue: configValue ?? this.configValue,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SmsConfig &&
        other.id == id &&
        other.providerId == providerId &&
        other.configKey == configKey;
  }

  @override
  int get hashCode {
    return id.hashCode ^ providerId.hashCode ^ configKey.hashCode;
  }

  @override
  String toString() {
    return 'SmsConfig{id: $id, providerId: $providerId, key: $configKey}';
  }
}
