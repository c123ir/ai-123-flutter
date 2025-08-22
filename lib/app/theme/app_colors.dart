// lib_new/app/theme/app_colors.dart
// رنگ‌های اپلیکیشن

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
    colors: [Color(0xFFE3F2FD), Color(0xFFF3E5F5), Color(0xFFE8F5E8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
