import 'package:flutter/material.dart';

class AppTheme {
  // Modo claro
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color.fromRGBO(167, 215, 231, 1),
      brightness: Brightness.light,
    ),
    iconTheme: const IconThemeData(
      color: Color.fromRGBO(226, 244, 250, 1), 
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(167, 215, 231, 1),
      foregroundColor: Color.fromRGBO(226, 244, 250, 1),
      iconTheme: IconThemeData(
      color: Color.fromRGBO(226, 244, 250, 1), 
    ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromRGBO(167, 215, 231, 1),
      foregroundColor: Color.fromRGBO(226, 244, 250, 1),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: Color.fromRGBO(226, 244, 250, 1), 
      unselectedLabelColor: Color.fromRGBO(96, 118, 124, 1),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
      color: Color.fromRGBO(167, 215, 231, 1),
      width: 2.0,
    ),
  ),
),

  );

  // Modo oscuro
  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color.fromRGBO(167, 215, 231, 1),
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(167, 215, 231, 1),
      foregroundColor: Color.fromRGBO(226, 244, 250, 1),
          iconTheme: IconThemeData(
      color: Color.fromRGBO(226, 244, 250, 1), 
    ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromRGBO(167, 215, 231, 1),
      foregroundColor: Color.fromRGBO(135, 164, 173, 1),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}
