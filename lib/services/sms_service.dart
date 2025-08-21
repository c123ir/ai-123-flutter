// lib/services/sms_service.dart
// سرویس مدیریت پیامک - ارسال و دریافت پیامک از طریق سامانه‌های مختلف

import 'package:http/http.dart' as http;
import '../database/database_helper.dart';
import '../models/sms_provider.dart';
import '../models/sms_config.dart';
import '../models/sms_log.dart';

class SmsService {
  final DatabaseHelper _db = DatabaseHelper.instance;

  // لیست تمام سامانه‌های پیامکی فعال
  Future<List<SmsProvider>> getActiveProviders() async {
    final data = await _db.queryAll('sms_providers');
    return data
        .where((row) => row['is_active'] == 1)
        .map((row) => SmsProvider.fromMap(row))
        .toList()
      ..sort((a, b) => b.priority.compareTo(a.priority));
  }

  // دریافت تنظیمات یک سامانه پیامکی
  Future<Map<String, String>> getProviderConfigs(int providerId) async {
    final db = await _db.database;
    final result = await db.query(
      'sms_configs',
      where: 'provider_id = ?',
      whereArgs: [providerId],
    );

    final configs = <String, String>{};
    for (final row in result) {
      final config = SmsConfig.fromMap(row);
      configs[config.configKey] = config.configValue;
    }
    return configs;
  }

  // ارسال پیامک تکی
  Future<SmsLog> sendSms({
    required String phone,
    required String message,
    int? specificProviderId,
  }) async {
    // انتخاب سامانه ارسال
    SmsProvider? provider;
    if (specificProviderId != null) {
      final data = await _db.queryById('sms_providers', specificProviderId);
      if (data != null) {
        provider = SmsProvider.fromMap(data);
      }
    } else {
      final providers = await getActiveProviders();
      provider = providers.isNotEmpty ? providers.first : null;
    }

    if (provider == null) {
      throw Exception('هیچ سامانه پیامکی فعال یافت نشد');
    }

    // ایجاد لاگ پیامک
    final logId = await _db.insert('sms_logs', {
      'provider_id': provider.id,
      'recipient_phone': phone,
      'message_text': message,
      'status': 'pending',
    });

    try {
      // ارسال پیامک بر اساس نوع سامانه
      String responseCode = '';
      String responseMessage = '';

      switch (provider.providerType) {
        case '0098sms':
          final result = await _send0098Sms(provider.id!, phone, message);
          responseCode = result['code'] ?? '';
          responseMessage = result['message'] ?? '';
          break;
        default:
          throw Exception(
            'نوع سامانه پشتیبانی نمی‌شود: ${provider.providerType}',
          );
      }

      // بروزرسانی وضعیت لاگ
      final status = responseCode == '1' ? 'sent' : 'failed';
      await _db.update('sms_logs', {
        'status': status,
        'response_code': responseCode,
        'response_message': responseMessage,
        'sent_at': DateTime.now().toIso8601String(),
      }, logId);

      // بازگردانی لاگ به‌روزرسانی شده
      final updatedLogData = await _db.queryById('sms_logs', logId);
      return SmsLog.fromMap(updatedLogData!);
    } catch (e) {
      // ثبت خطا در لاگ
      await _db.update('sms_logs', {
        'status': 'failed',
        'response_message': e.toString(),
      }, logId);

      final failedLogData = await _db.queryById('sms_logs', logId);
      return SmsLog.fromMap(failedLogData!);
    }
  }

  // ارسال پیامک انبوه
  Future<List<SmsLog>> sendBulkSms({
    required List<String> phones,
    required String message,
    int? specificProviderId,
  }) async {
    final results = <SmsLog>[];

    for (final phone in phones) {
      try {
        final result = await sendSms(
          phone: phone,
          message: message,
          specificProviderId: specificProviderId,
        );
        results.add(result);
      } catch (e) {
        // در صورت خطا، لاگ شکست ایجاد می‌کنیم
        final logId = await _db.insert('sms_logs', {
          'provider_id': specificProviderId ?? 1,
          'recipient_phone': phone,
          'message_text': message,
          'status': 'failed',
          'response_message': e.toString(),
        });

        final failedLogData = await _db.queryById('sms_logs', logId);
        results.add(SmsLog.fromMap(failedLogData!));
      }
    }

    return results;
  }

  // ارسال پیامک از طریق سامانه ۰۰۹۸
  Future<Map<String, String>> _send0098Sms(
    int providerId,
    String phone,
    String message,
  ) async {
    final configs = await getProviderConfigs(providerId);

    final username = configs['username'];
    final password = configs['password'];
    final from = configs['from'];
    final apiUrl = configs['api_url'];

    if (username == null ||
        password == null ||
        from == null ||
        apiUrl == null) {
      throw Exception('تنظیمات سامانه ۰۰۹۸ ناقص است');
    }

    // پاکسازی شماره تلفن
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');

    // ساخت URL درخواست
    final url = Uri.parse(apiUrl).replace(
      queryParameters: {
        'username': username,
        'password': password,
        'from': from,
        'to': cleanPhone,
        'text': message,
      },
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseBody = response.body.trim();

        // تحلیل پاسخ سامانه ۰۰۹۸
        if (responseBody.startsWith('1|')) {
          return {
            'code': '1',
            'message': 'پیامک با موفقیت ارسال شد',
            'reference': responseBody.split('|').length > 1
                ? responseBody.split('|')[1]
                : '',
          };
        } else {
          return {
            'code': responseBody.split('|')[0],
            'message': _get0098ErrorMessage(responseBody),
          };
        }
      } else {
        throw Exception('خطا در ارتباط با سرور: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('خطا در ارسال پیامک: $e');
    }
  }

  // ترجمه کدهای خطای سامانه ۰۰۹۸
  String _get0098ErrorMessage(String responseCode) {
    final errorMap = {
      '2': 'نام کاربری یا رمز عبور اشتباه است',
      '3': 'اعتبار حساب کافی نیست',
      '4': 'شماره فرستنده معتبر نیست',
      '5': 'شماره گیرنده معتبر نیست',
      '6': 'متن پیامک خالی است',
      '7': 'متن پیامک بیش از حد طولانی است',
      '8': 'شماره گیرنده در لیست سیاه قرار دارد',
      '9': 'خطای داخلی سرور',
      '10': 'درخواست نامعتبر است',
    };

    final code = responseCode.split('|')[0];
    return errorMap[code] ?? 'خطای نامشخص: $responseCode';
  }

  // دریافت تاریخچه پیامک‌ها
  Future<List<SmsLog>> getSmsHistory({
    int? providerId,
    String? status,
    DateTime? fromDate,
    DateTime? toDate,
    int limit = 100,
  }) async {
    final db = await _db.database;

    String whereClause = '1=1';
    List<dynamic> whereArgs = [];

    if (providerId != null) {
      whereClause += ' AND provider_id = ?';
      whereArgs.add(providerId);
    }

    if (status != null) {
      whereClause += ' AND status = ?';
      whereArgs.add(status);
    }

    if (fromDate != null) {
      whereClause += ' AND created_at >= ?';
      whereArgs.add(fromDate.toIso8601String());
    }

    if (toDate != null) {
      whereClause += ' AND created_at <= ?';
      whereArgs.add(toDate.toIso8601String());
    }

    final result = await db.query(
      'sms_logs',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'created_at DESC',
      limit: limit,
    );

    return result.map((row) => SmsLog.fromMap(row)).toList();
  }

  // آمار پیامک‌ها
  Future<Map<String, int>> getSmsStats() async {
    final db = await _db.database;

    final total = await db.rawQuery('SELECT COUNT(*) as count FROM sms_logs');
    final sent = await db.rawQuery(
      'SELECT COUNT(*) as count FROM sms_logs WHERE status = "sent"',
    );
    final failed = await db.rawQuery(
      'SELECT COUNT(*) as count FROM sms_logs WHERE status = "failed"',
    );
    final pending = await db.rawQuery(
      'SELECT COUNT(*) as count FROM sms_logs WHERE status = "pending"',
    );

    return {
      'total': total[0]['count'] as int,
      'sent': sent[0]['count'] as int,
      'failed': failed[0]['count'] as int,
      'pending': pending[0]['count'] as int,
    };
  }

  // تست اتصال سامانه پیامکی
  Future<bool> testProvider(int providerId) async {
    try {
      // ارسال پیامک تست به شماره مدیر
      await sendSms(
        phone: '09123456789', // شماره تست
        message: 'تست اتصال سامانه پیامکی - ${DateTime.now()}',
        specificProviderId: providerId,
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
