// lib/services/sms_service.dart
// سرویس مدیریت پیامک - ارسال و دریافت پیامک از طریق سامانه‌های مختلف

import 'package:http/http.dart' as http;
import '../database/database_manager.dart';
import '../models/sms_provider.dart';
import '../models/sms_config.dart';
import '../models/sms_log.dart';
import '../utils/persian_number_utils.dart';

class SmsService {
  // Singleton pattern
  static SmsService? _instance;
  static SmsService get instance {
    _instance ??= SmsService._internal();
    return _instance!;
  }

  // Private constructor
  SmsService._internal();

  // لیست تمام سامانه‌های پیامکی فعال
  Future<List<SmsProvider>> getActiveProviders() async {
    final adapter = await DatabaseManager.getAdapter();
    final data = await adapter.query('sms_providers');
    return data
        .where((row) => row['is_active'] == 1)
        .map((row) => SmsProvider.fromMap(row))
        .toList()
      ..sort((a, b) => b.priority.compareTo(a.priority));
  }

  // دریافت تنظیمات یک سامانه پیامکی
  Future<Map<String, String>> getProviderConfigs(int providerId) async {
    final adapter = await DatabaseManager.getAdapter();
    final result = await adapter.query(
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
    final adapter = await DatabaseManager.getAdapter();

    // تمیز کردن و فرمت کردن شماره تلفن (تبدیل اعداد فارسی به انگلیسی)
    final cleanPhone = PersianNumberUtils.formatIranianMobile(phone);
    final cleanMessage = PersianNumberUtils.convertToEnglish(message);

    print(
      '[${PersianNumberUtils.getCurrentPersianDate()}] [اطلاعات] شروع ارسال پیامک',
    );
    print(
      '[${PersianNumberUtils.getCurrentPersianDate()}] [اطلاعات] شماره اصلی: $phone',
    );
    print(
      '[${PersianNumberUtils.getCurrentPersianDate()}] [اطلاعات] شماره تمیز شده: $cleanPhone',
    );
    print(
      '[${PersianNumberUtils.getCurrentPersianDate()}] [اطلاعات] پیام: ${cleanMessage.substring(0, cleanMessage.length > 50 ? 50 : cleanMessage.length)}...',
    );

    // انتخاب سامانه ارسال
    SmsProvider? provider;
    if (specificProviderId != null) {
      final data = await adapter.query(
        'sms_providers',
        where: 'id = ?',
        whereArgs: [specificProviderId],
      );
      if (data.isNotEmpty) {
        provider = SmsProvider.fromMap(data.first);
      }
    } else {
      final providers = await getActiveProviders();
      provider = providers.isNotEmpty ? providers.first : null;
    }

    if (provider == null) {
      throw Exception('هیچ سامانه پیامکی فعال یافت نشد');
    }

    // ایجاد لاگ پیامک
    final logId = await adapter.insert('sms_logs', {
      'provider_id': provider.id,
      'recipient_phone': cleanPhone,
      'message_text': cleanMessage,
      'status': 'pending',
      'created_at': DateTime.now().toIso8601String(),
    });

    try {
      // ارسال پیامک بر اساس نوع سامانه
      String responseCode = '';
      String responseMessage = '';

      switch (provider.providerType) {
        case '0098sms':
          final result = await _send0098Sms(
            provider.id!,
            cleanPhone,
            cleanMessage,
          );
          responseCode = result['code'] ?? '';
          responseMessage = result['message'] ?? '';
          break;
        case 'kavenegar':
          final result = await _sendKavenegarSms(
            provider.id!,
            cleanPhone,
            cleanMessage,
          );
          responseCode = result['code'] ?? '';
          responseMessage = result['message'] ?? '';
          break;
        case 'ghasedak':
          final result = await _sendGhasedakSms(
            provider.id!,
            cleanPhone,
            cleanMessage,
          );
          responseCode = result['code'] ?? '';
          responseMessage = result['message'] ?? '';
          break;
        case 'custom':
          final result = await _sendCustomSms(
            provider.id!,
            cleanPhone,
            cleanMessage,
          );
          responseCode = result['code'] ?? '';
          responseMessage = result['message'] ?? '';
          break;
        default:
          throw Exception(
            'نوع سامانه پشتیبانی نمی‌شود: ${provider.providerType}',
          );
      }

      // بروزرسانی وضعیت لاگ
      final status = responseCode == '0' ? 'sent' : 'failed';
      await adapter.update(
        'sms_logs',
        {
          'status': status,
          'response_code': responseCode,
          'response_message': responseMessage,
          'sent_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [logId],
      );

      // بازگردانی لاگ به‌روزرسانی شده
      final updatedLogData = await adapter.query(
        'sms_logs',
        where: 'id = ?',
        whereArgs: [logId],
      );

      if (updatedLogData.isNotEmpty) {
        return SmsLog.fromMap(updatedLogData.first);
      } else {
        // اگر لاگ پیدا نشد، یک لاگ جدید با اطلاعات موجود برگردان
        return SmsLog(
          id: logId,
          providerId: provider.id!,
          recipientPhone: cleanPhone,
          messageText: cleanMessage,
          status: status,
          responseCode: responseCode,
          responseMessage: responseMessage,
          createdAt: DateTime.now(),
          sentAt: DateTime.now(),
        );
      }
    } catch (e) {
      // ثبت خطا در لاگ با جزئیات بیشتر
      String errorMessage = e.toString();

      // تشخیص نوع خطا و ارائه راه‌حل
      if (errorMessage.contains('ClientException') ||
          errorMessage.contains('SocketException')) {
        if (errorMessage.contains('Operation not permitted')) {
          errorMessage =
              'خطای اتصال: دسترسی شبکه مسدود است. لطفاً تنظیمات فایروال یا VPN را بررسی کنید.';
        } else if (errorMessage.contains('Connection failed')) {
          errorMessage =
              'خطای اتصال: عدم دسترسی به سرور. لطفاً اتصال اینترنت را بررسی کنید.';
        } else if (errorMessage.contains('Connection timed out')) {
          errorMessage =
              'خطای اتصال: زمان اتصال به پایان رسید. سرور در دسترس نیست.';
        } else if (errorMessage.contains('Certificate')) {
          errorMessage = 'خطای امنیتی: مشکل در گواهی SSL سرور.';
        } else {
          errorMessage = 'خطای شبکه: $errorMessage';
        }
      }

      print('🚨 [SMS ERROR] جزئیات خطا: $errorMessage');

      await adapter.update(
        'sms_logs',
        {
          'status': 'failed',
          'response_code': 'CONNECTION_ERROR',
          'response_message': errorMessage,
        },
        where: 'id = ?',
        whereArgs: [logId],
      );

      final failedLogData = await adapter.query(
        'sms_logs',
        where: 'id = ?',
        whereArgs: [logId],
      );

      if (failedLogData.isNotEmpty) {
        return SmsLog.fromMap(failedLogData.first);
      } else {
        // اگر لاگ پیدا نشد، یک لاگ جدید با اطلاعات خطا برگردان
        return SmsLog(
          id: logId,
          providerId: provider.id!,
          recipientPhone: cleanPhone,
          messageText: cleanMessage,
          status: 'failed',
          responseCode: 'CONNECTION_ERROR',
          responseMessage: errorMessage,
          createdAt: DateTime.now(),
        );
      }
    }
  }

  // ارسال پیامک انبوه
  Future<List<SmsLog>> sendBulkSms({
    required List<String> phones,
    required String message,
    int? specificProviderId,
  }) async {
    final adapter = await DatabaseManager.getAdapter();
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
        final logId = await adapter.insert('sms_logs', {
          'provider_id': specificProviderId ?? 1,
          'recipient_phone': phone,
          'message_text': message,
          'status': 'failed',
          'response_message': e.toString(),
          'created_at': DateTime.now().toIso8601String(),
        });

        final failedLogData = await adapter.query(
          'sms_logs',
          where: 'id = ?',
          whereArgs: [logId],
        );

        if (failedLogData.isNotEmpty) {
          results.add(SmsLog.fromMap(failedLogData.first));
        }
      }
    }

    return results;
  }

  // دریافت تاریخچه پیامک‌ها
  Future<List<SmsLog>> getSmsHistory({
    int? providerId,
    String? status,
    DateTime? fromDate,
    DateTime? toDate,
    int limit = 100,
  }) async {
    final adapter = await DatabaseManager.getAdapter();

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

    // استفاده از query ساده به جای استفاده از orderBy و limit که در adapter موجود نیست
    final result = await adapter.query(
      'sms_logs',
      where: whereClause,
      whereArgs: whereArgs,
    );

    // مرتب‌سازی و محدود کردن در Dart
    final sortedResult = result
      ..sort((a, b) {
        final aDate =
            DateTime.tryParse(a['created_at'] ?? '') ?? DateTime.now();
        final bDate =
            DateTime.tryParse(b['created_at'] ?? '') ?? DateTime.now();
        return bDate.compareTo(aDate); // DESC
      });

    final limitedResult = sortedResult.take(limit).toList();
    return limitedResult.map((row) => SmsLog.fromMap(row)).toList();
  }

  // آمار پیامک‌ها
  Future<Map<String, int>> getSmsStats() async {
    final adapter = await DatabaseManager.getAdapter();

    // دریافت تمام لاگ‌ها و محاسبه آمار در Dart
    final allLogs = await adapter.query('sms_logs');

    int total = allLogs.length;
    int sent = allLogs.where((log) => log['status'] == 'sent').length;
    int failed = allLogs.where((log) => log['status'] == 'failed').length;
    int pending = allLogs.where((log) => log['status'] == 'pending').length;

    return {'total': total, 'sent': sent, 'failed': failed, 'pending': pending};
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

  // تست تنظیمات سامانه با جزئیات
  Future<Map<String, dynamic>> testProviderDetailed(int providerId) async {
    final adapter = await DatabaseManager.getAdapter();
    try {
      final provider = await adapter.query(
        'sms_providers',
        where: 'id = ?',
        whereArgs: [providerId],
      );

      if (provider.isEmpty) {
        return {
          'success': false,
          'error': 'سامانه با شناسه $providerId یافت نشد',
        };
      }

      final smsProvider = SmsProvider.fromMap(provider.first);
      final configs = await getProviderConfigs(providerId);

      // بررسی تنظیمات ضروری
      final requiredConfigs = _getRequiredConfigs(smsProvider.providerType);
      for (final requiredConfig in requiredConfigs) {
        if (!configs.containsKey(requiredConfig) ||
            configs[requiredConfig]?.isEmpty == true) {
          return {
            'success': false,
            'error': 'تنظیم $requiredConfig وجود ندارد یا خالی است',
            'configs': configs,
          };
        }
      }

      // ارسال پیامک تست
      final result = await sendSms(
        phone: '09123456789',
        message: 'تست سامانه ${smsProvider.name} - ${DateTime.now()}',
        specificProviderId: providerId,
      );

      return {
        'success': result.status == 'sent',
        'result': result.toMap(),
        'configs': configs,
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // دریافت لیست تنظیمات ضروری برای هر نوع سامانه
  List<String> _getRequiredConfigs(String providerType) {
    switch (providerType) {
      case '0098sms':
        return ['username', 'password', 'from', 'api_url'];
      case 'kavenegar':
        return ['api_key', 'from'];
      case 'ghasedak':
        return ['api_key', 'from'];
      case 'custom':
        return ['api_url'];
      default:
        return [];
    }
  }

  // ارسال پیامک از طریق سامانه ۰۰۹۸
  Future<Map<String, String>> _send0098Sms(
    int providerId,
    String phone,
    String message,
  ) async {
    final configs = await getProviderConfigs(providerId);

    print('🔍 [SMS DEBUG] تنظیمات خوانده شده از دیتابیس:');
    configs.forEach((key, value) {
      if (key == 'password') {
        print(
          '   $key: ${value.substring(0, 3)}...',
        ); // نمایش فقط 3 کاراکتر اول
      } else {
        print('   $key: $value');
      }
    });

    final username = configs['username'];
    final password = configs['password'];
    final from = configs['from'];
    final apiUrl =
        configs['api_url'] ??
        'http://0098sms.com/sendsmslink.aspx'; // HTTP به جای HTTPS
    final domain = configs['domain'] ?? '0098';
    final method = configs['method'] ?? 'GET';

    if (username == null || password == null || from == null) {
      final error = 'تنظیمات سامانه ۰۰۹۸ ناقص است';
      print('❌ [SMS DEBUG] $error');
      throw Exception(error);
    }

    print('🚀 [SMS DEBUG] ارسال پیامک با اطلاعات:');
    print('   📞 شماره: $phone');
    print(
      '   💬 متن: ${message.substring(0, message.length > 50 ? 50 : message.length)}...',
    );
    print('   👤 Username: $username');
    print('   🔐 Password: ${password.substring(0, 3)}...');

    // پاکسازی شماره تلفن
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');

    try {
      http.Response response;

      // تنظیمات HTTP client برای حل مشکلات اتصال
      final client = http.Client();

      try {
        if (method.toUpperCase() == 'POST') {
          // ارسال با روش POST
          response = await client
              .post(
                Uri.parse(apiUrl),
                headers: {
                  'Content-Type': 'application/x-www-form-urlencoded',
                  'User-Agent': 'SmartAssistant/1.0',
                },
                body: {
                  'USERNAME': username,
                  'PASSWORD': password,
                  'FROM': from,
                  'TO': cleanPhone,
                  'TEXT': message,
                  'DOMAIN': domain,
                },
              )
              .timeout(
                const Duration(seconds: 30),
                onTimeout: () {
                  throw Exception(
                    'درخواست زمان‌بر شد. لطفاً دوباره تلاش کنید.',
                  );
                },
              );
        } else {
          // ارسال با روش GET (مطابق مستندات جدید)
          final url = Uri.parse(apiUrl).replace(
            queryParameters: {
              'USERNAME': username,
              'PASSWORD': password,
              'FROM': from,
              'TO': cleanPhone,
              'TEXT': message,
              'DOMAIN': domain,
            },
          );
          print(
            '🌐 [SMS DEBUG] URL: ${url.toString().replaceAll(password, '***')}',
          );
          response = await client
              .get(url, headers: {'User-Agent': 'SmartAssistant/1.0'})
              .timeout(
                const Duration(seconds: 30),
                onTimeout: () {
                  throw Exception(
                    'درخواست زمان‌بر شد. لطفاً دوباره تلاش کنید.',
                  );
                },
              );
        }

        print('📊 [SMS DEBUG] پاسخ سرور:');
        print('   Status Code: ${response.statusCode}');
        print(
          '   Response Body: ${response.body.trim().substring(0, response.body.length > 100 ? 100 : response.body.length)}...',
        );

        if (response.statusCode == 200) {
          final responseBody = response.body.trim();

          // استخراج اولین خط response (کد واقعی)
          final firstLine = responseBody.split('\n').first.trim();

          print('🔍 [SMS DEBUG] اولین خط پاسخ: "$firstLine"');

          // تحلیل پاسخ سامانه ۰۰۹۸ (کد موفقیت = 0)
          if (firstLine == '0') {
            print('✅ [SMS DEBUG] ارسال موفق!');
            return {
              'code': '0',
              'message': 'عملیات با موفقیت به پایان رسید',
              'reference': '',
            };
          } else {
            print('❌ [SMS DEBUG] ارسال ناموفق با کد: $firstLine');
            return {
              'code': firstLine,
              'message': _get0098ErrorMessage(firstLine),
            };
          }
        } else {
          final error = 'خطا در ارتباط با سرور: ${response.statusCode}';
          print('🚨 [SMS DEBUG] $error');
          throw Exception(error);
        }
      } finally {
        client.close();
      }
    } catch (e) {
      final error = 'خطا در ارسال پیامک: $e';
      print('🚨 [SMS DEBUG] $error');
      throw Exception(error);
    }
  }

  // ترجمه کدهای خطای سامانه ۰۰۹۸ (مطابق مستندات جدید)
  String _get0098ErrorMessage(String responseCode) {
    final errorMap = {
      '0': 'عملیات با موفقیت به پایان رسید',
      '1': 'شماره گیرنده اشتباه است',
      '2': 'گیرنده تعریف نشده است',
      '3': 'فرستنده تعریف نشده است',
      '4': 'متن تنظیم نشده است',
      '5': 'نام کاربری تنظیم نشده است',
      '6': 'کلمه عبور تنظیم نشده است',
      '7': 'نام دامین تنظیم نشده است',
      '8': 'مجوز شما باطل شده است',
      '9': 'اعتبار پیامک شما کافی نیست',
      '10': 'برای این شماره لینک تعریف نشده است',
      '11': 'عدم مجوز برای اتصال لینک',
      '12': 'نام کاربری و کلمه ی عبور اشتباه است',
      '13': 'کاراکتر غیرمجاز در متن وجود دارد',
      '14': 'سقف ارسال روزانه پر شده است',
      '16': 'عدم مجوز شماره برای ارسال از لینک',
      '17': 'خطا در شماره پنل. لطفا با پشیانی تماس بگیرید',
      '18': 'اتمام تاریخ اعتبار شماره پنل. برای استفاده تمدید شود',
      '19': 'تنظیمات کد opt انجام نشده است',
      '20': 'فرمت کد opt صحیح نیست',
      '21': 'تنظیمات کد opt توسط ادمین تایید نشده است',
      '22': 'اطلاعات مالک شماره ثبت و تایید نشده است',
      '23': 'هنوز اجازه ارسال به این شماره پنل داده نشده است',
      '24': 'ارسال از IP غیرمجاز انجام شده است',
    };

    return errorMap[responseCode] ?? 'خطای نامشخص: $responseCode';
  }

  // ارسال پیامک از طریق سامانه کاوه نگار
  Future<Map<String, String>> _sendKavenegarSms(
    int providerId,
    String phone,
    String message,
  ) async {
    final configs = await getProviderConfigs(providerId);

    final apiKey = configs['api_key'];
    final from = configs['from'];
    final apiUrl = configs['api_url'] ?? 'https://api.kavenegar.com/v1';

    if (apiKey == null || from == null) {
      throw Exception('تنظیمات سامانه کاوه نگار ناقص است');
    }

    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');

    try {
      final url = Uri.parse('$apiUrl/$apiKey/sms/send.json');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'receptor': cleanPhone, 'sender': from, 'message': message},
      );

      if (response.statusCode == 200) {
        // Parse JSON response
        return {
          'code': '1',
          'message': 'پیامک با موفقیت ارسال شد',
          'reference': '',
        };
      } else {
        throw Exception(
          'خطا در ارتباط با سرور کاوه نگار: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('خطا در ارسال پیامک از طریق کاوه نگار: $e');
    }
  }

  // ارسال پیامک از طریق سامانه قاصدک
  Future<Map<String, String>> _sendGhasedakSms(
    int providerId,
    String phone,
    String message,
  ) async {
    final configs = await getProviderConfigs(providerId);

    final apiKey = configs['api_key'];
    final from = configs['from'];
    final apiUrl = configs['api_url'] ?? 'https://api.ghasedak.me/v2';

    if (apiKey == null || from == null) {
      throw Exception('تنظیمات سامانه قاصدک ناقص است');
    }

    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');

    try {
      final url = Uri.parse('$apiUrl/sms/send/simple');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'apikey': apiKey,
        },
        body: {'receptor': cleanPhone, 'linenumber': from, 'message': message},
      );

      if (response.statusCode == 200) {
        return {
          'code': '1',
          'message': 'پیامک با موفقیت ارسال شد',
          'reference': '',
        };
      } else {
        throw Exception('خطا در ارتباط با سرور قاصدک: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('خطا در ارسال پیامک از طریق قاصدک: $e');
    }
  }

  // ارسال پیامک از طریق سامانه سفارشی
  Future<Map<String, String>> _sendCustomSms(
    int providerId,
    String phone,
    String message,
  ) async {
    final configs = await getProviderConfigs(providerId);

    final apiUrl = configs['api_url'];
    final method = configs['method'] ?? 'POST';
    final bodyTemplate = configs['body_template'] ?? '';

    if (apiUrl == null) {
      throw Exception('URL API سامانه سفارشی مشخص نشده است');
    }

    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');

    try {
      // Replace placeholders in body template
      String requestBody = bodyTemplate
          .replaceAll('{phone}', cleanPhone)
          .replaceAll('{message}', message);

      http.Response response;

      if (method.toUpperCase() == 'GET') {
        final url = Uri.parse(
          apiUrl,
        ).replace(queryParameters: {'phone': cleanPhone, 'message': message});
        response = await http.get(url);
      } else {
        response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: requestBody,
        );
      }

      if (response.statusCode == 200) {
        return {
          'code': '1',
          'message': 'پیامک با موفقیت ارسال شد',
          'reference': '',
        };
      } else {
        throw Exception('خطا در ارتباط با سرور: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('خطا در ارسال پیامک: $e');
    }
  }
}
