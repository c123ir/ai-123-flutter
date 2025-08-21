// example/sms_example.dart
// مثال استفاده از سیستم مدیریت پیامک

import 'package:flutter/material.dart';
import 'package:ai_123/services/sms_service.dart';
import 'package:ai_123/widgets/sms_panel.dart';

void main() {
  runApp(const SmsExampleApp());
}

class SmsExampleApp extends StatelessWidget {
  const SmsExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مثال سیستم پیامک',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Vazirmatn'),
      home: const SmsExampleHome(),
    );
  }
}

class SmsExampleHome extends StatefulWidget {
  const SmsExampleHome({super.key});

  @override
  State<SmsExampleHome> createState() => _SmsExampleHomeState();
}

class _SmsExampleHomeState extends State<SmsExampleHome> {
  final SmsService _smsService = SmsService();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'مثال سیستم پیامک',
            style: TextStyle(fontFamily: 'Vazirmatn'),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'نمونه استفاده از سیستم مدیریت پیامک',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Vazirmatn',
                ),
              ),
              const SizedBox(height: 32),

              // دکمه ارسال پیامک تست
              ElevatedButton.icon(
                onPressed: _sendTestSms,
                icon: const Icon(Icons.send),
                label: const Text(
                  'ارسال پیامک تست',
                  style: TextStyle(fontFamily: 'Vazirmatn'),
                ),
              ),
              const SizedBox(height: 16),

              // دکمه باز کردن پنل مدیریت
              ElevatedButton.icon(
                onPressed: _openSmsPanel,
                icon: const Icon(Icons.dashboard),
                label: const Text(
                  'پنل مدیریت پیامک',
                  style: TextStyle(fontFamily: 'Vazirmatn'),
                ),
              ),
              const SizedBox(height: 16),

              // دکمه نمایش آمار
              ElevatedButton.icon(
                onPressed: _showStats,
                icon: const Icon(Icons.analytics),
                label: const Text(
                  'نمایش آمار پیامک‌ها',
                  style: TextStyle(fontFamily: 'Vazirmatn'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendTestSms() async {
    try {
      final result = await _smsService.sendSms(
        phone: '09123456789',
        message: 'این یک پیامک تست از سیستم دستیار هوشمند یک دو سه است.',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.isSent
                  ? 'پیامک با موفقیت ارسال شد'
                  : 'خطا در ارسال پیامک: ${result.responseMessage}',
              style: const TextStyle(fontFamily: 'Vazirmatn'),
            ),
            backgroundColor: result.isSent ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'خطا در ارسال پیامک: $e',
              style: const TextStyle(fontFamily: 'Vazirmatn'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _openSmsPanel() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const SmsPanel()));
  }

  Future<void> _showStats() async {
    try {
      final stats = await _smsService.getSmsStats();

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: const Text(
                'آمار پیامک‌ها',
                style: TextStyle(fontFamily: 'Vazirmatn'),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'کل پیامک‌ها: ${stats['total'] ?? 0}',
                    style: const TextStyle(fontFamily: 'Vazirmatn'),
                  ),
                  Text(
                    'ارسال شده: ${stats['sent'] ?? 0}',
                    style: const TextStyle(fontFamily: 'Vazirmatn'),
                  ),
                  Text(
                    'ناموفق: ${stats['failed'] ?? 0}',
                    style: const TextStyle(fontFamily: 'Vazirmatn'),
                  ),
                  Text(
                    'در انتظار: ${stats['pending'] ?? 0}',
                    style: const TextStyle(fontFamily: 'Vazirmatn'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'بستن',
                    style: TextStyle(fontFamily: 'Vazirmatn'),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'خطا در دریافت آمار: $e',
              style: const TextStyle(fontFamily: 'Vazirmatn'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
