import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import '../bloc/prioridadesCalendarioBloc.dart';  // Asegúrate de tener el import correcto

class prioridadesCalendario extends StatefulWidget {
  const prioridadesCalendario({super.key});

  @override
  _PrioridadesCalendarioState createState() => _PrioridadesCalendarioState();
}

class _PrioridadesCalendarioState extends State<prioridadesCalendario> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    context.read<CalendarioBloc>().add(CargarFechasConPrioridad());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CalendarioBloc, CalendarioState>(
        builder: (context, state) {
          if (state is FechasCargadasState) {
            return TableCalendar(
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
              eventLoader: (day) {
                return state.eventos[day] ?? [];
              },
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 72, 100, 122),
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 159, 187, 249),
                  shape: BoxShape.circle,
                ),
                markersMaxCount: 3, // Limitar la cantidad de eventos por día
                markerDecoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}