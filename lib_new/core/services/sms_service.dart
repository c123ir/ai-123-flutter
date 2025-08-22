// lib_new/core/services/sms_service.dart
// سرویس جامع ارسال پیامک با پشتیبانی چندین سامانه

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../errors/app_exception.dart';
import '../../shared/models/sms_log.dart';
import '../../shared/models/provider_configs.dart';
import '../../shared/utils/persian_number_utils.dart';

/// وضعیت‌های پیامک
enum SmsStatus {
  pending('در انتظار'),
  sent('ارسال شده'),
  delivered('تحویل داده شده'),
  failed('ناموفق');

  const SmsStatus(this.persianTitle);
  final String persianTitle;
}

/// انواع پروایدر SMS
enum SmsProviderType {
  sms0098('SMS0098'),
  ghasedakSms('قاصدک'),
  kavenegar('کاوه‌نگار');

  const SmsProviderType(this.persianName);
  final String persianName;
}

/// سرویس اصلی SMS با معماری Clean Architecture
class SmsService {
  static SmsService? _instance;
  SmsService._internal();

  /// Singleton pattern برای دسترسی یکتا
  static SmsService get instance {
    _instance ??= SmsService._internal();
    return _instance!;
  }

  final List<SmsLog> _logs = [];
  CompleteSmsConfig? _config;

  /// تنظیم پیکربندی SMS
  void configure(CompleteSmsConfig config) {
    _config = config;
  }

  /// دریافت تنظیمات
  CompleteSmsConfig? get config => _config;

  /// دریافت لاگ‌ها
  List<SmsLog> get logs => List.unmodifiable(_logs);

  /// ارسال پیامک
  Future<SmsLog> sendSms({
    required String phoneNumber,
    required String message,
    SmsProviderType? preferredProvider,
  }) async {
    if (_config == null) {
      throw const SmsException('سرویس SMS تنظیم نشده است');
    }

    if (!_config!.hasActiveProvider) {
      throw const SmsException('هیچ پروایدر فعالی موجود نیست');
    }

    // اعتبارسنجی شماره تلفن
    if (!PersianNumberUtils.isValidIranianMobile(phoneNumber)) {
      throw const ValidationException('شماره موبایل وارد شده معتبر نیست');
    }

    // نرمال‌سازی شماره
    final normalizedPhone = PersianNumberUtils.convertToEnglish(phoneNumber);

    // تعیین ID پروایدر
    final providerId = _getProviderId(
      preferredProvider ?? _selectBestProvider(),
    );

    final log = SmsLog(
      providerId: providerId,
      recipientPhone: normalizedPhone,
      messageText: message,
      status: SmsStatus.pending.name,
      sentAt: DateTime.now(),
      createdAt: DateTime.now(),
    );

    try {
      // ارسال پیامک
      final success = await _sendViaProvider(
        log,
        preferredProvider ?? _selectBestProvider(),
      );

      final updatedLog = log.copyWith(
        status: success ? SmsStatus.sent.name : SmsStatus.failed.name,
        deliveredAt: success ? DateTime.now() : null,
        responseMessage: success ? 'ارسال موفق' : 'ارسال ناموفق',
      );

      _logs.add(updatedLog);
      return updatedLog;
    } catch (e) {
      final failedLog = log.copyWith(
        status: SmsStatus.failed.name,
        responseMessage: e.toString(),
      );
      _logs.add(failedLog);
      rethrow;
    }
  }

  /// ارسال پیامک انبوه
  Future<List<SmsLog>> sendBulkSms({
    required List<String> phoneNumbers,
    required String message,
    SmsProviderType? preferredProvider,
  }) async {
    final results = <SmsLog>[];

    for (final phone in phoneNumbers) {
      try {
        final log = await sendSms(
          phoneNumber: phone,
          message: message,
          preferredProvider: preferredProvider,
        );
        results.add(log);
      } catch (e) {
        // ادامه ارسال در صورت خطا در یک شماره
        print('خطا در ارسال به $phone: $e');
      }
    }

    return results;
  }

  /// انتخاب بهترین پروایدر
  SmsProviderType _selectBestProvider() {
    final activeIds = _config?.activeProviderIds ?? [];

    // انتخاب پیش‌فرض بر اساس پروایدر فعال
    if (activeIds.contains(2)) return SmsProviderType.ghasedakSms;
    if (activeIds.contains(1)) return SmsProviderType.sms0098;
    if (activeIds.contains(3)) return SmsProviderType.kavenegar;

    // در صورت عدم وجود پروایدر فعال
    return SmsProviderType.ghasedakSms;
  }

  /// تعیین ID پروایدر
  int _getProviderId(SmsProviderType providerType) {
    switch (providerType) {
      case SmsProviderType.sms0098:
        return 1;
      case SmsProviderType.ghasedakSms:
        return 2;
      case SmsProviderType.kavenegar:
        return 3;
    }
  }

  /// ارسال از طریق پروایدر مشخص
  Future<bool> _sendViaProvider(
    SmsLog log,
    SmsProviderType providerType,
  ) async {
    switch (providerType) {
      case SmsProviderType.sms0098:
        return await _sendViaSms0098(log);
      case SmsProviderType.ghasedakSms:
        return await _sendViaGhasedak(log);
      case SmsProviderType.kavenegar:
        return await _sendViaKavenegar(log);
    }
  }

  /// ارسال از طریق SMS0098
  Future<bool> _sendViaSms0098(SmsLog log) async {
    if (_config?.sms0098Config == null) {
      throw const SmsException('تنظیمات SMS0098 موجود نیست');
    }

    final config = _config!.sms0098Config!;

    try {
      final response = await http
          .post(
            Uri.parse(config.baseUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'op': 'send',
              'uname': config.username,
              'pass': config.password,
              'message': log.messageText,
              'to': [log.recipientPhone],
              'from': config.sender,
            }),
          )
          .timeout(Duration(seconds: _config?.timeoutSeconds ?? 30));

      final responseData = jsonDecode(response.body);
      return response.statusCode == 200 && responseData['status'] == 'OK';
    } catch (e) {
      throw SmsException('خطا در ارسال SMS0098: $e');
    }
  }

  /// ارسال از طریق قاصدک
  Future<bool> _sendViaGhasedak(SmsLog log) async {
    if (_config?.ghasedakConfig == null) {
      throw const SmsException('تنظیمات قاصدک موجود نیست');
    }

    final config = _config!.ghasedakConfig!;

    try {
      final response = await http
          .post(
            Uri.parse(config.baseUrl),
            headers: {
              'Content-Type': 'application/json',
              'apikey': config.apiKey,
            },
            body: jsonEncode({
              'message': log.messageText,
              'receptor': log.recipientPhone,
              'linenumber': config.lineNumber,
            }),
          )
          .timeout(Duration(seconds: _config?.timeoutSeconds ?? 30));

      final responseData = jsonDecode(response.body);
      return response.statusCode == 200 &&
          responseData['result']['code'] == 200;
    } catch (e) {
      throw SmsException('خطا در ارسال قاصدک: $e');
    }
  }

  /// ارسال از طریق کاوه‌نگار
  Future<bool> _sendViaKavenegar(SmsLog log) async {
    if (_config?.kavenegarConfig == null) {
      throw const SmsException('تنظیمات کاوه‌نگار موجود نیست');
    }

    final config = _config!.kavenegarConfig!;

    try {
      final response = await http
          .get(
            Uri.parse(
              '${config.baseUrl}/${config.apiKey}/sms/send.json'
              '?receptor=${log.recipientPhone}'
              '&message=${Uri.encodeComponent(log.messageText)}'
              '&sender=${config.sender}',
            ),
          )
          .timeout(Duration(seconds: _config?.timeoutSeconds ?? 30));

      final responseData = jsonDecode(response.body);
      return response.statusCode == 200 &&
          responseData['return']['status'] == 200;
    } catch (e) {
      throw SmsException('خطا در ارسال کاوه‌نگار: $e');
    }
  }

  /// بررسی وضعیت تحویل پیامک
  Future<String> checkDeliveryStatus(String smsId) async {
    final log = _logs.firstWhere(
      (log) => log.id.toString() == smsId,
      orElse: () => throw const SmsException('پیامک یافت نشد'),
    );

    // در پیاده‌سازی واقعی، از API پروایدر استفاده کنید
    return log.status;
  }

  /// دریافت آمار ارسال
  Map<String, dynamic> getStatistics() {
    final total = _logs.length;
    final sent = _logs.where((log) => log.status == SmsStatus.sent.name).length;
    final failed = _logs
        .where((log) => log.status == SmsStatus.failed.name)
        .length;
    final pending = _logs
        .where((log) => log.status == SmsStatus.pending.name)
        .length;

    return {
      'total': total,
      'sent': sent,
      'failed': failed,
      'pending': pending,
      'success_rate': total > 0
          ? (sent / total * 100).toStringAsFixed(2)
          : '0.00',
    };
  }

  /// پاک کردن لاگ‌ها
  void clearLogs() {
    _logs.clear();
  }

  /// فیلتر لاگ‌ها
  List<SmsLog> filterLogs({
    String? status,
    int? providerId,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    return _logs.where((log) {
      if (status != null && log.status != status) return false;
      if (providerId != null && log.providerId != providerId) return false;
      if (fromDate != null &&
          log.sentAt != null &&
          log.sentAt!.isBefore(fromDate))
        return false;
      if (toDate != null && log.sentAt != null && log.sentAt!.isAfter(toDate))
        return false;
      return true;
    }).toList();
  }

  /// تست اتصال پروایدرها
  Future<Map<SmsProviderType, bool>> testProviders() async {
    final results = <SmsProviderType, bool>{};

    for (final provider in SmsProviderType.values) {
      try {
        // شبیه‌سازی تست بدون ارسال واقعی
        await Future.delayed(const Duration(milliseconds: 500));
        results[provider] = _isProviderConfigured(provider);
      } catch (e) {
        results[provider] = false;
      }
    }

    return results;
  }

  /// بررسی تنظیم شدن پروایدر
  bool _isProviderConfigured(SmsProviderType provider) {
    switch (provider) {
      case SmsProviderType.sms0098:
        return _config?.sms0098Config != null;
      case SmsProviderType.ghasedakSms:
        return _config?.ghasedakConfig != null;
      case SmsProviderType.kavenegar:
        return _config?.kavenegarConfig != null;
    }
  }
}
