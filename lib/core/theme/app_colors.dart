import 'package:flutter/material.dart';

class AppColors {
  // Prevent instantiation
  AppColors._();

  // Primary Colors
  static const Color primaryPurple = Color(0xFF8B5CF6);
  static const Color lightBlue = Color(0xFF38BDF8);
  static const Color warningOrange = Color(0xFFFB923C);

  // Base Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Background Colors
  static const Color scaffoldBackground = Color(0xFFF8FAFC);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color surfaceColor = Color(0xFFF1F5F9);

  // Text Colors
  static const Color textDark = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ADD THESE MISSING COLORS
  static const Color lightGray = Color(0xFFF3F4F6);
  static const Color mediumGray = Color(0xFFD1D5DB);
  static const Color darkGray = Color(0xFF6B7280); // This was missing!

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFFFBF00);
  static const Color info = Color(0xFF3B82F6);

  // Additional Colors for E-commerce
  static const Color discount = Color(0xFFDC2626);
  static const Color price = Color(0xFF059669);
  static const Color rating = Color(0xFFFBBF24);

  // Divider and Border Colors
  static const Color divider = Color(0xFFE5E7EB);
  static const Color border = Color(0xFFD1D5DB);
  static const Color borderLight = Color(0xFFF3F4F6);

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPurple, lightBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [white, scaffoldBackground],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Category Colors (for different product categories)
  static const List<Color> categoryColors = [
    Color(0xFF8B5CF6), // Purple
    Color(0xFF38BDF8), // Light Blue
    Color(0xFFFB923C), // Orange
    Color(0xFF10B981), // Green
    Color(0xFFEF4444), // Red
    Color(0xFF6366F1), // Indigo
    Color(0xFFEC4899), // Pink
    Color(0xFF14B8A6), // Teal
  ];

  // Opacity Variants
  static Color get primaryPurpleLight => primaryPurple.withOpacity(0.1);
  static Color get primaryPurpleMedium => primaryPurple.withOpacity(0.2);
  static Color get primaryPurpleHeavy => primaryPurple.withOpacity(0.8);

  static Color get lightBlueLight => lightBlue.withOpacity(0.1);
  static Color get lightBlueMedium => lightBlue.withOpacity(0.2);
  static Color get lightBlueHeavy => lightBlue.withOpacity(0.8);

  static Color get warningOrangeLight => warningOrange.withOpacity(0.1);
  static Color get warningOrangeMedium => warningOrange.withOpacity(0.2);
  static Color get warningOrangeHeavy => warningOrange.withOpacity(0.8);

  // Shimmer Colors (for loading states)
  static const Color shimmerBase = Color(0xFFE5E7EB);
  static const Color shimmerHighlight = Color(0xFFF3F4F6);

  // Dark Mode Colors (for future dark theme support)
  static const Color darkBackground = Color(0xFF111827);
  static const Color darkSurface = Color(0xFF1F2937);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFD1D5DB);

  /// Get color with custom opacity
  static Color withCustomOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  /// Get a random category color
  static Color getRandomCategoryColor(int index) {
    return categoryColors[index % categoryColors.length];
  }

  /// Get contrasting text color for a background
  static Color getContrastingTextColor(Color backgroundColor) {
    // Calculate luminance
    double luminance = backgroundColor.computeLuminance();
    // Return white text for dark backgrounds, dark text for light backgrounds
    return luminance > 0.5 ? textDark : white;
  }

  /// Material Color Swatch for Primary Purple (for ThemeData)
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF8B5CF6,
    <int, Color>{
      50: Color(0xFFF5F3FF),
      100: Color(0xFFEDE9FE),
      200: Color(0xFFDDD6FE),
      300: Color(0xFFC4B5FD),
      400: Color(0xFFA78BFA),
      500: Color(0xFF8B5CF6),
      600: Color(0xFF7C3AED),
      700: Color(0xFF6D28D9),
      800: Color(0xFF5B21B6),
      900: Color(0xFF4C1D95),
    },
  );

  /// Box Shadow Presets
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: black.withOpacity(0.08),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: primaryPurple.withOpacity(0.3),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get appBarShadow => [
    BoxShadow(
      color: black.withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  /// Border Radius Presets
  static const BorderRadius smallRadius = BorderRadius.all(Radius.circular(8));
  static const BorderRadius mediumRadius = BorderRadius.all(Radius.circular(12));
  static const BorderRadius largeRadius = BorderRadius.all(Radius.circular(16));
  static const BorderRadius extraLargeRadius = BorderRadius.all(Radius.circular(20));

  /// Common Decorations
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: white,
    borderRadius: mediumRadius,
    boxShadow: cardShadow,
  );

  static BoxDecoration get inputDecoration => BoxDecoration(
    color: white,
    borderRadius: mediumRadius,
    border: Border.all(color: borderLight),
    boxShadow: [
      BoxShadow(
        color: black.withOpacity(0.05),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration get buttonDecoration => BoxDecoration(
    color: primaryPurple,
    borderRadius: mediumRadius,
    boxShadow: buttonShadow,
  );
}
