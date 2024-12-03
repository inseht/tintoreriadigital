import 'package:flutter_bloc/flutter_bloc.dart';
import '../bd/bdmodel.dart';
import 'package:intl/intl.dart';

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
    final notas = await BdModel.obtenerNotas(); // Obtener todas las notas
    final notasFiltradas = notas.where((nota) => 
      nota['prioridad'] == 1 || nota['estado'] == 'Pendiente').toList();

    final Map<DateTime, List<Map<String, dynamic>>> eventos = {};

    for (final nota in notasFiltradas) {
      // Convertir la fecha desde String (si es necesario)
      final fechaString = nota['fechaRecibido'];
      final fecha = DateFormat('dd/MM/yyyy').parse(fechaString);

      // Agregar eventos a la fecha en el mapa
      if (eventos[fecha] == null) {
        eventos[fecha] = [];
      }
      eventos[fecha]!.add(nota);
    }

    emit(FechasCargadasState(eventos));
  }
}
