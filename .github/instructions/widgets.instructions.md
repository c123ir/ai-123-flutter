---
applyTo: "lib/widgets/**"
---

# قوانین ایجاد ویجت‌ها (Widget Creation Rules)

## ساختار استاندارد ویجت

### فرمت کلی

```dart
// lib/widgets/widget_name.dart
// ویجت [نام ویجت] - توضیح کاربرد و عملکرد ویجت

import 'package:flutter/material.dart';
import '../utils/persian_date_helper.dart';
import '../utils/constants.dart';

/// ویجت [نام ویجت]
/// کاربرد: [توضیح کاربرد]
/// ویژگی‌ها: [لیست ویژگی‌ها]
class WidgetName extends StatefulWidget {
  /// متن نمایشی
  final String title;

  /// آیکون ویجت
  final IconData? icon;

  /// تابع کال‌بک هنگام کلیک
  final VoidCallback? onTap;

  /// آیا ویجت فعال است
  final bool isEnabled;

  const WidgetName({
    Key? key,
    required this.title,
    this.icon,
    this.onTap,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  State<WidgetName> createState() => _WidgetNameState();
}

class _WidgetNameState extends State<WidgetName>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// راه‌اندازی انیمیشن‌ها
  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  /// مدیریت کلیک
  void _handleTap() {
    if (!widget.isEnabled) return;

    // انیمیشن کلیک
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    // اجرای callback
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: _buildMainWidget(context),
          );
        },
      ),
    );
  }

  /// ساخت ویجت اصلی
  Widget _buildMainWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: widget.isEnabled
            ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isEnabled
              ? Theme.of(context).primaryColor.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.3),
        ),
      ),
      child: InkWell(
        onTap: _handleTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            // آیکون (در صورت وجود)
            if (widget.icon != null) ...[
              Icon(
                widget.icon,
                color: widget.isEnabled
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              const SizedBox(width: 12),
            ],

            // متن
            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontFamily: 'Vazirmatn',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: widget.isEnabled
                      ? Theme.of(context).textTheme.bodyLarge?.color
                      : Colors.grey,
                ),
              ),
            ),

            // فلش (در صورت نیاز)
            if (widget.onTap != null)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: widget.isEnabled
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
          ],
        ),
      ),
    );
  }
}
```

## قوانین طراحی UI

### RTL Support

```dart
Directionality(
  textDirection: TextDirection.rtl,
  child: Row(
    children: [
      // محتوا از راست به چپ
    ],
  ),
)
```

### فونت فارسی

```dart
Text(
  'متن فارسی',
  style: TextStyle(
    fontFamily: 'Vazirmatn',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  ),
)
```

### رنگ‌بندی

```dart
Container(
  decoration: BoxDecoration(
    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  ),
)
```

## الگوهای مفید

### ویجت Responsive

```dart
Widget _buildResponsiveLayout(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth > 1200) {
    // نمایش دسکتاپ
    return _buildDesktopLayout();
  } else if (screenWidth > 800) {
    // نمایش تبلت
    return _buildTabletLayout();
  } else {
    // نمایش موبایل
    return _buildMobileLayout();
  }
}
```

### مدیریت State

```dart
class _WidgetNameState extends State<WidgetName> {
  bool _isLoading = false;
  String? _errorMessage;

  /// نمایش حالت لودینگ
  void _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
      if (loading) _errorMessage = null;
    });
  }

  /// نمایش پیام خطا
  void _setError(String message) {
    setState(() {
      _isLoading = false;
      _errorMessage = message;
    });
  }
}
```

### انیمیشن ساده

```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  decoration: BoxDecoration(
    color: _isSelected
        ? Theme.of(context).primaryColor
        : Colors.transparent,
  ),
)
```

## نام‌گذاری ویجت‌ها

### انواع ویجت‌ها

- `CustomButton`: دکمه‌های سفارشی
- `DataCard`: کارت نمایش داده
- `ProgressBar`: نوار پیشرفت
- `SearchBox`: جعبه جستجو
- `NavigationItem`: آیتم منو
- `LoadingSpinner`: چرخش لودینگ

### نام فایل‌ها

- snake_case: `custom_button.dart`
- توصیفی: `admin_sidebar_item.dart`
- مختصر اما واضح: `user_avatar.dart`
