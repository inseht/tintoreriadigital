import 'package:flutter/material.dart';
import 'buscar.dart';
import 'crearnota.dart';
import 'prioridades.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.search), text: 'Buscar'),
            Tab(icon: Icon(Icons.note_add), text: 'Crear Nota'),
            Tab(icon: Icon(Icons.priority_high), text: 'Prioridades'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Buscar(),
          CrearNota(),
          Prioridades(),
        ],
      ),
    );
  }
}
