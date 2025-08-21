// manual_sms_test.dart
// تست دستی سرویس SMS برای دیباگ

import 'package:flutter/material.dart';
import 'lib/services/sms_service.dart';
import 'lib/models/sms_provider.dart';

class ManualSmsTestWidget extends StatefulWidget {
  @override
  _ManualSmsTestWidgetState createState() => _ManualSmsTestWidgetState();
}

class _ManualSmsTestWidgetState extends State<ManualSmsTestWidget> {
  final SmsService _smsService = SmsService();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  List<SmsProvider> _providers = [];
  SmsProvider? _selectedProvider;
  String _result = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  Future<void> _loadProviders() async {
    setState(() => _isLoading = true);
    try {
      final providers = await _smsService.getActiveProviders();
      setState(() {
        _providers = providers;
        _selectedProvider = providers.isNotEmpty ? providers.first : null;
      });
    } catch (e) {
      setState(() => _result = 'خطا در بارگذاری سامانه‌ها: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _testProvider() async {
    if (_selectedProvider == null) return;

    setState(() => _isLoading = true);
    try {
      final result = await _smsService.testProviderDetailed(
        _selectedProvider!.id!,
      );
      setState(() {
        _result = 'نتیجه تست سامانه ${_selectedProvider!.name}:\n';
        _result += result['success'] ? '✅ موفق' : '❌ ناموفق';
        if (result['success'] != true) {
          _result += '\nخطا: ${result['error']}';
          _result += '\nتنظیمات: ${result['configs']}';
        }
      });
    } catch (e) {
      setState(() => _result = 'خطا در تست: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _sendTestSms() async {
    if (_selectedProvider == null ||
        _phoneController.text.isEmpty ||
        _messageController.text.isEmpty) {
      setState(() => _result = 'لطفاً تمام فیلدها را پر کنید');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final smsLog = await _smsService.sendSms(
        phone: _phoneController.text,
        message: _messageController.text,
        specificProviderId: _selectedProvider!.id,
      );

      setState(() {
        _result = 'نتیجه ارسال پیامک:\n';
        _result += 'وضعیت: ${smsLog.status}\n';
        _result += 'کد پاسخ: ${smsLog.responseCode}\n';
        _result += 'پیام پاسخ: ${smsLog.responseMessage}\n';
      });
    } catch (e) {
      setState(() => _result = 'خطا در ارسال: $e');
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('تست دستی SMS')),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // انتخاب سامانه
              if (_providers.isNotEmpty) ...[
                Text(
                  'سامانه:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<SmsProvider>(
                  value: _selectedProvider,
                  isExpanded: true,
                  onChanged: (provider) =>
                      setState(() => _selectedProvider = provider),
                  items: _providers
                      .map(
                        (provider) => DropdownMenuItem(
                          value: provider,
                          child: Text(provider.name),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: 16),
              ],

              // شماره تلفن
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'شماره تلفن',
                  hintText: '09123456789',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),

              // متن پیامک
              TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  labelText: 'متن پیامک',
                  hintText: 'تست پیامک...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),

              // دکمه‌ها
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _testProvider,
                      child: Text('تست سامانه'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _sendTestSms,
                      child: Text('ارسال تست'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // نتیجه
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else if (_result.isNotEmpty) ...[
                Text(
                  'نتیجه:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_result),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
