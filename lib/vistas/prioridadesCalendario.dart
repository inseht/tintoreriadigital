import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class prioridadesCalendario extends StatefulWidget {
  const prioridadesCalendario({super.key});

  @override
  State<prioridadesCalendario> createState() => _PrioridadesCalendarioState();
}

class _PrioridadesCalendarioState extends State<prioridadesCalendario> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Color.fromARGB(255, 72, 100, 122),
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Color.fromARGB(255, 159, 187, 249),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
