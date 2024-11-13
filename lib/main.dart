import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:provider/provider.dart';
import 'themes/appTheme.dart';
import 'themes/themeProvider.dart';
import 'vistas/vistaPrincipal.dart';
import 'vistas/proveedores.dart';
import 'vistas/agregarProveedor.dart';

void main() {
  runApp(const MainApp());
  doWhenWindowReady(() {
    final win = appWindow;
    win
      ..title = "Tintoreria Digital"
      ..maximize()
      ..show();
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
            home: const MainView(),
            routes: {
              '/proveedores': (context) => const Proveedores(),
              '/agregarProveedor': (context) => const agregarProveedor(),
            },
          );
        },
      ),
    );
  }
}
