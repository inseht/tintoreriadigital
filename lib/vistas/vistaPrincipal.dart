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

  @override
  Widget build(BuildContext context) {
final themeProvider = Provider.of<ThemeProvider>(context);


    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tintorería Digital',
            style: GoogleFonts.lexend(
            color: Color.fromRGBO(226, 244, 250, 1),
            fontSize: 40,
          ),
        ),
        actions: [
          IconButton(
            isSelected: themeProvider.isDark,
            icon: const Icon(Icons.wb_sunny_outlined),
            selectedIcon: const Icon(Icons.brightness_2_outlined),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.developer_board), text: 'Prioridades'),
            Tab(icon: Icon(Icons.search), text: 'Buscar'),
            Tab(icon: Icon(Icons.note_add), text: 'Crear Nota'),
            Tab(icon: Icon(Icons.contact_phone_outlined), text: 'Proveedores'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Prioridades(),
          Buscar(),
          CrearNota(),
          Proveedores(),
        ],
      ),
    );
  }
}
