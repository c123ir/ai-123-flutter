// lib/widgets/settings_page.dart
// صفحه تنظیمات کلی سیستم

import 'package:flutter/material.dart';
import 'sms_providers_management.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'تنظیمات سیستم',
            style: TextStyle(fontFamily: 'Vazirmatn'),
          ),
          backgroundColor: const Color(0xFF74b9ff),
          foregroundColor: Colors.white,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSettingsCard(
              context,
              title: 'مدیریت سامانه‌های پیامکی',
              subtitle: 'اضافه کردن، ویرایش و حذف سامانه‌های پیامک',
              icon: Icons.sms_rounded,
              color: const Color(0xFF667eea),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SmsProvidersManagement(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildSettingsCard(
              context,
              title: 'تنظیمات عمومی',
              subtitle: 'تنظیمات کلی سیستم و اعتبارات',
              icon: Icons.settings_rounded,
              color: const Color(0xFF11998e),
              onTap: () {
                // TODO: اضافه کردن صفحه تنظیمات عمومی
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'این بخش در نسخه بعدی اضافه خواهد شد',
                      style: TextStyle(fontFamily: 'Vazirmatn'),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildSettingsCard(
              context,
              title: 'مدیریت کاربران',
              subtitle: 'تنظیمات کاربران و دسترسی‌ها',
              icon: Icons.people_rounded,
              color: const Color(0xFF43cea2),
              onTap: () {
                // TODO: اضافه کردن صفحه مدیریت کاربران
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'این بخش در نسخه بعدی اضافه خواهد شد',
                      style: TextStyle(fontFamily: 'Vazirmatn'),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildSettingsCard(
              context,
              title: 'پشتیبان‌گیری و بازیابی',
              subtitle: 'پشتیبان‌گیری از پایگاه داده و تنظیمات',
              icon: Icons.backup_rounded,
              color: const Color(0xFFf953c6),
              onTap: () {
                // TODO: اضافه کردن صفحه پشتیبان‌گیری
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'این بخش در نسخه بعدی اضافه خواهد شد',
                      style: TextStyle(fontFamily: 'Vazirmatn'),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildSettingsCard(
              context,
              title: 'درباره سیستم',
              subtitle: 'اطلاعات نسخه و راهنمای استفاده',
              icon: Icons.info_rounded,
              color: const Color(0xFFffb347),
              onTap: () => _showAboutDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.1),
                color.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Vazirmatn',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontFamily: 'Vazirmatn',
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AboutDialog(
          applicationName: 'دستیار هوشمند یک دو سه',
          applicationVersion: '1.1.0',
          applicationIcon: const Icon(
            Icons.smart_toy_rounded,
            size: 48,
            color: Color(0xFF667eea),
          ),
          children: [
            const Text(
              'سیستم مدیریت هوشمند با قابلیت‌های پیشرفته',
              style: TextStyle(fontFamily: 'Vazirmatn'),
            ),
            const SizedBox(height: 16),
            const Text(
              'ویژگی‌ها:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Vazirmatn',
              ),
            ),
            const Text(
              '• مدیریت پیامک با چندین سامانه\n'
              '• رابط کاربری RTL فارسی\n'
              '• پایگاه داده SQLite\n'
              '• آمار و گزارش‌گیری\n'
              '• سیستم مدیریت کاربران',
              style: TextStyle(fontFamily: 'Vazirmatn'),
            ),
          ],
        ),
      ),
    );
  }
}
