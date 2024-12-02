import 'package:flutter_bloc/flutter_bloc.dart';

// Estados
abstract class CrearNotaState {}

class CrearNotaInicial extends CrearNotaState {}

class FormularioValido extends CrearNotaState {}

class FormularioInvalido extends CrearNotaState {
  final String mensaje;
  FormularioInvalido(this.mensaje);
}

class FormularioEnviado extends CrearNotaState {}

class CrearPrendaInProgress extends CrearNotaState {}

class CrearPrendaSuccess extends CrearNotaState {}

class CrearPrendaFailure extends CrearNotaState {
  final String error;
  CrearPrendaFailure(this.error);
}

  List<String> obtenerEstadosPago() {
    return ['Pendiente', 'Pagado', 'Abonado'];
  }

    List<String> obtenerServicios() {
    return ['Tintorería', 'Sastrería', 'Ambos', 'Otro'];
  }

      List<String> obtenerTiposPrenda() {
    return ['Tintorería', 'Sastrería', 'Ambos', 'Otro'];
  }

// Eventos
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

class CrearPrendaSubmitted extends CrearNotaEvent {
  final Map<String, dynamic> prenda;
  CrearPrendaSubmitted(this.prenda);
}

// Bloc unificado
class CrearNotaBloc extends Bloc<CrearNotaEvent, CrearNotaState> {
  CrearNotaBloc() : super(CrearNotaInicial());

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
        yield FormularioEnviado();
      } catch (e) {
        yield FormularioInvalido('Error al guardar la nota: $e');
      }
    }

    if (event is CrearPrendaSubmitted) {
      yield CrearPrendaInProgress();
      try {
        yield CrearPrendaSuccess();
      } catch (e) {
        yield CrearPrendaFailure('Error al agregar la prenda: $e');
      }
    }
  }
}
