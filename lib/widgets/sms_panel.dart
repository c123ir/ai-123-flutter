// lib/widgets/sms_panel.dart
// پنل مدیریت پیامک - رابط کاربری مدیریت سامانه‌های پیامکی

import 'package:flutter/material.dart';
import '../services/sms_service.dart';
import '../models/sms_provider.dart';
import '../models/sms_log.dart';

class SmsPanel extends StatefulWidget {
  const SmsPanel({super.key});

  @override
  State<SmsPanel> createState() => _SmsPanelState();
}

class _SmsPanelState extends State<SmsPanel> with TickerProviderStateMixin {
  final SmsService _smsService = SmsService.instance;
  late TabController _tabController;

  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  final _bulkPhonesController = TextEditingController();

  List<SmsProvider> _providers = [];
  List<SmsLog> _smsHistory = [];
  Map<String, int> _smsStats = {};
  bool _isLoading = false;
  SmsProvider? _selectedProvider;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final providers = await _smsService.getActiveProviders();
      final history = await _smsService.getSmsHistory(limit: 50);
      final stats = await _smsService.getSmsStats();

      setState(() {
        _providers = providers;
        _smsHistory = history;
        _smsStats = stats;
        _selectedProvider = providers.isNotEmpty ? providers.first : null;
      });
    } catch (e) {
      _showError('خطا در بارگذاری داده‌ها: $e');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'مدیریت پیامک',
            style: TextStyle(fontFamily: 'Vazirmatn'),
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'ارسال تکی'),
              Tab(text: 'ارسال انبوه'),
              Tab(text: 'تاریخچه'),
              Tab(text: 'آمار'),
            ],
          ),
          actions: [
            IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildSingleSmsTab(),
                  _buildBulkSmsTab(),
                  _buildHistoryTab(),
                  _buildStatsTab(),
                ],
              ),
      ),
    );
  }

  Widget _buildSingleSmsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // انتخاب سامانه
          if (_providers.isNotEmpty) ...[
            const Text(
              'سامانه پیامکی:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Vazirmatn',
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<SmsProvider>(
              value: _selectedProvider,
              isExpanded: true,
              onChanged: (provider) {
                setState(() => _selectedProvider = provider);
              },
              items: _providers.map((provider) {
                return DropdownMenuItem(
                  value: provider,
                  child: Text(
                    provider.name,
                    style: const TextStyle(fontFamily: 'Vazirmatn'),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],

          // شماره تلفن
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'شماره تلفن',
              hintText: '09123456789',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            textDirection: TextDirection.ltr,
          ),
          const SizedBox(height: 16),

          // متن پیامک
          TextField(
            controller: _messageController,
            decoration: const InputDecoration(
              labelText: 'متن پیامک',
              hintText: 'متن پیامک خود را وارد کنید...',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            maxLength: 160,
          ),
          const SizedBox(height: 16),

          // دکمه‌های ارسال و تست
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _sendSingleSms,
                  icon: const Icon(Icons.send),
                  label: const Text(
                    'ارسال پیامک',
                    style: TextStyle(fontFamily: 'Vazirmatn'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _selectedProvider != null
                    ? () => _testProvider()
                    : null,
                icon: const Icon(Icons.science),
                label: const Text(
                  'تست سامانه',
                  style: TextStyle(fontFamily: 'Vazirmatn'),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBulkSmsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // شماره‌های تلفن
          TextField(
            controller: _bulkPhonesController,
            decoration: const InputDecoration(
              labelText: 'شماره‌های تلفن',
              hintText: 'شماره‌ها را با کاما جدا کنید\n09123456789,09987654321',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          // متن پیامک
          TextField(
            controller: _messageController,
            decoration: const InputDecoration(
              labelText: 'متن پیامک',
              hintText: 'متن پیامک خود را وارد کنید...',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            maxLength: 160,
          ),
          const SizedBox(height: 16),

          // دکمه ارسال انبوه
          ElevatedButton.icon(
            onPressed: _sendBulkSms,
            icon: const Icon(Icons.send_to_mobile),
            label: const Text(
              'ارسال انبوه',
              style: TextStyle(fontFamily: 'Vazirmatn'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Column(
      children: [
        // فیلترها
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _filterHistory('all'),
                  icon: const Icon(Icons.list),
                  label: const Text('همه'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _filterHistory('sent'),
                  icon: const Icon(Icons.check_circle),
                  label: const Text('ارسال شده'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _filterHistory('failed'),
                  icon: const Icon(Icons.error),
                  label: const Text('ناموفق'),
                ),
              ),
            ],
          ),
        ),

        // لیست تاریخچه
        Expanded(
          child: ListView.builder(
            itemCount: _smsHistory.length,
            itemBuilder: (context, index) {
              final sms = _smsHistory[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: Icon(
                    sms.isSent
                        ? Icons.check_circle
                        : sms.isFailed
                        ? Icons.error
                        : Icons.access_time,
                    color: sms.isSent
                        ? Colors.green
                        : sms.isFailed
                        ? Colors.red
                        : Colors.orange,
                  ),
                  title: Text(
                    sms.recipientPhone,
                    style: const TextStyle(fontFamily: 'Vazirmatn'),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sms.messageText.length > 50
                            ? '${sms.messageText.substring(0, 50)}...'
                            : sms.messageText,
                        style: const TextStyle(fontFamily: 'Vazirmatn'),
                      ),
                      Text(
                        'وضعیت: ${sms.statusPersian}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Vazirmatn',
                        ),
                      ),
                      // نمایش کد خطا و دلیل در صورت عدم موفقیت
                      if (sms.isFailed &&
                          (sms.responseCode != null ||
                              sms.responseMessage != null))
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (sms.responseCode != null)
                                Text(
                                  'کد خطا: ${sms.responseCode}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontFamily: 'Vazirmatn',
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              if (sms.responseMessage != null)
                                Text(
                                  'دلیل: ${sms.responseMessage}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontFamily: 'Vazirmatn',
                                    color: Colors.red,
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  trailing: Text(
                    sms.createdAt != null ? _formatDate(sms.createdAt!) : '',
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Vazirmatn',
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // کارت‌های آمار
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'کل پیامک‌ها',
                  _smsStats['total']?.toString() ?? '0',
                  Icons.sms,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  'ارسال شده',
                  _smsStats['sent']?.toString() ?? '0',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'ناموفق',
                  _smsStats['failed']?.toString() ?? '0',
                  Icons.error,
                  Colors.red,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  'در انتظار',
                  _smsStats['pending']?.toString() ?? '0',
                  Icons.access_time,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // تست اتصال سامانه‌ها
          if (_providers.isNotEmpty) ...[
            const Text(
              'تست سامانه‌های پیامکی:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Vazirmatn',
              ),
            ),
            const SizedBox(height: 16),
            ...(_providers.map(
              (provider) => Card(
                child: ListTile(
                  leading: Icon(
                    provider.isActive ? Icons.check_circle : Icons.error,
                    color: provider.isActive ? Colors.green : Colors.red,
                  ),
                  title: Text(
                    provider.name,
                    style: const TextStyle(fontFamily: 'Vazirmatn'),
                  ),
                  subtitle: Text(
                    provider.isActive ? 'فعال' : 'غیرفعال',
                    style: const TextStyle(fontFamily: 'Vazirmatn'),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () => _testSpecificProvider(provider),
                    child: const Text(
                      'تست',
                      style: TextStyle(fontFamily: 'Vazirmatn'),
                    ),
                  ),
                ),
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'Vazirmatn',
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontFamily: 'Vazirmatn'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendSingleSms() async {
    if (_phoneController.text.isEmpty || _messageController.text.isEmpty) {
      _showError('لطفاً تمام فیلدها را پر کنید');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _smsService.sendSms(
        phone: _phoneController.text,
        message: _messageController.text,
        specificProviderId: _selectedProvider?.id,
      );

      _showSuccess('پیامک با موفقیت ارسال شد');
      _phoneController.clear();
      _messageController.clear();
      _loadData();
    } catch (e) {
      _showError('خطا در ارسال پیامک: $e');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _sendBulkSms() async {
    if (_bulkPhonesController.text.isEmpty || _messageController.text.isEmpty) {
      _showError('لطفاً تمام فیلدها را پر کنید');
      return;
    }

    final phones = _bulkPhonesController.text
        .split(',')
        .map((phone) => phone.trim())
        .where((phone) => phone.isNotEmpty)
        .toList();

    if (phones.isEmpty) {
      _showError('شماره تلفن معتبری وارد نشده است');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _smsService.sendBulkSms(
        phones: phones,
        message: _messageController.text,
        specificProviderId: _selectedProvider?.id,
      );

      _showSuccess('پیامک‌ها با موفقیت ارسال شدند');
      _bulkPhonesController.clear();
      _messageController.clear();
      _loadData();
    } catch (e) {
      _showError('خطا در ارسال پیامک‌ها: $e');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _filterHistory(String status) async {
    setState(() => _isLoading = true);

    try {
      final history = await _smsService.getSmsHistory(
        status: status == 'all' ? null : status,
        limit: 100,
      );

      setState(() => _smsHistory = history);
    } catch (e) {
      _showError('خطا در بارگذاری تاریخچه: $e');
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

      if (result['success'] == true) {
        _showSuccess('تست سامانه ${_selectedProvider!.name} موفق بود');
      } else {
        final error = result['error'] ?? 'خطای نامشخص';
        final configs = result['configs'];
        String debugInfo = 'خطا: $error';
        if (configs != null) {
          debugInfo += '\nتنظیمات موجود: ${configs.keys.join(', ')}';
        }
        _showError(
          'تست سامانه ${_selectedProvider!.name} ناموفق بود\n$debugInfo',
        );
      }
    } catch (e) {
      _showError('خطا در تست سامانه: $e');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _testSpecificProvider(SmsProvider provider) async {
    setState(() => _isLoading = true);

    try {
      final result = await _smsService.testProviderDetailed(provider.id!);

      if (result['success'] == true) {
        _showSuccess('تست سامانه ${provider.name} موفق بود');
      } else {
        final error = result['error'] ?? 'خطای نامشخص';
        final configs = result['configs'];
        String debugInfo = 'خطا: $error';
        if (configs != null) {
          debugInfo += '\nتنظیمات موجود: ${configs.keys.join(', ')}';
        }
        _showError('تست سامانه ${provider.name} ناموفق بود\n$debugInfo');
      }
    } catch (e) {
      _showError('خطا در تست سامانه: $e');
    }

    setState(() => _isLoading = false);
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Vazirmatn')),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Vazirmatn')),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    _bulkPhonesController.dispose();
    super.dispose();
  }
}
