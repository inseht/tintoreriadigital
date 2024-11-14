import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositorios/prioridadesRepositorio.dart';

abstract class PrioridadesEvent {}

class CargarNotasEvent extends PrioridadesEvent {}

abstract class PrioridadesState {}

class NotasCargadasState extends PrioridadesState {
  final List<Map<String, dynamic>> notas;
  NotasCargadasState(this.notas);
}

class PrioridadesBloc extends Bloc<PrioridadesEvent, PrioridadesState> {
  final PrioridadesRepositorio repositorio;

  PrioridadesBloc(this.repositorio) : super(NotasCargadasState([]));

  @override
  Stream<PrioridadesState> mapEventToState(PrioridadesEvent event) async* {
    if (event is CargarNotasEvent) {
      final notasConPrioridad1 = await repositorio.obtenerNotasConPrioridad1();
      final notasPendientes = await repositorio.obtenerNotasPendientes();
      final notas = [...notasConPrioridad1, ...notasPendientes];

      yield NotasCargadasState(notas);
    }
  }
}
