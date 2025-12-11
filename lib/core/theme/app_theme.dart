import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Premium Color Palette
  static const Color _primaryColor = Color(0xFF962D3E); // Wine Red
  static const Color _onPrimaryColor = Colors.white;
  static const Color _secondaryColor = Color(0xFF343A40); // Dark Grey/Charcoal
  static const Color _accentColor = Color(0xFFD4AF37); // Gold/Brass for accents
  static const Color _backgroundColor = Color(0xFFF8F9FA); // Off-white
  static const Color _surfaceColor = Colors.white;
  static const Color _errorColor = Color(0xFFD32F2F);
  static const Color _onErrorColor = Colors.white;
  
  static const Color _textColor = Color(0xFF212529);
  static const Color _subTextColor = Color(0xFF6C757D);
  static const Color _dividerColor = Color(0xFFDEE2E6);

  static final ColorScheme _lightColorScheme = ColorScheme.light(
    primary: _primaryColor,
    onPrimary: _onPrimaryColor,
    secondary: _secondaryColor,
    tertiary: _accentColor,
    surface: _surfaceColor,
    onSurface: _textColor,
    error: _errorColor,
    onError: _onErrorColor,
  );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: _lightColorScheme,
    scaffoldBackgroundColor: _backgroundColor,
    primaryColor: _primaryColor,
    dividerColor: _dividerColor,
    
    // Typography
    textTheme: TextTheme(
      displayLarge: GoogleFonts.outfit(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        color: _textColor,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.outfit(
        fontSize: 45,
        fontWeight: FontWeight.w600,
        color: _textColor,
      ),
      displaySmall: GoogleFonts.outfit(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: _textColor,
      ),
      headlineLarge: GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: _textColor,
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: _textColor,
      ),
      headlineSmall: GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: _textColor,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: _textColor,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: _textColor,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: _textColor,
        letterSpacing: 0.1,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: _textColor,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: _textColor,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: _subTextColor,
        letterSpacing: 0.4,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: _textColor,
        letterSpacing: 0.1,
      ),
    ),

    // App Bar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: _primaryColor,
      foregroundColor: _onPrimaryColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: _onPrimaryColor,
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.shade100,
          width: 1,
        ),
      ),
      margin: const EdgeInsets.only(bottom: 16),
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: _primaryColor.withValues(alpha: 0.3),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // Inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primaryColor, width: 2),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: _errorColor, width: 1),
      ),
    ),
    
    // Icon Theme
    iconTheme: const IconThemeData(
      color: _secondaryColor,
      size: 24,
    ),

    // Navigation Bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: _surfaceColor,
      selectedItemColor: _primaryColor,
      unselectedItemColor: _subTextColor,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
