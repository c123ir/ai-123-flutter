class CrmContact {
  final int? id;
  final String name;
  final String? email;
  final String? phone;
  final String? company;
  final String status;
  final String? notes;
  final int? assignedTo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CrmContact({
    this.id,
    required this.name,
    this.email,
    this.phone,
    this.company,
    this.status = 'lead',
    this.notes,
    this.assignedTo,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'company': company,
      'status': status,
      'notes': notes,
      'assigned_to': assignedTo,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory CrmContact.fromJson(Map<String, dynamic> json) {
    return CrmContact(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      company: json['company'],
      status: json['status'] ?? 'lead',
      notes: json['notes'],
      assignedTo: json['assigned_to'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}
