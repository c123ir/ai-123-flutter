// lib/models/sms_log.dart
// مدل لاگ پیامک - ثبت تاریخچه ارسال و دریافت پیامک‌ها

class SmsLog {
  final int? id;
  final int providerId;
  final String recipientPhone;
  final String messageText;
  final String status;
  final String? responseCode;
  final String? responseMessage;
  final DateTime? sentAt;
  final DateTime? deliveredAt;
  final DateTime? createdAt;

  SmsLog({
    this.id,
    required this.providerId,
    required this.recipientPhone,
    required this.messageText,
    this.status = 'pending',
    this.responseCode,
    this.responseMessage,
    this.sentAt,
    this.deliveredAt,
    this.createdAt,
  });

  factory SmsLog.fromMap(Map<String, dynamic> map) {
    return SmsLog(
      id: map['id']?.toInt(),
      providerId: map['provider_id']?.toInt() ?? 0,
      recipientPhone: map['recipient_phone'] ?? '',
      messageText: map['message_text'] ?? '',
      status: map['status'] ?? 'pending',
      responseCode: map['response_code'],
      responseMessage: map['response_message'],
      sentAt: map['sent_at'] != null ? DateTime.tryParse(map['sent_at']) : null,
      deliveredAt: map['delivered_at'] != null
          ? DateTime.tryParse(map['delivered_at'])
          : null,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'provider_id': providerId,
      'recipient_phone': recipientPhone,
      'message_text': messageText,
      'status': status,
      'response_code': responseCode,
      'response_message': responseMessage,
      'sent_at': sentAt?.toIso8601String(),
      'delivered_at': deliveredAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // متدهای کمکی برای وضعیت
  bool get isPending => status == 'pending';
  bool get isSent => status == 'sent';
  bool get isDelivered => status == 'delivered';
  bool get isFailed => status == 'failed';

  String get statusPersian {
    switch (status) {
      case 'pending':
        return 'در انتظار';
      case 'sent':
        return 'ارسال شده';
      case 'delivered':
        return 'تحویل داده شده';
      case 'failed':
        return 'ناموفق';
      default:
        return 'نامشخص';
    }
  }

  @override
  String toString() {
    return 'SmsLog{id: $id, recipientPhone: $recipientPhone, status: $status}';
  }
}
