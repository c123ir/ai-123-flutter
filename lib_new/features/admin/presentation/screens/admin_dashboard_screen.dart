// lib_new/features/admin/presentation/screens/admin_dashboard_screen.dart
// داشبورد مدیریت - Admin Feature

import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../admin/screens/sms_panel_screen.dart';

/// صفحه داشبورد مدیریت
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          'داشبورد مدیریت',
          style: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: GridView.count(
            crossAxisCount: _getCrossAxisCount(context),
            crossAxisSpacing: AppDimensions.paddingMedium,
            mainAxisSpacing: AppDimensions.paddingMedium,
            children: [
              _buildDashboardCard(
                context,
                title: 'مدیریت SMS',
                icon: Icons.sms,
                color: Colors.blue,
                description: 'پنل ارسال و مدیریت پیامک',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SmsPanelScreen(),
                    ),
                  );
                },
              ),
              _buildDashboardCard(
                context,
                title: 'مدیریت کاربران',
                icon: Icons.people,
                color: Colors.green,
                description: 'مشاهده و مدیریت کاربران',
                onTap: () {
                  // TODO: Implement user management
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('بزودی پیاده‌سازی می‌شود')),
                  );
                },
              ),
              _buildDashboardCard(
                context,
                title: 'تنظیمات سیستم',
                icon: Icons.settings,
                color: Colors.orange,
                description: 'پیکربندی‌های عمومی سیستم',
                onTap: () {
                  // TODO: Implement system settings
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('بزودی پیاده‌سازی می‌شود')),
                  );
                },
              ),
              _buildDashboardCard(
                context,
                title: 'گزارشات',
                icon: Icons.analytics,
                color: Colors.purple,
                description: 'مشاهده آمار و گزارشات',
                onTap: () {
                  // TODO: Implement reports
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('بزودی پیاده‌سازی می‌شود')),
                  );
                },
              ),
              _buildDashboardCard(
                context,
                title: 'پشتیبان‌گیری',
                icon: Icons.backup,
                color: Colors.teal,
                description: 'مدیریت پشتیبان‌گیری سیستم',
                onTap: () {
                  // TODO: Implement backup management
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('بزودی پیاده‌سازی می‌شود')),
                  );
                },
              ),
              _buildDashboardCard(
                context,
                title: 'لاگ‌های سیستم',
                icon: Icons.history,
                color: Colors.red,
                description: 'مشاهده لاگ‌ها و خطاها',
                onTap: () {
                  // TODO: Implement system logs
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('بزودی پیاده‌سازی می‌شود')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 1;
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 48, color: color),
              ),
              const SizedBox(height: AppDimensions.paddingMedium),
              Text(
                title,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.paddingSmall),
              Text(
                description,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
