---
applyTo: "lib_new/app/**"
---

# App Configuration Instructions - تنظیمات اپلیکیشن

## 🎯 مأموریت

تنظیم و پیکربندی اصلی اپلیکیشن شامل theme، routing، و configuration

## 📂 ساختار الزامی

```
app/
├── app.dart                # تعریف MyApp اصلی
├── app_router.dart         # مدیریت routing
├── app_config.dart         # تنظیمات کلی
└── theme/                  # سیستم theme
    ├── app_theme.dart      # تعریف theme اصلی
    ├── app_colors.dart     # رنگ‌بندی
    ├── app_text_styles.dart # استایل متن‌ها
    ├── app_dimensions.dart # ابعاد و spacing
    └── theme.dart          # Export file
```

## 🎨 Theme System Templates

### App Theme

```dart
// theme/app_theme.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_dimensions.dart';

/// سیستم theme اصلی اپلیکیشن
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Vazirmatn',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      textTheme: AppTextStyles.lightTextTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      cardTheme: _cardTheme,
      appBarTheme: _appBarTheme,
      bottomNavigationBarTheme: _bottomNavigationBarTheme,
      floatingActionButtonTheme: _floatingActionButtonTheme,
      dividerTheme: _dividerTheme,
      chipTheme: _chipTheme,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Vazirmatn',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      textTheme: AppTextStyles.darkTextTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _inputDecorationThemeDark,
      cardTheme: _cardThemeDark,
      appBarTheme: _appBarThemeDark,
      bottomNavigationBarTheme: _bottomNavigationBarThemeDark,
      floatingActionButtonTheme: _floatingActionButtonTheme,
      dividerTheme: _dividerTheme,
      chipTheme: _chipThemeDark,
    );
  }

  // Button Themes
  static ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, AppDimensions.buttonHeight),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLarge,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        ),
        textStyle: AppTextStyles.buttonText,
      ),
    );
  }

  static OutlinedButtonThemeData get _outlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, AppDimensions.buttonHeight),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLarge,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        ),
        textStyle: AppTextStyles.buttonText,
      ),
    );
  }

  static TextButtonThemeData get _textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(0, AppDimensions.buttonHeight),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
        ),
        textStyle: AppTextStyles.buttonText,
      ),
    );
  }

  // Input Decoration Theme
  static InputDecorationTheme get _inputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBackground,
      contentPadding: const EdgeInsets.all(AppDimensions.paddingMedium),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 2,
        ),
      ),
    );
  }

  static InputDecorationTheme get _inputDecorationThemeDark {
    return _inputDecorationTheme.copyWith(
      fillColor: AppColors.inputBackgroundDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        borderSide: const BorderSide(color: AppColors.inputBorderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        borderSide: const BorderSide(color: AppColors.inputBorderDark),
      ),
    );
  }

  // Card Theme
  static CardTheme get _cardTheme {
    return CardTheme(
      elevation: AppDimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      margin: const EdgeInsets.all(AppDimensions.paddingSmall),
    );
  }

  static CardTheme get _cardThemeDark {
    return _cardTheme.copyWith(
      color: AppColors.cardBackgroundDark,
    );
  }

  // AppBar Theme
  static AppBarTheme get _appBarTheme {
    return AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      titleTextStyle: AppTextStyles.appBarTitle,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppDimensions.borderRadius),
        ),
      ),
    );
  }

  static AppBarTheme get _appBarThemeDark {
    return _appBarTheme.copyWith(
      backgroundColor: AppColors.primaryDark,
      foregroundColor: AppColors.onPrimaryDark,
    );
  }

  // Bottom Navigation Bar Theme
  static BottomNavigationBarThemeData get _bottomNavigationBarTheme {
    return const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      backgroundColor: AppColors.surface,
      elevation: AppDimensions.cardElevation,
    );
  }

  static BottomNavigationBarThemeData get _bottomNavigationBarThemeDark {
    return _bottomNavigationBarTheme.copyWith(
      selectedItemColor: AppColors.primaryDark,
      unselectedItemColor: AppColors.textSecondaryDark,
      backgroundColor: AppColors.surfaceDark,
    );
  }

  // Floating Action Button Theme
  static FloatingActionButtonThemeData get _floatingActionButtonTheme {
    return const FloatingActionButtonThemeData(
      backgroundColor: AppColors.secondary,
      foregroundColor: AppColors.onSecondary,
      elevation: AppDimensions.fabElevation,
    );
  }

  // Divider Theme
  static DividerThemeData get _dividerTheme {
    return const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: AppDimensions.paddingMedium,
    );
  }

  // Chip Theme
  static ChipThemeData get _chipTheme {
    return ChipThemeData(
      backgroundColor: AppColors.chipBackground,
      selectedColor: AppColors.primary,
      deleteIconColor: AppColors.textSecondary,
      labelStyle: AppTextStyles.chipLabel,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSmall,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
      ),
    );
  }

  static ChipThemeData get _chipThemeDark {
    return _chipTheme.copyWith(
      backgroundColor: AppColors.chipBackgroundDark,
      deleteIconColor: AppColors.textSecondaryDark,
    );
  }
}
```

### App Colors

```dart
// theme/app_colors.dart
import 'package:flutter/material.dart';

/// رنگ‌های اپلیکیشن
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryDark = Color(0xFFFFFFFF);

  // Secondary Colors
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryDark = Color(0xFF018786);
  static const Color onSecondary = Color(0xFF000000);
  static const Color onSecondaryDark = Color(0xFFFFFFFF);

  // Surface Colors
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF121212);
  static const Color onSurface = Color(0xFF000000);
  static const Color onSurfaceDark = Color(0xFFFFFFFF);

  // Background Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF000000);
  static const Color onBackground = Color(0xFF000000);
  static const Color onBackgroundDark = Color(0xFFFFFFFF);

  // Error Colors
  static const Color error = Color(0xFFB00020);
  static const Color errorDark = Color(0xFFCF6679);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorDark = Color(0xFF000000);

  // Success Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successDark = Color(0xFF388E3C);
  static const Color onSuccess = Color(0xFFFFFFFF);

  // Warning Colors
  static const Color warning = Color(0xFFFF9800);
  static const Color warningDark = Color(0xFFF57C00);
  static const Color onWarning = Color(0xFF000000);

  // Info Colors
  static const Color info = Color(0xFF2196F3);
  static const Color infoDark = Color(0xFF1976D2);
  static const Color onInfo = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textDisabledDark = Color(0xFF616161);

  // Input Colors
  static const Color inputBackground = Color(0xFFF5F5F5);
  static const Color inputBackgroundDark = Color(0xFF2C2C2C);
  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color inputBorderDark = Color(0xFF424242);

  // Card Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBackgroundDark = Color(0xFF1E1E1E);

  // Chip Colors
  static const Color chipBackground = Color(0xFFE0E0E0);
  static const Color chipBackgroundDark = Color(0xFF424242);

  // Divider Color
  static const Color divider = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF424242);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [
      Color(0xFFE3F2FD),
      Color(0xFFF3E5F5),
      Color(0xFFE8F5E8),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
```

### App Text Styles

```dart
// theme/app_text_styles.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// استایل‌های متن اپلیکیشن
class AppTextStyles {
  // Display Styles
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: 'Vazirmatn',
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: 'Vazirmatn',
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Vazirmatn',
  );

  // Headline Styles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Vazirmatn',
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Vazirmatn',
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Vazirmatn',
  );

  // Title Styles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Vazirmatn',
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    fontFamily: 'Vazirmatn',
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    fontFamily: 'Vazirmatn',
  );

  // Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    fontFamily: 'Vazirmatn',
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    fontFamily: 'Vazirmatn',
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    fontFamily: 'Vazirmatn',
  );

  // Label Styles
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    fontFamily: 'Vazirmatn',
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    fontFamily: 'Vazirmatn',
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    fontFamily: 'Vazirmatn',
  );

  // Special Styles
  static const TextStyle buttonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: 'Vazirmatn',
  );

  static const TextStyle appBarTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
    fontFamily: 'Vazirmatn',
  );

  static const TextStyle chipLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFamily: 'Vazirmatn',
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    color: AppColors.textSecondary,
    fontFamily: 'Vazirmatn',
  );

  // Light Theme Text Theme
  static TextTheme get lightTextTheme {
    return const TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    );
  }

  // Dark Theme Text Theme
  static TextTheme get darkTextTheme {
    return lightTextTheme.copyWith(
      displayLarge: displayLarge.copyWith(color: AppColors.textPrimaryDark),
      displayMedium: displayMedium.copyWith(color: AppColors.textPrimaryDark),
      displaySmall: displaySmall.copyWith(color: AppColors.textPrimaryDark),
      headlineLarge: headlineLarge.copyWith(color: AppColors.textPrimaryDark),
      headlineMedium: headlineMedium.copyWith(color: AppColors.textPrimaryDark),
      headlineSmall: headlineSmall.copyWith(color: AppColors.textPrimaryDark),
      titleLarge: titleLarge.copyWith(color: AppColors.textPrimaryDark),
      titleMedium: titleMedium.copyWith(color: AppColors.textPrimaryDark),
      titleSmall: titleSmall.copyWith(color: AppColors.textSecondaryDark),
      bodyLarge: bodyLarge.copyWith(color: AppColors.textPrimaryDark),
      bodyMedium: bodyMedium.copyWith(color: AppColors.textPrimaryDark),
      bodySmall: bodySmall.copyWith(color: AppColors.textSecondaryDark),
      labelLarge: labelLarge.copyWith(color: AppColors.textPrimaryDark),
      labelMedium: labelMedium.copyWith(color: AppColors.textSecondaryDark),
      labelSmall: labelSmall.copyWith(color: AppColors.textSecondaryDark),
    );
  }
}
```

### App Dimensions

```dart
// theme/app_dimensions.dart

/// ابعاد و spacing های اپلیکیشن
class AppDimensions {
  // Padding & Margin
  static const double paddingTiny = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraLarge = 32.0;

  // Border Radius
  static const double borderRadiusSmall = 4.0;
  static const double borderRadius = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusExtraLarge = 16.0;

  // Button Dimensions
  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightLarge = 56.0;

  // Icon Sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconExtraLarge = 48.0;

  // Card & Container
  static const double cardElevation = 2.0;
  static const double cardElevationHigh = 8.0;
  static const double fabElevation = 6.0;

  // Responsive Breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1440.0;

  // Content Width Constraints
  static const double maxContentWidth = 1200.0;
  static const double sidebarWidth = 280.0;
  static const double sidebarWidthCollapsed = 72.0;

  // Common Heights
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 72.0;
  static const double listItemHeight = 56.0;
  static const double textFieldHeight = 48.0;

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
}
```

## 🗺️ App Router Template

```dart
// app_router.dart
import 'package:flutter/material.dart';

import '../features/auth/auth.dart';
import '../features/customer/customer.dart';
import '../features/admin/admin.dart';
import '../core/core.dart';

/// مدیریت routing اصلی اپلیکیشن
class AppRouter {
  static const String initial = '/';
  static const String login = '/login';
  static const String customerDashboard = '/customer';
  static const String adminDashboard = '/admin';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return MaterialPageRoute(
          builder: (_) => const AuthWrapper(),
          settings: settings,
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case customerDashboard:
        return MaterialPageRoute(
          builder: (_) => const CustomerDashboardScreen(),
          settings: settings,
        );

      case adminDashboard:
        return MaterialPageRoute(
          builder: (_) => const AdminDashboardScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const NotFoundScreen(),
          settings: settings,
        );
    }
  }
}

/// صفحه 404
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('صفحه یافت نشد'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            SizedBox(height: 16),
            Text(
              '۴۰۴ - صفحه یافت نشد',
              style: AppTextStyles.headlineMedium,
            ),
            SizedBox(height: 8),
            Text(
              'صفحه مورد نظر شما یافت نشد',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
```

## 📋 Export Files الزامی

### Theme Export

```dart
// theme/theme.dart
export 'app_theme.dart';
export 'app_colors.dart';
export 'app_text_styles.dart';
export 'app_dimensions.dart';
```

### App Export

```dart
// app.dart میں تمام exports
export 'app_router.dart';
export 'app_config.dart';
export 'theme/theme.dart';
```

## 🔍 Validation Rules

### قبل از تنظیم App:

1. ✅ Theme system کامل تعریف شده
2. ✅ Routing structure مشخص شده
3. ✅ Configuration values تنظیم شده
4. ✅ RTL support فعال شده
5. ✅ Responsive breakpoints تعریف شده

### App باید:

- ✅ از theme system استفاده کند
- ✅ RTL support داشته باشد
- ✅ Responsive design داشته باشد
- ✅ Error handling مناسب داشته باشد
- ✅ Performance optimized باشد

## 🎯 نکات مهم

1. **همیشه از theme system استفاده کنید**
2. **RTL support اجباری است**
3. **Responsive design الزامی است**
4. **Theme consistency حفظ شود**
5. **Color accessibility رعایت شود**
6. **Font loading optimize شود**
