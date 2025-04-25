import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF3B82F6);
  static const Color accentColor = Color(0xFF10B981);
  static const Color backgroundColor = Color(0xFF121212);
  static const Color cardColor = Color(0xFF1E1E1E);
  static const Color textColor = Color(0xFFF3F4F6);
  static const Color subtextColor = Color(0xFF9CA3AF);
  static const Color borderColor = Color(0xFF2A2A2A);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color notificationColor = Color(0xFFEF4444);

  // Light Theme Colors
  static const Color lightBackgroundColor = Color(0xFFFFFFFF);
  static const Color lightCardColor = Color(0xFFF3F4F6);
  static const Color lightTextColor = Color(0xFF1F2937);
  static const Color lightSubtextColor = Color(0xFF6B7280);
  static const Color lightBorderColor = Color(0xFFE5E7EB);

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textColor,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: textColor,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 12,
    color: subtextColor,
  );

  // Light Theme Text Styles
  static TextStyle get lightHeadingStyle => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: lightTextColor,
      );

  static TextStyle get lightTitleStyle => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: lightTextColor,
      );

  static TextStyle get lightSubtitleStyle => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: lightTextColor,
      );

  static TextStyle get lightBodyStyle => GoogleFonts.inter(
        fontSize: 14,
        color: lightTextColor,
      );

  static TextStyle get lightCaptionStyle => GoogleFonts.inter(
        fontSize: 12,
        color: lightSubtextColor,
      );

  // Theme Data
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: lightBackgroundColor,
    cardColor: lightCardColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      surface: lightCardColor,
      error: errorColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: lightBackgroundColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: lightTitleStyle,
      iconTheme: const IconThemeData(color: lightTextColor),
    ),
    textTheme: TextTheme(
      displayLarge: lightHeadingStyle,
      displayMedium: lightTitleStyle,
      bodyLarge: lightSubtitleStyle,
      bodyMedium: lightBodyStyle,
      bodySmall: lightCaptionStyle,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightCardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: lightCaptionStyle,
    ),
    cardTheme: CardTheme(
      color: lightCardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: lightBorderColor,
      thickness: 1,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: lightBackgroundColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: lightSubtextColor,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
  );
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      surface: cardColor,
      error: errorColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: titleStyle,
      iconTheme: IconThemeData(color: textColor),
    ),
    textTheme: const TextTheme(
      displayLarge: headingStyle,
      displayMedium: titleStyle,
      bodyLarge: subtitleStyle,
      bodyMedium: bodyStyle,
      bodySmall: captionStyle,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: captionStyle,
    ),
    cardTheme: CardTheme(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: borderColor,
      thickness: 1,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: backgroundColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: subtextColor,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
  );
}
