// lib_new/features/admin/screens/sms_panel_screen.dart
// پنل مدیریت SMS - Admin Feature

import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../core/core.dart';
import '../../../shared/shared.dart';

/// صفحه پنل مدیریت SMS
class SmsPanelScreen extends StatefulWidget {
  const SmsPanelScreen({super.key});

  @override
  State<SmsPanelScreen> createState() => _SmsPanelScreenState();
}

class _SmsPanelScreenState extends State<SmsPanelScreen> {
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  SmsProviderType _selectedProvider = SmsProviderType.ghasedakSms;
  bool _isLoading = false;
  String? _resultMessage;
  List<SmsLog> _recentLogs = [];

  @override
  void initState() {
    super.initState();
    _initializeSmsService();
    _loadRecentLogs();
  }

  void _initializeSmsService() {
    // تنظیم پیکربندی نمونه
    final config = CompleteSmsConfig(
      ghasedakConfig: GhasedakConfig(
        apiKey: 'demo-api-key',
        lineNumber: '30005006007008',
      ),
      sms0098Config: Sms0098Config(
        username: 'demo-user',
        password: 'demo-pass',
        sender: '30005006007008',
      ),
      kavenegarConfig: KavenegarConfig(
        apiKey: 'demo-kavenegar-key',
        sender: '30005006007008',
      ),
    );

    SmsService.instance.configure(config);
  }

  void _loadRecentLogs() {
    setState(() {
      _recentLogs = SmsService.instance.logs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          'پنل مدیریت SMS',
          style: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    // فرم ارسال SMS
                    Expanded(flex: 2, child: _buildSmsForm()),
                    const SizedBox(width: AppDimensions.paddingMedium),
                    // آمار و لاگ‌ها
                    Expanded(flex: 3, child: _buildStatsAndLogs()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmsForm() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'ارسال پیامک',
                style: AppTextStyles.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.paddingMedium),

              // انتخاب پروایدر
              DropdownButtonFormField<SmsProviderType>(
                value: _selectedProvider,
                decoration: const InputDecoration(
                  labelText: 'سامانه ارسال',
                  border: OutlineInputBorder(),
                ),
                items: SmsProviderType.values.map((provider) {
                  return DropdownMenuItem(
                    value: provider,
                    child: Text(provider.persianName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProvider = value!;
                  });
                },
              ),
              const SizedBox(height: AppDimensions.paddingMedium),

              // شماره موبایل
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'شماره موبایل',
                  hintText: '09123456789',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'شماره موبایل را وارد کنید';
                  }
                  if (!PersianNumberUtils.isValidIranianMobile(value)) {
                    return 'شماره موبایل معتبر نیست';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.paddingMedium),

              // متن پیام
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'متن پیام',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'متن پیام را وارد کنید';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.paddingMedium),

              // دکمه ارسال
              ElevatedButton(
                onPressed: _isLoading ? null : _sendSms,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.paddingMedium,
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        'ارسال پیامک',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: Colors.white,
                        ),
                      ),
              ),

              // نمایش نتیجه
              if (_resultMessage != null) ...[
                const SizedBox(height: AppDimensions.paddingMedium),
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                  decoration: BoxDecoration(
                    color: _resultMessage!.contains('موفق')
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _resultMessage!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: _resultMessage!.contains('موفق')
                          ? Colors.green.shade800
                          : Colors.red.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsAndLogs() {
    return Column(
      children: [
        // آمار
        Expanded(flex: 1, child: _buildStats()),
        const SizedBox(height: AppDimensions.paddingMedium),
        // لاگ‌ها
        Expanded(flex: 2, child: _buildLogs()),
      ],
    );
  }

  Widget _buildStats() {
    final stats = SmsService.instance.getStatistics();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'آمار ارسال',
              style: AppTextStyles.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'کل ارسال‌ها',
                      stats['total'].toString(),
                      AppColors.primary,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'موفق',
                      stats['sent'].toString(),
                      Colors.green,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'ناموفق',
                      stats['failed'].toString(),
                      Colors.red,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'درصد موفقیت',
                      '${stats['success_rate']}%',
                      AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSmall,
      ),
      padding: const EdgeInsets.all(AppDimensions.paddingSmall),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: AppTextStyles.headlineSmall.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          Text(
            title,
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLogs() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('لاگ ارسال‌ها', style: AppTextStyles.titleLarge),
                IconButton(
                  onPressed: _loadRecentLogs,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            Expanded(
              child: _recentLogs.isEmpty
                  ? Center(
                      child: Text(
                        'هیچ پیامکی ارسال نشده است',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _recentLogs.length,
                      itemBuilder: (context, index) {
                        final log = _recentLogs[index];
                        return _buildLogItem(log);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogItem(SmsLog log) {
    final statusColor = log.status == SmsStatus.sent.name
        ? Colors.green
        : log.status == SmsStatus.failed.name
        ? Colors.red
        : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
      padding: const EdgeInsets.all(AppDimensions.paddingSmall),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                PersianNumberUtils.convertToPersian(log.recipientPhone),
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingSmall,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusText(log.status),
                  style: AppTextStyles.bodySmall.copyWith(color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          Text(
            log.messageText,
            style: AppTextStyles.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (log.sentAt != null) ...[
            const SizedBox(height: AppDimensions.paddingSmall),
            Text(
              _formatDateTime(log.sentAt!),
              style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'sent':
        return 'ارسال شده';
      case 'failed':
        return 'ناموفق';
      case 'pending':
        return 'در انتظار';
      default:
        return status;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} - ${dateTime.day}/${dateTime.month}';
  }

  Future<void> _sendSms() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _resultMessage = null;
    });

    try {
      await SmsService.instance.sendSms(
        phoneNumber: _phoneController.text.trim(),
        message: _messageController.text.trim(),
        preferredProvider: _selectedProvider,
      );

      setState(() {
        _resultMessage = 'پیامک با موفقیت ارسال شد';
        _loadRecentLogs();
      });

      // پاک کردن فرم
      _phoneController.clear();
      _messageController.clear();
    } catch (e) {
      setState(() {
        _resultMessage = 'خطا در ارسال: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
