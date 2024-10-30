import 'package:flutter/material.dart';
import 'buscar.dart';
import 'crearnota.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(), // Mueve la estructura del Scaffold a una nueva clase
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CrearNota()
                    ),
                );
              },
              child: const Text('Ir a Buscar'),
            ),
          ],
        ),
      ),
    );
  }
}
