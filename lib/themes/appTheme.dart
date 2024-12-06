import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    cardColor: Colors.transparent,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color.fromRGBO(107, 146, 180, 1), 
      brightness: Brightness.light,
    ),
    iconTheme: const IconThemeData(
      color: Color.fromRGBO(55, 75, 89, 1), 
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(107, 146, 180, 1),
      foregroundColor: Color.fromRGBO(55, 75, 89, 1), 
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromRGBO(107, 146, 180, 1),
      foregroundColor: Color.fromRGBO(255, 255, 255, 1), 
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
      labelStyle: TextStyle(
        color: Color.fromRGBO(55, 75, 89, 1), 
        fontSize: 18,
      ),
      hintStyle: TextStyle(
        color: Color.fromRGBO(55, 75, 89, 1),
        fontSize: 18,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(
          fontSize: 18,
        ),
      ),
    ),
    textTheme: GoogleFonts.montserratTextTheme(
      TextTheme(
        bodyMedium: TextStyle(
          fontSize: 18,
          color: Color.fromRGBO(55, 75, 89, 1),
        ),
        titleLarge: TextStyle(
          fontSize: 24,
          color: Color.fromRGBO(55, 75, 89, 1),
        ),
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: Color.fromARGB(255, 32, 44, 53), // Color para los íconos activos
      unselectedLabelColor: Color.fromRGBO(55, 75, 89, 1), // Color para los íconos no activos
      indicatorColor: Color.fromRGBO(55, 75, 89, 1), // Color para el indicador de la pestaña activa
    ),
  );

  static final ThemeData darkTheme = ThemeData(

  );
}
