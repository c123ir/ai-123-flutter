---
applyTo: "lib_new/shared/**"
---

# Shared Components Instructions - کامپوننت‌های مشترک

## 🎯 مأموریت

توسعه کامپوننت‌های مشترک قابل استفاده در تمام features

## 📂 ساختار الزامی

```
shared/
├── widgets/                # کامپوننت‌های UI مشترک
│   ├── buttons/           # دکمه‌ها
│   ├── forms/             # فرم‌ها و input ها
│   ├── dialogs/           # دیالوگ‌ها
│   ├── layout/            # لایوت‌ها
│   └── widgets.dart       # Export file
├── utils/                 # ابزارهای کمکی
│   ├── validators.dart    # اعتبارسنجی
│   ├── formatters.dart    # فرمت کننده‌ها
│   ├── extensions.dart    # Extension methods
│   ├── constants.dart     # ثابت‌ها
│   ├── helpers.dart       # توابع کمکی
│   └── utils.dart         # Export file
└── models/                # مدل‌های مشترک
    ├── api_response.dart  # پاسخ API
    ├── error_model.dart   # مدل خطاها
    ├── pagination_model.dart # صفحه‌بندی
    └── models.dart        # Export file
```

## 🧩 Widget Templates

### Custom Button Template

```dart
// widgets/buttons/custom_button.dart
import 'package:flutter/material.dart';

/// دکمه سفارشی با پشتیبانی کامل از theme
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? icon;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: _getHeight(),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: _getButtonStyle(theme),
        child: isLoading
            ? _buildLoadingIndicator()
            : _buildContent(),
      ),
    );
  }

  double _getHeight() {
    switch (size) {
      case ButtonSize.small:
        return 36;
      case ButtonSize.medium:
        return 48;
      case ButtonSize.large:
        return 56;
    }
  }

  ButtonStyle _getButtonStyle(ThemeData theme) {
    return ElevatedButton.styleFrom(
      backgroundColor: _getBackgroundColor(theme),
      foregroundColor: _getForegroundColor(theme),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }

  Widget _buildContent() {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }
    return Text(text);
  }

  Color _getBackgroundColor(ThemeData theme) {
    switch (variant) {
      case ButtonVariant.primary:
        return theme.colorScheme.primary;
      case ButtonVariant.secondary:
        return theme.colorScheme.secondary;
      case ButtonVariant.danger:
        return theme.colorScheme.error;
    }
  }

  Color _getForegroundColor(ThemeData theme) {
    switch (variant) {
      case ButtonVariant.primary:
        return theme.colorScheme.onPrimary;
      case ButtonVariant.secondary:
        return theme.colorScheme.onSecondary;
      case ButtonVariant.danger:
        return theme.colorScheme.onError;
    }
  }
}

enum ButtonVariant { primary, secondary, danger }
enum ButtonSize { small, medium, large }
```

### Custom TextField Template

```dart
// widgets/forms/custom_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// فیلد متنی سفارشی با پشتیبانی کامل از فارسی و validation
class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool enabled;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? maxLength;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      obscureText: _isObscured,
      enabled: widget.enabled,
      inputFormatters: widget.inputFormatters,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      textDirection: TextDirection.rtl,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        helperText: widget.helperText,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon)
            : null,
        suffixIcon: _buildSuffixIcon(),
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility),
        onPressed: () {
          setState(() {
            _isObscured = !_isObscured;
          });
        },
      );
    }

    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(widget.suffixIcon),
        onPressed: widget.onSuffixIconPressed,
      );
    }

    return null;
  }
}
```

### Responsive Layout Template

```dart
// widgets/layout/responsive_layout.dart
import 'package:flutter/material.dart';

/// لایوت responsive با پشتیبانی از mobile, tablet, desktop
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= ResponsiveBreakpoints.desktop) {
          return desktop;
        } else if (constraints.maxWidth >= ResponsiveBreakpoints.tablet) {
          return tablet ?? desktop;
        } else {
          return mobile;
        }
      },
    );
  }
}

/// Helper class برای responsive design
class ResponsiveHelper {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < ResponsiveBreakpoints.tablet;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= ResponsiveBreakpoints.tablet &&
           width < ResponsiveBreakpoints.desktop;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= ResponsiveBreakpoints.desktop;
  }

  static T responsive<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet ?? desktop;
    return mobile;
  }
}

class ResponsiveBreakpoints {
  static const double tablet = 768;
  static const double desktop = 1024;
}
```

## 🛠️ Utils Templates

### Validators

```dart
// utils/validators.dart

/// کلاس اعتبارسنجی فرم‌ها
class Validators {
  /// اعتبارسنجی ایمیل
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'ایمیل الزامی است';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'فرمت ایمیل صحیح نیست';
    }

    return null;
  }

  /// اعتبارسنجی شماره موبایل
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'شماره موبایل الزامی است';
    }

    // تمیز کردن شماره
    final cleanNumber = value.replaceAll(RegExp(r'[^\d]'), '');

    // بررسی طول و فرمت
    if (cleanNumber.length != 11 || !cleanNumber.startsWith('09')) {
      return 'شماره موبایل باید ۱۱ رقم و با ۰۹ شروع شود';
    }

    return null;
  }

  /// اعتبارسنجی رمز عبور
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'رمز عبور الزامی است';
    }

    if (value.length < 8) {
      return 'رمز عبور باید حداقل ۸ کاراکتر باشد';
    }

    return null;
  }

  /// اعتبارسنجی فیلد الزامی
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'این فیلد'} الزامی است';
    }
    return null;
  }

  /// اعتبارسنجی حداقل طول
  static String? minLength(String? value, int minLength, [String? fieldName]) {
    if (value == null || value.length < minLength) {
      return '${fieldName ?? 'این فیلد'} باید حداقل $minLength کاراکتر باشد';
    }
    return null;
  }
}
```

### Extensions

```dart
// utils/extensions.dart
import 'package:persian_number_utility/persian_number_utility.dart';

/// Extensions برای String
extension StringExtensions on String {
  /// تبدیل اعداد فارسی به انگلیسی
  String get toPersianDigits => toPersianDigit();

  /// تبدیل اعداد انگلیسی به فارسی
  String get toEnglishDigits => toEnglishDigit();

  /// Capitalize کردن اولین حرف
  String get capitalized {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// بررسی خالی بودن (null safe)
  bool get isNullOrEmpty => trim().isEmpty;

  /// تمیز کردن شماره موبایل
  String get cleanPhoneNumber {
    return replaceAll(RegExp(r'[^\d]'), '');
  }
}

/// Extensions برای DateTime
extension DateTimeExtensions on DateTime {
  /// تبدیل به تاریخ شمسی
  String get toPersianDate {
    // پیاده‌سازی تبدیل تاریخ شمسی
    return toString(); // موقتی
  }

  /// فرمت زمان فارسی
  String get toPersianTime {
    final hour = this.hour.toString().padLeft(2, '0').toPersianDigit();
    final minute = this.minute.toString().padLeft(2, '0').toPersianDigit();
    return '$hour:$minute';
  }
}

/// Extensions برای BuildContext
extension BuildContextExtensions on BuildContext {
  /// دسترسی آسان به Theme
  ThemeData get theme => Theme.of(this);

  /// دسترسی آسان به MediaQuery
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// عرض صفحه
  double get screenWidth => mediaQuery.size.width;

  /// ارتفاع صفحه
  double get screenHeight => mediaQuery.size.height;

  /// نمایش SnackBar
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
```

## 📝 Constants

```dart
// utils/constants.dart

/// ثابت‌های اپلیکیشن
class AppConstants {
  // API
  static const String apiBaseUrl = 'https://api.example.com';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Local Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxUsernameLength = 50;

  // UI
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const Duration animationDuration = Duration(milliseconds: 300);

  // Regex Patterns
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phonePattern = r'^09\d{9}$';
}

/// رنگ‌های سفارشی
class AppColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color error = Color(0xFFB00020);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
}

/// سایزهای مختلف
class AppSizes {
  // Spacing
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;

  // Icon Sizes
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;

  // Border Radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
}
```

## 📋 Export Files الزامی

### Widgets Export

```dart
// widgets/widgets.dart
export 'buttons/buttons.dart';
export 'forms/forms.dart';
export 'dialogs/dialogs.dart';
export 'layout/layout.dart';
```

### Utils Export

```dart
// utils/utils.dart
export 'validators.dart';
export 'formatters.dart';
export 'extensions.dart';
export 'constants.dart';
export 'helpers.dart';
```

### Models Export

```dart
// models/models.dart
export 'api_response.dart';
export 'error_model.dart';
export 'pagination_model.dart';
```

## 🔍 Validation Rules

### قبل از ایجاد هر Component:

1. ✅ بررسی عدم تکرار functionality
2. ✅ طراحی API مناسب
3. ✅ پیاده‌سازی responsive design
4. ✅ پشتیبانی RTL
5. ✅ Theme compliance
6. ✅ Documentation کامل

### Component باید:

- ✅ قابل استفاده مجدد باشد
- ✅ Configurable باشد
- ✅ Performance optimized باشد
- ✅ Accessible باشد
- ✅ Well documented باشد

## 🎯 نکات مهم

1. **همه components باید از theme system استفاده کنند**
2. **RTL support اجباری است**
3. **Responsive design الزامی است**
4. **Performance را در نظر بگیرید**
5. **Documentation کامل بنویسید**
6. **Testing فراموش نشود**
