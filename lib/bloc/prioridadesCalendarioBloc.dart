import 'package:flutter_bloc/flutter_bloc.dart';
import '../bd/bdmodel.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';

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
      // 1. Obtener notas de la base de datos.
      final notas = await BdModel.obtenerNotas();
      final notasFiltradas = notas.where((nota) =>
          nota['prioridad'] == 1 || nota['estado'] == 'Pendiente').toList();

      // 2. Crear el mapa de eventos usando LinkedHashMap con comparación personalizada.
      final eventos = LinkedHashMap<DateTime, List<Map<String, dynamic>>>(
        equals: isSameDay,
        hashCode: (key) => key.day + key.month * 100 + key.year * 10000,
      );

      // 3. Iterar sobre las notas y agregar al mapa.
      for (final nota in notasFiltradas) {
        final fechaString = nota['fechaRecibido']; // Formato "dd/MM/yyyy"
        try {
          final fecha = DateFormat('dd/MM/yyyy').parse(fechaString);
          if (eventos[fecha] == null) {
            eventos[fecha] = [];
          }
          eventos[fecha]!.add(nota);
        } catch (e) {
          print('Error al parsear la fecha: $fechaString');
        }
      }

      // 4. Emitir el estado con los eventos cargados.
      emit(FechasCargadasState(eventos));
    } catch (e) {
      print('Error al cargar fechas con prioridad: $e');
    }
  }
}
