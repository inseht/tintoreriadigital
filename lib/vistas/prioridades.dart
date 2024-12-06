import 'package:flutter/material.dart';
import 'prioridadesCalendario.dart';
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
    const prioridadesCalendario(),
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
  bottomNavigationBar: Container(
    height: 80.0,
    child: BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          label: 'Tablero',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          label: 'Calendario',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedLabelStyle: TextStyle(
        fontSize: 18.0, 
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 16.0,
      ),
      iconSize: 30.0,
    ),
  ),
);

  }
}