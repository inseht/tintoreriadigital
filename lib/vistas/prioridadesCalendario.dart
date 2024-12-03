import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import '../bloc/prioridadesCalendarioBloc.dart';

class prioridadesCalendario extends StatefulWidget {
  const prioridadesCalendario({super.key});

  @override
  _PrioridadesCalendarioState createState() => _PrioridadesCalendarioState();
}

class _PrioridadesCalendarioState extends State<prioridadesCalendario> {
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
                TableCalendar(
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
                  eventLoader: (day) => state.eventos[day] ?? [],
                ),
                Expanded(
                  child: _notasSeleccionadas.isEmpty
                      ? const Center(child: Text('No hay notas para este día.'))
                      : ListView.builder(
                          itemCount: _notasSeleccionadas.length,
                          itemBuilder: (context, index) {
                            final nota = _notasSeleccionadas[index];
                            return ListTile(
                              title: Text(
                                  'Nota #${nota['idNota']} - ${nota['nombreCliente']}'),
                              subtitle: Text(
                                'Importe: ${nota['importe']}\nEstado: ${nota['estado']}\nFecha: ${nota['fechaRecibido']}',
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
}
