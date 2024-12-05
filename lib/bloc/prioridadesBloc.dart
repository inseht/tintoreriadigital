import 'package:flutter_bloc/flutter_bloc.dart';
import '../bd/bdmodel.dart';

abstract class PrioridadesEvent {}

class CargarNotasEvent extends PrioridadesEvent {}

abstract class PrioridadesState {}

class NotasCargadasState extends PrioridadesState {
  final List<Map<String, dynamic>> notas;
  NotasCargadasState(this.notas);
}

class PrioridadesBloc extends Bloc<PrioridadesEvent, PrioridadesState> {
  PrioridadesBloc() : super(NotasCargadasState([])) {
    on<CargarNotasEvent>(_onCargarNotas);
  }

Future<void> _onCargarNotas(CargarNotasEvent event, Emitter<PrioridadesState> emit) async {
  final notasConPrioridad1 = await BdModel.obtenerNotas();
  final notas = notasConPrioridad1
      .where((nota) => nota['prioridad'] == 1 || nota['estado'] == 'Pendiente')
      .toList();
  emit(NotasCargadasState(notas));
}




}
