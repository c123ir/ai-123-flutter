---
applyTo: "lib_new/**/*.dart"
---

# UI Development Instructions - رهنمای توسعه رابط کاربری

## 🎯 مأموریت

توسعه رابط کاربری responsive و accessible با رعایت Material Design 3 و RTL support

## 📐 Responsive Design Templates

### Responsive Builder Pattern

```dart
// responsive_builder.dart
import 'package:flutter/material.dart';

/// Builder برای طراحی responsive
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints)
      mobile;
  final Widget Function(BuildContext context, BoxConstraints constraints)?
      tablet;
  final Widget Function(BuildContext context, BoxConstraints constraints)?
      desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppDimensions.desktopBreakpoint) {
          return desktop?.call(context, constraints) ??
              tablet?.call(context, constraints) ??
              mobile(context, constraints);
        } else if (constraints.maxWidth >= AppDimensions.tabletBreakpoint) {
          return tablet?.call(context, constraints) ??
              mobile(context, constraints);
        } else {
          return mobile(context, constraints);
        }
      },
    );
  }
}

/// Extension برای تشخیص نوع دستگاه
extension ResponsiveExtension on BuildContext {
  bool get isMobile =>
      MediaQuery.of(this).size.width < AppDimensions.mobileBreakpoint;

  bool get isTablet =>
      MediaQuery.of(this).size.width >= AppDimensions.mobileBreakpoint &&
      MediaQuery.of(this).size.width < AppDimensions.desktopBreakpoint;

  bool get isDesktop =>
      MediaQuery.of(this).size.width >= AppDimensions.desktopBreakpoint;

  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Responsive padding بر اساس سایز صفحه
  EdgeInsets get responsivePadding {
    if (isDesktop) {
      return const EdgeInsets.all(AppDimensions.paddingExtraLarge);
    } else if (isTablet) {
      return const EdgeInsets.all(AppDimensions.paddingLarge);
    } else {
      return const EdgeInsets.all(AppDimensions.paddingMedium);
    }
  }

  /// Responsive column count برای Grid
  int get responsiveColumns {
    if (isDesktop) return 4;
    if (isTablet) return 3;
    return 2;
  }
}
```

### RTL Support Template

```dart
// rtl_helper.dart
import 'package:flutter/material.dart';

/// Helper برای RTL support
class RTLHelper {
  /// بررسی جهت متن
  static bool isRTL(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl;
  }

  /// تبدیل اعداد انگلیسی به فارسی
  static String toPersianNumbers(String input) {
    const englishNumbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const persianNumbers = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

    String result = input;
    for (int i = 0; i < englishNumbers.length; i++) {
      result = result.replaceAll(englishNumbers[i], persianNumbers[i]);
    }
    return result;
  }

  /// تبدیل اعداد فارسی به انگلیسی
  static String toEnglishNumbers(String input) {
    const englishNumbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const persianNumbers = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

    String result = input;
    for (int i = 0; i < persianNumbers.length; i++) {
      result = result.replaceAll(persianNumbers[i], englishNumbers[i]);
    }
    return result;
  }

  /// Padding مناسب برای RTL
  static EdgeInsets rtlPadding({
    double start = 0,
    double top = 0,
    double end = 0,
    double bottom = 0,
  }) {
    return EdgeInsetsDirectional.only(
      start: start,
      top: top,
      end: end,
      bottom: bottom,
    );
  }

  /// Margin مناسب برای RTL
  static EdgeInsets rtlMargin({
    double start = 0,
    double top = 0,
    double end = 0,
    double bottom = 0,
  }) {
    return EdgeInsetsDirectional.only(
      start: start,
      top: top,
      end: end,
      bottom: bottom,
    );
  }
}

/// Widget برای تنظیم جهت RTL
class RTLWrapper extends StatelessWidget {
  final Widget child;

  const RTLWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: child,
    );
  }
}
```

## 🎨 Material Design 3 Templates

### Custom Components

```dart
// custom_card.dart
import 'package:flutter/material.dart';

/// کارت سفارشی با Material Design 3
class CustomCard extends StatelessWidget {
  final Widget? title;
  final Widget? subtitle;
  final Widget? content;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final Color? backgroundColor;
  final bool outlined;

  const CustomCard({
    super.key,
    this.title,
    this.subtitle,
    this.content,
    this.trailing,
    this.onTap,
    this.padding,
    this.elevation,
    this.backgroundColor,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        border: outlined
            ? Border.all(
                color: theme.colorScheme.outline,
                width: 1,
              )
            : null,
        boxShadow: elevation != null && !outlined
            ? [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.1),
                  blurRadius: elevation!,
                  offset: Offset(0, elevation! / 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          child: Padding(
            padding: padding ??
                const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null || trailing != null)
                  Row(
                    children: [
                      if (title != null) Expanded(child: title!),
                      if (trailing != null) trailing!,
                    ],
                  ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppDimensions.paddingSmall),
                  subtitle!,
                ],
                if (content != null) ...[
                  const SizedBox(height: AppDimensions.paddingMedium),
                  content!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// لیست آیتم سفارشی
class CustomListTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool dense;
  final EdgeInsetsGeometry? contentPadding;

  const CustomListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.dense = false,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
      dense: dense,
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMedium,
            vertical: AppDimensions.paddingSmall,
          ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
    );
  }
}

/// دکمه شناور سفارشی
class CustomFAB extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final bool extended;
  final String? label;

  const CustomFAB({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.extended = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    if (extended && label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label!),
        tooltip: tooltip,
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      child: Icon(icon),
    );
  }
}
```

### Input Components

```dart
// custom_input.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// فیلد ورودی سفارشی
class CustomTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? helper;
  final String? error;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final bool required;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.helper,
    this.error,
    this.controller,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(
              bottom: AppDimensions.paddingSmall,
            ),
            child: RichText(
              text: TextSpan(
                text: label!,
                style: Theme.of(context).textTheme.labelLarge,
                children: [
                  if (required)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: AppColors.error),
                    ),
                ],
              ),
            ),
          ),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          onTap: onTap,
          readOnly: readOnly,
          obscureText: obscureText,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          maxLength: maxLength,
          enabled: enabled,
          textDirection: _getTextDirection(),
          decoration: InputDecoration(
            hintText: hint,
            helperText: helper,
            errorText: error,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            counterText: maxLength != null ? null : '',
          ),
        ),
      ],
    );
  }

  TextDirection? _getTextDirection() {
    if (keyboardType == TextInputType.number ||
        keyboardType == TextInputType.phone) {
      return TextDirection.ltr;
    }
    return null; // استفاده از جهت پیش‌فرض
  }
}

/// Dropdown سفارشی
class CustomDropdown<T> extends StatelessWidget {
  final String? label;
  final String? hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final bool required;
  final String? error;

  const CustomDropdown({
    super.key,
    this.label,
    this.hint,
    this.value,
    required this.items,
    this.onChanged,
    this.required = false,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(
              bottom: AppDimensions.paddingSmall,
            ),
            child: RichText(
              text: TextSpan(
                text: label!,
                style: Theme.of(context).textTheme.labelLarge,
                children: [
                  if (required)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: AppColors.error),
                    ),
                ],
              ),
            ),
          ),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            errorText: error,
          ),
        ),
      ],
    );
  }
}
```

## 🔄 Animation Templates

### Custom Animations

```dart
// animations.dart
import 'package:flutter/material.dart';

/// انیمیشن fade in
class FadeInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;

  const FadeInAnimation({
    super.key,
    required this.child,
    this.duration = AppDimensions.animationNormal,
    this.delay = Duration.zero,
  });

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

/// انیمیشن slide in
class SlideInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Offset offset;

  const SlideInAnimation({
    super.key,
    required this.child,
    this.duration = AppDimensions.animationNormal,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 1),
  });

  @override
  State<SlideInAnimation> createState() => _SlideInAnimationState();
}

class _SlideInAnimationState extends State<SlideInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween(begin: widget.offset, end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}

/// انیمیشن scale in
class ScaleInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;

  const ScaleInAnimation({
    super.key,
    required this.child,
    this.duration = AppDimensions.animationNormal,
    this.delay = Duration.zero,
  });

  @override
  State<ScaleInAnimation> createState() => _ScaleInAnimationState();
}

class _ScaleInAnimationState extends State<ScaleInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}
```

## 🎯 Loading & Error States

### Loading Components

```dart
// loading_states.dart
import 'package:flutter/material.dart';

/// Loading indicator سفارشی
class CustomLoadingIndicator extends StatelessWidget {
  final String? message;
  final double size;
  final Color? color;

  const CustomLoadingIndicator({
    super.key,
    this.message,
    this.size = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: color ?? Theme.of(context).colorScheme.primary,
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: AppDimensions.paddingMedium),
          Text(
            message!,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Empty state component
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppDimensions.iconExtraLarge * 2,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: AppDimensions.paddingLarge),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppDimensions.paddingSmall),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: AppDimensions.paddingLarge),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error state component
class ErrorState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onRetry;

  const ErrorState({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: AppDimensions.iconExtraLarge * 2,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppDimensions.paddingLarge),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppDimensions.paddingSmall),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionText != null && onRetry != null) ...[
              const SizedBox(height: AppDimensions.paddingLarge),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

## 🔍 Validation Rules

### UI باید:

- ✅ Responsive design داشته باشد
- ✅ RTL support کامل داشته باشد
- ✅ Material Design 3 principles رعایت کند
- ✅ Accessibility features داشته باشد
- ✅ Consistent color scheme استفاده کند
- ✅ Proper spacing و typography داشته باشد
- ✅ Loading و error states مناسب داشته باشد
- ✅ Smooth animations داشته باشد

### Performance:

- ✅ Efficient widget building
- ✅ Optimized image loading
- ✅ Minimal rebuild count
- ✅ Proper state management
- ✅ Memory leak prevention

## 🎯 نکات مهم

1. **همیشه ResponsiveBuilder استفاده کنید**
2. **RTL support اجباری است**
3. **Material Design 3 guidelines رعایت کنید**
4. **Loading و Error states فراموش نشود**
5. **Animation ها smooth باشند**
6. **Accessibility در نظر گرفته شود**
7. **Performance optimization اولویت دارد**
8. **Theme system consistency حفظ شود**
