// lib_new/app/theme/app_text_styles.dart
// استایل‌های متن اپلیکیشن

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
