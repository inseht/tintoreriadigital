import 'package:flutter_bloc/flutter_bloc.dart';

// 1. **Estados**

abstract class CrearNotaState {}

class CrearNotaInicial extends CrearNotaState {
  final List<String> estadosNota;
  final List<String> estadosPago;
  final List<String> servicios;
  final List<String> tiposPrenda;

  CrearNotaInicial({
    this.estadosNota = const ['Pendiente', 'En proceso', 'Finalizado'],
    this.estadosPago = const ['Pendiente', 'Pagado', 'Abonado'],
    this.servicios = const ['Tintorería', 'Sastrería', 'Ambos', 'Otro'],
    this.tiposPrenda = const ['Tintorería', 'Sastrería', 'Ambos', 'Otro'],
  });
}

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

// 2. **Eventos**

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

// Nuevos eventos para actualizar las listas
class ActualizarEstadosNota extends CrearNotaEvent {
  final List<String> nuevosEstados;
  ActualizarEstadosNota(this.nuevosEstados);
}

class ActualizarEstadosPago extends CrearNotaEvent {
  final List<String> nuevosEstados;
  ActualizarEstadosPago(this.nuevosEstados);
}

class ActualizarServicios extends CrearNotaEvent {
  final List<String> nuevosServicios;
  ActualizarServicios(this.nuevosServicios);
}

class ActualizarTiposPrenda extends CrearNotaEvent {
  final List<String> nuevosTiposPrenda;
  ActualizarTiposPrenda(this.nuevosTiposPrenda);
}
// 3. **BLoC**

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

    // Manejo de la lógica para el envío del formulario
    if (event is EnviarFormulario) {
      try {
        // Aquí puedes agregar la lógica para guardar los datos
        // Por ejemplo, podrías hacer algo como esto:
        await _guardarNota(event.nota, event.prendas); // Llamada a un método que guarda los datos
        yield FormularioEnviado(); // Emitir el estado de éxito
      } catch (e) {
        yield FormularioInvalido('Error al guardar la nota: $e'); // Si ocurre un error
      }
    }

    // Lógica para el manejo de prendas
    if (event is CrearPrendaSubmitted) {
      yield CrearPrendaInProgress();
      try {
        // Aquí iría la lógica para crear la prenda
        yield CrearPrendaSuccess();
      } catch (e) {
        yield CrearPrendaFailure('Error al agregar la prenda: $e');
      }
    }

    // Manejo de la actualización de los estadosNota
    if (event is ActualizarEstadosNota) {
      yield CrearNotaInicial(
        estadosNota: event.nuevosEstados, // Actualiza la lista de estadosNota
        estadosPago: (state as CrearNotaInicial).estadosPago, // Mantiene los demás valores
        servicios: (state as CrearNotaInicial).servicios,
        tiposPrenda: (state as CrearNotaInicial).tiposPrenda,
      );
    }

    // Manejo de la actualización de los estadosPago
    if (event is ActualizarEstadosPago) {
      yield CrearNotaInicial(
        estadosPago: event.nuevosEstados,
        estadosNota: (state as CrearNotaInicial).estadosNota,
        servicios: (state as CrearNotaInicial).servicios,
        tiposPrenda: (state as CrearNotaInicial).tiposPrenda,
      );
    }

    // Manejo de la actualización de los servicios
    if (event is ActualizarServicios) {
      yield CrearNotaInicial(
        servicios: event.nuevosServicios,
        estadosPago: (state as CrearNotaInicial).estadosPago,
        estadosNota: (state as CrearNotaInicial).estadosNota,
        tiposPrenda: (state as CrearNotaInicial).tiposPrenda,
      );
    }

    // Manejo de la actualización de los tiposPrenda
    if (event is ActualizarTiposPrenda) {
      yield CrearNotaInicial(
        tiposPrenda: event.nuevosTiposPrenda,
        estadosPago: (state as CrearNotaInicial).estadosPago,
        servicios: (state as CrearNotaInicial).servicios,
        estadosNota: (state as CrearNotaInicial).estadosNota,
      );
    }
  }

  // Método para guardar los datos en una base de datos (simulado)
  Future<void> _guardarNota(Map<String, dynamic> nota, List<Map<String, dynamic>> prendas) async {
    // Aquí se guardaría la nota y las prendas, por ejemplo, en una base de datos
    await Future.delayed(Duration(seconds: 2)); // Simula el tiempo de guardado
    print('Nota guardada: $nota');
    print('Prendas: $prendas');
  }
}
