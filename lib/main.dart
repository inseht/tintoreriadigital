import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:provider/provider.dart';
import 'package:tintoreriadigital/repositorios/proveedoresRepositorio.dart';
import 'themes/appTheme.dart';
import 'themes/themeProvider.dart';
import 'vistas/vistaPrincipal.dart';
import 'vistas/proveedores.dart';
import 'bloc/proveedoresBloc.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
        Provider<ProveedoresRepositorio>(
          create: (_) => ProveedoresRepositorio(),
        ),
        Provider<ProveedoresBloc>(
          create: (context) => ProveedoresBloc(
            context.read<ProveedoresRepositorio>(),
          ),
          dispose: (context, bloc) => bloc.close(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
            home: const MainView(),
            routes: {
              '/proveedores': (context) => const Proveedores(),             
            },
          );
        },
      ),
    );
  }
}
