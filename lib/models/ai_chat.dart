class AiChat {
  final int? id;
  final int userId;
  final String message;
  final String? response;
  final String chatType;
  final DateTime? createdAt;

  AiChat({
    this.id,
    required this.userId,
    required this.message,
    this.response,
    this.chatType = 'general',
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'message': message,
      'response': response,
      'chat_type': chatType,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory AiChat.fromJson(Map<String, dynamic> json) {
    return AiChat(
      id: json['id'],
      userId: json['user_id'],
      message: json['message'],
      response: json['response'],
      chatType: json['chat_type'] ?? 'general',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }
}
