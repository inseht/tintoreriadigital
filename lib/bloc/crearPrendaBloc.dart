import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintoreriadigital/bd/bdmodel.dart';
// Definición de los eventos
abstract class CrearPrendaEvent {}

class CrearPrendaSubmitted extends CrearPrendaEvent {
  final Map<String, dynamic> prenda;

  CrearPrendaSubmitted(this.prenda);
}

// Definición de los estados
abstract class CrearPrendaState {}

class CrearPrendaInitial extends CrearPrendaState {}

class CrearPrendaInProgress extends CrearPrendaState {}

class CrearPrendaSuccess extends CrearPrendaState {}

class CrearPrendaFailure extends CrearPrendaState {
  final String error;

  CrearPrendaFailure(this.error);
}

// Repositorio para manejar la lógica de los datos
class CrearPrendaBloc extends Bloc<CrearPrendaEvent, CrearPrendaState> {
  CrearPrendaBloc() : super(CrearPrendaInitial());

  @override
  Stream<CrearPrendaState> mapEventToState(CrearPrendaEvent event) async* {
    if (event is CrearPrendaSubmitted) {
      yield CrearPrendaInProgress();
      try {
        // Llamada al repositorio para agregar la prenda
        await BdModel.agregarPrenda(event.prenda);
        yield CrearPrendaSuccess();
      } catch (e) {
        yield CrearPrendaFailure('Error al agregar la prenda');
      }
    }
  }
}