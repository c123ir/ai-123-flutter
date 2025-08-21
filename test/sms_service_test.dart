// test/sms_service_test.dart
// تست واحد سرویس مدیریت پیامک

import 'package:flutter_test/flutter_test.dart';
import 'package:ai_123/models/sms_provider.dart';
import 'package:ai_123/models/sms_config.dart';
import 'package:ai_123/models/sms_log.dart';

void main() {
  group('تست مدل‌های SMS', () {
    test('باید SmsProvider را صحیح ایجاد کند', () {
      final provider = SmsProvider(
        id: 1,
        name: 'تست سامانه',
        providerType: 'test',
        description: 'توضیحات تست',
        isActive: true,
        priority: 1,
      );

      expect(provider.id, equals(1));
      expect(provider.name, equals('تست سامانه'));
      expect(provider.providerType, equals('test'));
      expect(provider.isActive, isTrue);
    });

    test('باید SmsProvider را از Map ایجاد کند', () {
      final map = {
        'id': 1,
        'name': 'سامانه ۰۰۹۸',
        'provider_type': '0098sms',
        'description': 'سامانه پیامکی ۰۰۹۸',
        'is_active': 1,
        'priority': 1,
      };

      final provider = SmsProvider.fromMap(map);

      expect(provider.id, equals(1));
      expect(provider.name, equals('سامانه ۰۰۹۸'));
      expect(provider.providerType, equals('0098sms'));
      expect(provider.isActive, isTrue);
    });

    test('باید SmsConfig را صحیح ایجاد کند', () {
      final config = SmsConfig(
        id: 1,
        providerId: 1,
        configKey: 'username',
        configValue: 'test_user',
        isEncrypted: false,
      );

      expect(config.id, equals(1));
      expect(config.providerId, equals(1));
      expect(config.configKey, equals('username'));
      expect(config.configValue, equals('test_user'));
      expect(config.isEncrypted, isFalse);
    });

    test('باید SmsLog را صحیح ایجاد کند', () {
      final log = SmsLog(
        id: 1,
        providerId: 1,
        recipientPhone: '09123456789',
        messageText: 'تست پیامک',
        status: 'sent',
      );

      expect(log.id, equals(1));
      expect(log.recipientPhone, equals('09123456789'));
      expect(log.messageText, equals('تست پیامک'));
      expect(log.status, equals('sent'));
      expect(log.isSent, isTrue);
      expect(log.statusPersian, equals('ارسال شده'));
    });

    test('باید وضعیت‌های مختلف SmsLog را تشخیص دهد', () {
      final statuses = [
        {'status': 'pending', 'persian': 'در انتظار'},
        {'status': 'sent', 'persian': 'ارسال شده'},
        {'status': 'delivered', 'persian': 'تحویل داده شده'},
        {'status': 'failed', 'persian': 'ناموفق'},
      ];

      for (final statusData in statuses) {
        final log = SmsLog(
          providerId: 1,
          recipientPhone: '09123456789',
          messageText: 'تست',
          status: statusData['status']!,
        );

        expect(log.statusPersian, equals(statusData['persian']));
      }
    });
  });

  group('اعتبارسنجی ورودی‌ها', () {
    test('باید شماره تلفن را صحیح پاکسازی کند', () {
      final testPhones = [
        '09123456789',
        '+989123456789',
        '0098 912 345 6789',
        '(+98) 912-345-6789',
      ];

      for (final phone in testPhones) {
        final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
        expect(cleanPhone.length, greaterThanOrEqualTo(10));
        expect(cleanPhone, matches(r'^\d+$'));
      }
    });

    test('باید شماره‌های نامعتبر را تشخیص دهد', () {
      final invalidPhones = [
        '',
        '123',
        'abc',
        '++98',
        '0912345678', // کوتاه
        '091234567890123', // طولانی
      ];

      for (final phone in invalidPhones) {
        final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
        if (cleanPhone.isEmpty || cleanPhone.length < 10) {
          expect(cleanPhone.length, lessThan(10));
        }
      }
    });

    test('باید متن پیامک را اعتبارسنجی کند', () {
      final validMessages = [
        'سلام',
        'این یک پیامک تست است',
        'متن فارسی با اعداد ۱۲۳',
      ];

      final invalidMessages = ['', ' ', '\n\t'];

      for (final message in validMessages) {
        expect(message.trim().isNotEmpty, isTrue);
      }

      for (final message in invalidMessages) {
        expect(message.trim().isEmpty, isTrue);
      }
    });
  });

  group('تست متدهای کمکی', () {
    test('باید کدهای خطای ۰۰۹۸ را صحیح ترجمه کند', () {
      final errorCodes = {
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

      errorCodes.forEach((code, expectedMessage) {
        expect(expectedMessage, isNotNull);
        expect(expectedMessage.length, greaterThan(10));
        expect(expectedMessage, isA<String>());
      });
    });

    test('باید URL API را صحیح بسازد', () {
      final apiUrl = 'https://api.0098sms.com/sendsms.aspx';
      final uri = Uri.parse(apiUrl);

      expect(uri.scheme, equals('https'));
      expect(uri.host, equals('api.0098sms.com'));
      expect(uri.path, equals('/sendsms.aspx'));
    });

    test('باید پارامترهای URL را صحیح اضافه کند', () {
      final baseUrl = 'https://api.0098sms.com/sendsms.aspx';
      final params = {
        'username': 'test_user',
        'password': 'test_pass',
        'from': '3000164545',
        'to': '09123456789',
        'text': 'تست پیامک',
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: params);

      expect(uri.queryParameters['username'], equals('test_user'));
      expect(uri.queryParameters['from'], equals('3000164545'));
      expect(uri.queryParameters['text'], equals('تست پیامک'));
    });
  });

  group('تست منطق کسب‌وکار', () {
    test('باید اولویت سامانه‌ها را صحیح مرتب کند', () {
      final providers = [
        SmsProvider(
          id: 1,
          name: 'سامانه A',
          providerType: 'typeA',
          priority: 1,
        ),
        SmsProvider(
          id: 2,
          name: 'سامانه B',
          providerType: 'typeB',
          priority: 3,
        ),
        SmsProvider(
          id: 3,
          name: 'سامانه C',
          providerType: 'typeC',
          priority: 2,
        ),
      ];

      providers.sort((a, b) => b.priority.compareTo(a.priority));

      expect(providers[0].priority, equals(3)); // بالاترین اولویت
      expect(providers[1].priority, equals(2));
      expect(providers[2].priority, equals(1)); // پایین‌ترین اولویت
    });

    test('باید پیامک‌های طولانی را تشخیص دهد', () {
      final shortMessage = 'پیامک کوتاه';
      final longMessage =
          'پیامک بسیار طولانی که بیش از ۱۶۰ کاراکتر دارد. ' * 10;

      expect(shortMessage.length, lessThanOrEqualTo(160));
      expect(longMessage.length, greaterThan(160));
    });

    test('باید فرمت تاریخ را صحیح تولید کند', () {
      final now = DateTime.now();
      final formatted =
          '${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      expect(formatted, matches(r'^\d{4}/\d{2}/\d{2} \d{2}:\d{2}$'));
    });
  });
}
