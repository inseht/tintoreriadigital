import 'package:flutter_bloc/flutter_bloc.dart';
import '../bd/bdmodel.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';
import 'package:flutter/material.dart';

abstract class CalendarioEvent {}

class CargarFechasConPrioridad extends CalendarioEvent {}

abstract class CalendarioState {}

class FechasCargadasState extends CalendarioState {
  final Map<DateTime, List<Map<String, dynamic>>> eventos;
  FechasCargadasState(this.eventos);
}

class CalendarioBloc extends Bloc<CalendarioEvent, CalendarioState> {
  CalendarioBloc() : super(FechasCargadasState({})) {
    on<CargarFechasConPrioridad>(_onCargarFechas);
  }

  Future<void> _onCargarFechas(
      CargarFechasConPrioridad event, Emitter<CalendarioState> emit) async {
    try {
      final notas = await BdModel.obtenerNotas();
      final notasFiltradas = notas.where((nota) =>
          nota['prioridad'] == 1 || nota['estado'] == 'Pendiente').toList();

      final eventos = LinkedHashMap<DateTime, List<Map<String, dynamic>>>( 
        equals: isSameDay,
        hashCode: (key) => key.day + key.month * 100 + key.year * 10000,
      );

      for (final nota in notasFiltradas) {
        final fechaRecibido = nota['fechaRecibido']; 
        try {
          final fecha = fechaRecibido as DateTime;
          eventos.putIfAbsent(fecha, () => []).add(nota);
        } catch (e) {
          print('Error al procesar la fecha: $fechaRecibido - Error: $e');
        }
      }

      emit(FechasCargadasState(eventos));
    } catch (e) {
      print('Error al cargar fechas con prioridad: $e');
    }
  }
}

class CalendarioWidget extends StatelessWidget {
  final Map<DateTime, List<Map<String, dynamic>>> eventos;

  const CalendarioWidget({super.key, required this.eventos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendario de Eventos')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: DateTime.now(),
            locale: 'es_ES',  
            eventLoader: (day) {
              return eventos[day] ?? [];
            },
            headerStyle: HeaderStyle(
              titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              formatButtonVisible: false, 
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue, shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.orange, shape: BoxShape.circle,
              ),
              markersMaxCount: 3,
            ),
            onDaySelected: (selectedDay, focusedDay) {
              print('Día seleccionado: $selectedDay');
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: eventos.length,
              itemBuilder: (context, index) {
                final fecha = eventos.keys.elementAt(index);
                final eventoList = eventos[fecha]!;
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(
                      DateFormat('d MMM y', 'es_ES').format(fecha),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: eventoList.map((evento) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Text(
                            '• ${evento['titulo']} - ${evento['estado']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    leading: Icon(Icons.event, color: Colors.blue),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
