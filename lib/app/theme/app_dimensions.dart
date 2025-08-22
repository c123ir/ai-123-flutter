// lib_new/app/theme/app_dimensions.dart
// ابعاد و spacing های اپلیکیشن

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
