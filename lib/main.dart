import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'themes/appTheme.dart';
import 'themes/themeProvider.dart';
import 'vistas/vistaPrincipal.dart';
import 'vistas/proveedores.dart';
import 'vistas/prioridadesBoard.dart';
import 'bloc/proveedoresBloc.dart';
import 'bloc/prioridadesBloc.dart';
import 'bloc/crearNotaBloc.dart';

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
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ProveedoresBloc>(
            create: (_) => ProveedoresBloc(),
          ),
          BlocProvider<PrioridadesBloc>(
            create: (_) => PrioridadesBloc(),
          ),
          // Añadiendo CrearNotaBloc
          BlocProvider<CrearNotaBloc>(
            create: (_) => CrearNotaBloc(),
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
                '/prioridades': (context) => const prioridadesBoard(),
              },
            );
          },
        ),
      ),
    );
  }
}

