import 'package:flutter/material.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/dashboard_graph.dart';
import '../widgets/admin_sidebar.dart';
import '../widgets/sms_panel.dart';
import '../widgets/settings_page.dart';
import 'update_history_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE3F2FD), // آبی روشن
              Color(0xFFF3E5F5), // بنفش روشن
              Color(0xFFE8F5E8), // سبز روشن
            ],
          ),
        ),
        child: Row(
          children: [
            // Main Content
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _buildMainContent(),
                ),
              ),
            ),
            // Sidebar (left)
            SizedBox(
              width: 280,
              child: AdminSidebar(
                selectedIndex: selectedIndex,
                onMenuTap: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                menuItems: adminMenuItems,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    if (selectedIndex == 0) {
      // داشبورد اصلی
      return SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ردیف اول کارت‌ها
            Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    title: 'فروش کل',
                    icon: Icons.shopping_cart_rounded,
                    color: const Color(0xFF2ECC71),
                    value: '۵۸٬۹۰۰٬۰۰۰',
                    subtitle: 'تومان این ماه',
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: DashboardCard(
                    title: 'پرسنل فعال',
                    icon: Icons.badge_rounded,
                    color: const Color(0xFF9B59B6),
                    value: '۲۳',
                    subtitle: 'در حال خدمت',
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: DashboardCard(
                    title: 'سرمایه‌گذاران',
                    icon: Icons.account_balance_rounded,
                    color: const Color(0xFFE67E22),
                    value: '۱۲',
                    subtitle: 'سرمایه‌گذار فعال',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // ردیف دوم کارت‌ها
            Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    title: 'مشاوره‌های امروز',
                    icon: Icons.support_agent_rounded,
                    color: const Color(0xFFE91E63),
                    value: '۴۷',
                    subtitle: 'جلسه مشاوره',
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: DashboardCard(
                    title: 'تگ‌های فعال',
                    icon: Icons.label_rounded,
                    color: const Color(0xFF00BCD4),
                    value: '۱۸۵',
                    subtitle: 'تگ در سیستم',
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: DashboardCard(
                    title: 'کاربران آنلاین',
                    icon: Icons.supervisor_account_rounded,
                    color: const Color(0xFF4CAF50),
                    value: '۱۲۴',
                    subtitle: 'آنلاین الان',
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: DashboardCard(
                    title: 'گزارشات ماه',
                    icon: Icons.analytics_rounded,
                    color: const Color(0xFFFF9800),
                    value: '۳۶',
                    subtitle: 'گزارش تولید شده',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: DashboardGraph(
                    title: 'روند فروش ماهانه',
                    data: [
                      0.2,
                      0.4,
                      0.6,
                      0.8,
                      0.7,
                      0.9,
                      1.0,
                      0.8,
                      0.7,
                      0.6,
                      0.5,
                      0.7,
                    ],
                    color: const Color(0xFF2ECC71),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: DashboardGraph(
                    title: 'روند جذب مشتری',
                    data: [
                      0.1,
                      0.3,
                      0.5,
                      0.7,
                      0.6,
                      0.8,
                      0.9,
                      0.7,
                      0.6,
                      0.5,
                      0.4,
                      0.6,
                    ],
                    color: const Color(0xFF3498DB),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
    // بررسی اگر منو مدیریت پیامک انتخاب شده باشد
    else if (selectedIndex == 6) {
      // مدیریت پیامک (ایندکس ۶ بعد از مدیریت تگ ها)
      return Directionality(
        textDirection: TextDirection.rtl,
        child: SmsPanel(),
      );
    }
    // بررسی اگر منو تنظیمات انتخاب شده باشد
    else if (selectedIndex == 11) {
      // تنظیمات (ایندکس ۱۱)
      return Directionality(
        textDirection: TextDirection.rtl,
        child: SettingsPage(),
      );
    }
    // بررسی اگر منو تاریخچه بروزرسانی انتخاب شده باشد
    else if (selectedIndex == 12) {
      // تاریخچه بروزرسانی (ایندکس ۱۲)
      return const UpdateHistoryScreen();
    }
    // سایر منوها
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            adminMenuItems[selectedIndex].icon,
            size: 80,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 20),
          Text(
            adminMenuItems[selectedIndex].title,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'محتوای ${adminMenuItems[selectedIndex].title} در اینجا نمایش داده می‌شود',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
