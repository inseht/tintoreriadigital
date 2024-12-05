import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    cardColor: Colors.transparent,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color.fromRGBO(107, 146, 180, 1), // Un azul más suave
      brightness: Brightness.light,
    ),
    iconTheme: const IconThemeData(
      color: Color.fromRGBO(55, 75, 89, 1), // Gris más oscuro para íconos
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(107, 146, 180, 1), // Azul suave en la barra
      foregroundColor: Color.fromRGBO(55, 75, 89, 1), // Gris oscuro en el texto de la barra
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromRGBO(107, 146, 180, 1), // Azul para el botón flotante
      foregroundColor: Color.fromRGBO(255, 255, 255, 1), // Blanco en los iconos
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
      labelStyle: TextStyle(
        color: Color.fromRGBO(55, 75, 89, 1), // Azul oscuro para las etiquetas
        fontSize: 18, // Aumento el tamaño de las etiquetas
      ),
      hintStyle: TextStyle(
        color: Color.fromRGBO(55, 75, 89, 1), // Azul oscuro para los hints
        fontSize: 18, // Aumento el tamaño de los hints
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(
          fontSize: 18,  // Tamaño de la fuente del botón aumentado
        ),
      ),
    ),
    textTheme: GoogleFonts.montserratTextTheme(
      TextTheme(
        bodyMedium: TextStyle(
          fontSize: 18, // Aumento el tamaño de los textos normales
          color: Color.fromRGBO(55, 75, 89, 1), // Azul oscuro para el texto
        ),
        titleLarge: TextStyle(
          fontSize: 24, // Aumento el tamaño de los títulos
          color: Color.fromRGBO(55, 75, 89, 1), // Azul oscuro para los títulos
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
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color.fromRGBO(47, 67, 95, 1), // Un azul oscuro suave
      brightness: Brightness.dark,
    ),
    iconTheme: const IconThemeData(
      color: Color.fromRGBO(226, 244, 250, 1), // Blanco para los íconos en el modo oscuro
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(47, 67, 95, 1), // Azul oscuro en la barra
      foregroundColor: Color.fromRGBO(226, 244, 250, 1), // Blanco en el texto de la barra
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromRGBO(47, 67, 95, 1), // Azul oscuro para el botón flotante
      foregroundColor: Color.fromRGBO(226, 244, 250, 1), // Blanco en los iconos
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
      labelStyle: TextStyle(
        color: Color.fromRGBO(226, 244, 250, 1), // Blanco para las etiquetas en el modo oscuro
        fontSize: 18, // Aumento el tamaño de las etiquetas
      ),
      hintStyle: TextStyle(
        color: Color.fromRGBO(226, 244, 250, 1), // Blanco para los hints en el modo oscuro
        fontSize: 18, // Aumento el tamaño de los hints
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(
          fontSize: 18,  // Tamaño de la fuente del botón aumentado
        ),
      ),
    ),
    textTheme: GoogleFonts.montserratTextTheme(
      TextTheme(
        bodyMedium: TextStyle(
          fontSize: 18, // Aumento el tamaño de los textos normales
          color: Color.fromRGBO(55, 75, 89, 1), // Azul oscuro para el texto en el modo oscuro
        ),
        titleLarge: TextStyle(
          fontSize: 24, // Aumento el tamaño de los títulos
          color: Color.fromRGBO(55, 75, 89, 1), // Azul oscuro para los títulos
        ),
      ),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: Color.fromRGBO(55, 75, 89, 1), // Azul oscuro para el texto de las pestañas activas
      unselectedLabelColor: Color.fromRGBO(47, 67, 95, 1), // Azul más suave para las pestañas no seleccionadas
      indicatorColor: Color.fromRGBO(55, 75, 89, 1), // Azul oscuro para el indicador de la pestaña activa
    ),
  );
}
