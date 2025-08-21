import 'package:flutter/material.dart';

class SidebarMenuItem {
  final IconData icon;
  final String title;
  final LinearGradient gradient;

  const SidebarMenuItem({
    required this.icon,
    required this.title,
    required this.gradient,
  });
}

// فهرست منوهای سایدبار (خارج از صفحه داشبورد)
const List<SidebarMenuItem> adminMenuItems = [
  SidebarMenuItem(
    icon: Icons.dashboard_rounded,
    title: 'داشبورد',
    gradient: LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
  ),
  SidebarMenuItem(
    icon: Icons.people_alt_rounded,
    title: 'مشتریان',
    gradient: LinearGradient(colors: [Color(0xFF43cea2), Color(0xFF185a9d)]),
  ),
  SidebarMenuItem(
    icon: Icons.shopping_cart_rounded,
    title: 'مدیریت فروش',
    gradient: LinearGradient(colors: [Color(0xFFf7971e), Color(0xFFffd200)]),
  ),
  SidebarMenuItem(
    icon: Icons.support_agent_rounded,
    title: 'دستیار مشاوره',
    gradient: LinearGradient(colors: [Color(0xFFf953c6), Color(0xFFb91d73)]),
  ),
  SidebarMenuItem(
    icon: Icons.supervisor_account_rounded,
    title: 'مدیریت کاربران',
    gradient: LinearGradient(colors: [Color(0xFF11998e), Color(0xFF38ef7d)]),
  ),
  SidebarMenuItem(
    icon: Icons.label_rounded,
    title: 'مدیریت تگ ها',
    gradient: LinearGradient(colors: [Color(0xFFee9ca7), Color(0xFFffdde1)]),
  ),
  SidebarMenuItem(
    icon: Icons.badge_rounded,
    title: 'مدیریت پرسنل',
    gradient: LinearGradient(colors: [Color(0xFFc471ed), Color(0xFFf64f59)]),
  ),
  SidebarMenuItem(
    icon: Icons.account_balance_rounded,
    title: 'سرمایه گذاران',
    gradient: LinearGradient(colors: [Color(0xFF43cea2), Color(0xFF185a9d)]),
  ),
  SidebarMenuItem(
    icon: Icons.token_rounded,
    title: 'مدیریت توکن مانیبل',
    gradient: LinearGradient(colors: [Color(0xFFffb347), Color(0xFFffcc33)]),
  ),
  SidebarMenuItem(
    icon: Icons.analytics_rounded,
    title: 'گزارشات',
    gradient: LinearGradient(colors: [Color(0xFFffecd2), Color(0xFFfcb69f)]),
  ),
  SidebarMenuItem(
    icon: Icons.settings_rounded,
    title: 'تنظیمات',
    gradient: LinearGradient(colors: [Color(0xFF74b9ff), Color(0xFF0984e3)]),
  ),
];

class AdminSidebar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onMenuTap;
  final List<SidebarMenuItem> menuItems;

  const AdminSidebar({
    super.key,
    required this.selectedIndex,
    required this.onMenuTap,
    required this.menuItems,
  });

  @override
  State<AdminSidebar> createState() => _AdminSidebarState();
}

class _AdminSidebarState extends State<AdminSidebar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.1)),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFF6B6B)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellow.withValues(alpha: 0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'دستیار هوشمند',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'پنل مدیریت',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              // Menu Items
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: widget.menuItems.length,
                  itemBuilder: (context, index) {
                    return _buildMenuItem(index);
                  },
                ),
              ),
              // Footer
              Container(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white24,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'مدیر سیستم',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'آنلاین',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(int index) {
    final isSelected = widget.selectedIndex == index;
    final item = widget.menuItems[index];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            widget.onMenuTap(index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.2),
                        Colors.white.withValues(alpha: 0.1),
                      ],
                    )
                  : null,
              color: isSelected ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.4)
                    : Colors.transparent,
                width: 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: isSelected ? item.gradient : null,
                    color: isSelected
                        ? null
                        : Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// تعریف کلاس بالاتر انتقال یافت.
