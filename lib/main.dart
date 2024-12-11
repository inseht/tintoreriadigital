import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'themes/appTheme.dart';
import 'themes/themeProvider.dart';
import 'vistas/vistaPrincipal.dart';
import 'vistas/proveedores.dart';
import 'vistas/prioridadesBoard.dart';
import 'bloc/proveedoresBloc.dart';
import 'bloc/prioridadesBloc.dart';
import 'bloc/crearNotaBloc.dart';
import 'bloc/prioridadesCalendarioBloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
    return ScreenUtilInit(
      designSize: const Size(360, 690), 
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
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
              BlocProvider<CrearNotaBloc>(
                create: (_) => CrearNotaBloc(),
              ),
              BlocProvider<CalendarioBloc>(
                create: (_) => CalendarioBloc(),
              ),
            ],
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return MaterialApp(
                  theme: AppTheme.lightTheme,
                  home: const MainView(),
                  routes: {
                    '/proveedores': (context) => const Proveedores(),
                    '/prioridades': (context) => prioridadesBoard(),
                  },
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: const [
                    Locale('es', 'ES'), // Español
                  ],
                  locale: const Locale('es', 'ES'),
                );
              },
            ),
          ),
        );
      },
    );
  }
}