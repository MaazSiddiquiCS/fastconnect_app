import 'package:flutter/material.dart';
import 'theme_colors.dart';

class AppTheme {
  // Common rounded shape for buttons, cards, and inputs
  static const _defaultRadius = BorderRadius.all(Radius.circular(12));
  static const _inputBorder = OutlineInputBorder(
    borderRadius: _defaultRadius,
    borderSide: BorderSide(color: Colors.grey, width: 1.0),
  );

  static ThemeData _baseTheme({
    required Brightness brightness,
    required Color seedColor,
    required Color scaffoldBackground,
    required Color foregroundColor,
  }) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: scaffoldBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
      ),
      fontFamily: 'Roboto',
    );

    return base.copyWith(
      // 1. AppBar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: scaffoldBackground, // Use background for a clean look
        foregroundColor: foregroundColor,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: foregroundColor,
          fontFamily: 'Roboto',
        ),
      ),

      // 2. ElevatedButton Theme (Used for primary actions like Login/Register)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          shape: const RoundedRectangleBorder(borderRadius: _defaultRadius),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // 3. InputDecoration Theme (TextFormField styling)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: base.colorScheme.surface, // Background of the text field
        border: _inputBorder,
        enabledBorder: _inputBorder.copyWith(
          borderSide: BorderSide(color: base.colorScheme.onSurface.withOpacity(0.1), width: 1.0),
        ),
        focusedBorder: _inputBorder.copyWith(
          borderSide: BorderSide(color: base.colorScheme.primary, width: 2.0),
        ),
        errorBorder: _inputBorder.copyWith(
          borderSide: BorderSide(color: base.colorScheme.error, width: 1.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      ),

      // 4. Card Theme (Used for form containers)
      cardTheme: CardThemeData(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: _defaultRadius),
        margin: EdgeInsets.zero, // Allows padding to be controlled by the parent
      ),
      
      // 5. BottomNavigationBar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: base.colorScheme.primary,
        // Use onSurfaceVariant for better contrast than generic Colors.grey
        unselectedItemColor: base.colorScheme.onSurfaceVariant, 
        type: BottomNavigationBarType.fixed,
        // FIX: Use surfaceContainerHighest for a visually elevated, less "very dark" background
        backgroundColor: base.colorScheme.surfaceContainerHighest, 
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Light Theme
  // --------------------------------------------------------------------------
  static ThemeData lightTheme = _baseTheme(
    brightness: Brightness.light,
    seedColor: ThemeColors.primary,
    scaffoldBackground: ThemeColors.lightBackground,
    foregroundColor: Colors.black87,
  );

  // --------------------------------------------------------------------------
  // Dark Theme
  // --------------------------------------------------------------------------
  static ThemeData darkTheme = _baseTheme(
    brightness: Brightness.dark,
    seedColor: ThemeColors.primaryDark,
    scaffoldBackground: ThemeColors.darkBackground,
    foregroundColor: Colors.white70,
  );
}