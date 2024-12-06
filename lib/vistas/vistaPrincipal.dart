import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tintoreriadigital/themes/themeProvider.dart';
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

  void _cambiarTab(int index) {
    setState(() {
      _tabController.index = index; // Cambia la pestaña activa
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
  title: Text(
    'Tintorería Digital',
    style: GoogleFonts.lexend(
      color: const Color.fromRGBO(226, 244, 250, 1),
      fontSize: 40,
    ),
  ),
  bottom: PreferredSize(
    preferredSize: Size.fromHeight(100.0), // Ajusta la altura aquí
    child: TabBar(
      controller: _tabController,
      tabs: [
        Tab(
          icon: Icon(
            Icons.developer_board,
            size: 35,
          ),
          child: Text(
            'Prioridades',
            style: TextStyle(fontSize: 24),
          ),
        ),
        Tab(
          icon: Icon(
            Icons.search,
            size: 35,
          ),
          child: Text(
            'Buscar',
            style: TextStyle(fontSize: 24),
          ),
        ),
        Tab(
          icon: Icon(
            Icons.note_add,
            size: 35,
          ),
          child: Text(
            'Crear Nota',
            style: TextStyle(fontSize: 24),
          ),
        ),
        Tab(
          icon: Icon(
            Icons.contact_phone_outlined,
            size: 35,
          ),
          child: Text(
            'Proveedores',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ],
    ),
  ),
),

      body: TabBarView(
        controller: _tabController,
        children: [
          const Prioridades(),
          Buscar(), // Pasar _cambiarTab aquí
          const CrearNota(),
          const Proveedores(),
        ],
      ),
    );
  }
}
