import 'package:flutter/material.dart';
import 'theme_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: ThemeColors.lightBackground,
    colorScheme: ColorScheme.fromSeed(seedColor: ThemeColors.primary),
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black87,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ThemeColors.darkBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ThemeColors.primaryDark,
      brightness: Brightness.dark,
    ),
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white70,
    ),
  );
}
