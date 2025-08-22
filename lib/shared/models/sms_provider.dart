// lib_new/shared/models/sms_provider.dart
// مدل سامانه پیامکی - Clean Architecture

/// مدل سامانه پیامکی
class SmsProvider {
  final int? id;
  final String name;
  final String providerType;
  final String? description;
  final bool isActive;
  final int priority;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SmsProvider({
    this.id,
    required this.name,
    required this.providerType,
    this.description,
    this.isActive = true,
    this.priority = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory SmsProvider.fromMap(Map<String, dynamic> map) {
    return SmsProvider(
      id: map['id']?.toInt(),
      name: map['name'] ?? '',
      providerType: map['provider_type'] ?? '',
      description: map['description'],
      isActive: (map['is_active'] ?? 1) == 1,
      priority: map['priority']?.toInt() ?? 0,
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
      'name': name,
      'provider_type': providerType,
      'description': description,
      'is_active': isActive ? 1 : 0,
      'priority': priority,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  SmsProvider copyWith({
    int? id,
    String? name,
    String? providerType,
    String? description,
    bool? isActive,
    int? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SmsProvider(
      id: id ?? this.id,
      name: name ?? this.name,
      providerType: providerType ?? this.providerType,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SmsProvider &&
        other.id == id &&
        other.name == name &&
        other.providerType == providerType;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ providerType.hashCode;
  }

  @override
  String toString() {
    return 'SmsProvider{id: $id, name: $name, providerType: $providerType, isActive: $isActive}';
  }
}
