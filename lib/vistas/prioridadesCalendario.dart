import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

class prioridadesCalendario extends StatelessWidget {
  const prioridadesCalendario({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: DateTime.now(),
          headerStyle: HeaderStyle(
            formatButtonVisible: false, // Oculta el botón de formato del calendario
            titleCentered: true, // Centra el título del mes
            leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black), // Estilo del icono de flecha izquierda
            rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black), // Estilo del icono de flecha derecha
          ),
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Colors.blue, // Color de la fecha seleccionada
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Colors.orange, // Color de la fecha de hoy
              shape: BoxShape.circle,
            ),
            outsideDecoration: BoxDecoration(
              color: Colors.transparent, // Color para días fuera del mes actual
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
