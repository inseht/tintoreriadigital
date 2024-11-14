import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color.fromRGBO(167, 215, 231, 1),
      brightness: Brightness.light,
    ),
    iconTheme: const IconThemeData(
      color: Color.fromRGBO(96, 118, 124, 1),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(167, 215, 231, 1),
      foregroundColor: Color.fromRGBO(96, 118, 124, 1),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromRGBO(167, 215, 231, 1),
      foregroundColor: Color.fromRGBO(96, 118, 124, 1),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: Color.fromRGBO(96, 118, 124, 1),
      unselectedLabelColor: Color.fromRGBO(96, 118, 124, 1),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 16,
        color: Color.fromRGBO(96, 118, 124, 1),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color.fromRGBO(67, 97, 119, 1),
      brightness: Brightness.dark,
    ),
    iconTheme: const IconThemeData(
      color: Color.fromRGBO(226, 244, 250, 1),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(67, 97, 119, 1),
      foregroundColor: Color.fromRGBO(226, 244, 250, 1),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromRGBO(67, 97, 119, 1),
      foregroundColor: Color.fromRGBO(226, 244, 250, 1),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}
