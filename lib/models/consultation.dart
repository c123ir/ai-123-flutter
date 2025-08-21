class Consultation {
  final int? id;
  final int userId;
  final int? productId;
  final String message;
  final String? aiResponse;
  final String status;
  final DateTime? createdAt;

  Consultation({
    this.id,
    required this.userId,
    this.productId,
    required this.message,
    this.aiResponse,
    this.status = 'pending',
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'message': message,
      'ai_response': aiResponse,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory Consultation.fromJson(Map<String, dynamic> json) {
    return Consultation(
      id: json['id'],
      userId: json['user_id'],
      productId: json['product_id'],
      message: json['message'],
      aiResponse: json['ai_response'],
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }
}
