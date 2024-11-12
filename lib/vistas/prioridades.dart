import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:appflowy_board/appflowy_board.dart';
import 'prioridadesScroll.dart';
import 'prioridadesBoard.dart';

class Prioridades extends StatefulWidget {
  const Prioridades({super.key});

  @override
  _PrioridadesState createState() => _PrioridadesState();
}

class _PrioridadesState extends State<Prioridades> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    const prioridadesBoard(),
    const prioridadesScroll(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart),
            label: 'Board',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Pagination (infinite scroll)',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
