import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintoreriadigital/repositorios/crearNotasRepositorio.dart';

abstract class CrearNotaState {}

class CrearNotaInicial extends CrearNotaState {}

class FormularioValido extends CrearNotaState {}

class FormularioInvalido extends CrearNotaState {
  final String mensaje;
  FormularioInvalido(this.mensaje);
}

class FormularioEnviado extends CrearNotaState {}

abstract class CrearNotaEvent {}

class ValidarFormulario extends CrearNotaEvent {
  final String nombreCliente;
  final String telefonoCliente;
  final String fechaRecibido;
  final String fechaEstimada;
  final String importe;
  final String estadoPago;
  final String prioridad;
  final String observaciones;
  final String estado;

  ValidarFormulario({
    required this.nombreCliente,
    required this.telefonoCliente,
    required this.fechaRecibido,
    required this.fechaEstimada,
    required this.importe,
    required this.estadoPago,
    required this.prioridad,
    required this.observaciones,
    required this.estado,
  });
}

class EnviarFormulario extends CrearNotaEvent {
  final Map<String, dynamic> nota;
  final List<Map<String, dynamic>> prendas;
  EnviarFormulario({required this.nota, required this.prendas});
}


class CrearNotaBloc extends Bloc<CrearNotaEvent, CrearNotaState> {
  final CrearNotasRepositorio repositorio;

  CrearNotaBloc({required this.repositorio}) : super(CrearNotaInicial());

  @override
  Stream<CrearNotaState> mapEventToState(CrearNotaEvent event) async* {
    if (event is ValidarFormulario) {
      if (event.nombreCliente.isEmpty || event.telefonoCliente.isEmpty) {
        yield FormularioInvalido('El nombre y teléfono son requeridos');
      } else {
        yield FormularioValido();
      }
    }

    if (event is EnviarFormulario) {
      try {
        await repositorio.crearNotaConPrendas(event.nota, event.prendas);
        yield FormularioEnviado();
      } catch (e) {
        yield FormularioInvalido('Error al guardar la nota: $e');
      }
    }
  }
}
