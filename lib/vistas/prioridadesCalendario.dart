import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tintoreriadigital/bloc/prioridadesCalendarioBloc.dart';
import 'package:intl/intl.dart';


class prioridadesCalendario extends StatefulWidget {
  const prioridadesCalendario({super.key});

  @override
  PrioridadesCalendarioState createState() => PrioridadesCalendarioState();
}

class PrioridadesCalendarioState extends State<prioridadesCalendario> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Map<String, dynamic>> _notasSeleccionadas = [];

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
            return Column(
              children: [
                Container(
                  color: Colors.grey.shade200, // Fondo gris claro para el calendario
                  child: TableCalendar(
  firstDay: DateTime.utc(2010, 10, 16),
  lastDay: DateTime.utc(2030, 3, 14),
  focusedDay: _focusedDay,
  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
  onDaySelected: (selectedDay, focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _notasSeleccionadas = state.eventos[selectedDay] ?? [];
    });
  },
  locale: "es_ES", // Idioma español
  headerStyle: const HeaderStyle(
    formatButtonVisible: false,
    titleCentered: true,
    titleTextStyle: TextStyle(
      fontSize: 20, // Letra más grande para el encabezado
      fontWeight: FontWeight.bold,
    ),
  ),
  daysOfWeekStyle: const DaysOfWeekStyle(
    weekdayStyle: TextStyle(
      fontSize: 16, // Tamaño de fuente para los días de la semana
    ),
    weekendStyle: TextStyle(
      fontSize: 16, // Tamaño de fuente para los fines de semana
    ),
  ),
  calendarStyle: const CalendarStyle(
    cellMargin: EdgeInsets.all(4),
    defaultTextStyle: TextStyle(
      fontSize: 16, // Letra más grande para los días
    ),
    weekendTextStyle: TextStyle(
      fontSize: 16, // Letra más grande para fines de semana
    ),
    selectedDecoration: BoxDecoration(
      color: Color.fromARGB(255, 72, 100, 122),
      shape: BoxShape.circle,
    ),
    todayDecoration: BoxDecoration(
      color: Color.fromARGB(255, 139, 162, 210),
      shape: BoxShape.circle,
    ),
  ),
  eventLoader: (day) => state.eventos[day] ?? [],
)

                ),
                Expanded(
                  child: _notasSeleccionadas.isEmpty
                      ? const Center(child: Text('No hay notas para este día.'))
                      : ListView.builder(
                          itemCount: _notasSeleccionadas.length,
                          itemBuilder: (context, index) {
                            final nota = _notasSeleccionadas[index];
                            Color fondoEstado = _getColorEstado(nota['estado']);
return Card(
  margin: const EdgeInsets.all(10),
  elevation: 5,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  color: Colors.grey.shade200, // Color gris claro para todas las tarjetas
  child: ListTile(
    contentPadding: const EdgeInsets.all(15),
    title: Text(
      'Nota #${nota['idNota']} - ${nota['nombreCliente']}',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Importe: ${nota['importe']}',
          style: const TextStyle(fontSize: 14),
        ),
        Text(
          'Estado: ${nota['estado']}',
          style: const TextStyle(fontSize: 14),
        ),
      ],
    ),
  ),
);

                          },
                        ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Color _getColorEstado(String estado) {
    switch (estado.toLowerCase()) {
      case 'completado':
        return Colors.green.shade200;
      case 'pendiente':
        return Colors.amber.shade200;
      case 'en proceso':
        return Colors.blue.shade200;
      default:
        return Colors.grey.shade300;
    }
  }
}
