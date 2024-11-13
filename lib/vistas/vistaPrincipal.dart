import 'package:flutter/material.dart';
import 'buscar.dart';
import 'crearNota.dart';
import 'prioridades.dart';
import 'proveedores.dart';
import 'package:google_fonts/google_fonts.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
title: Text(
  'Tintorería Digital',
  style: GoogleFonts.anton(
    color: Colors.white,
    fontSize:40,
  ),
),



        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.search), text: 'Buscar'),
            Tab(icon: Icon(Icons.note_add), text: 'Crear Nota'),
            Tab(icon: Icon(Icons.priority_high), text: 'Prioridades'),
            Tab(icon: Icon(Icons.contact_phone_outlined), text: 'Proveedores'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Buscar(),
          CrearNota(),
          Prioridades(),
          Proveedores()
        ],
      ),
    );
  }
}
