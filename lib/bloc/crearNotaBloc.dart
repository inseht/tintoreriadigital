import 'package:flutter_bloc/flutter_bloc.dart';
import '../bd/bdmodel.dart';

// 1. **Estados**
abstract class CrearNotaState {}

class CrearNotaInicial extends CrearNotaState {
  final List<String> estadosNota;
  final List<String> estadosPago;
  final List<String> servicios;
  final List<String> tiposPrenda;

  CrearNotaInicial({
    this.estadosNota = const ['Recibido', 'En proceso', 'Finalizado'],
    this.estadosPago = const ['Pendiente', 'Pagado', 'Abonado'],
    this.servicios = const ['Tintorería', 'Sastrería', 'Ambos', 'Otro'],
    this.tiposPrenda = const ['Saco', 'Camisa', 'Pantalon', 'Vestido', 'Sueter', 'Traje' , 'Colcha', 'Cortina', 'Blusa', 'Otro'],
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

class NotasConPrendasState extends CrearNotaState {
  final List<Map<String, dynamic>> notasConPrendas;
  NotasConPrendasState(this.notasConPrendas);
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

class CargarNotasConPrendas extends CrearNotaEvent {}

// 3. **BLoC**
class CrearNotaBloc extends Bloc<CrearNotaEvent, CrearNotaState> {
  CrearNotaBloc() : super(CrearNotaInicial()) {
    on<ValidarFormulario>(_onValidarFormulario);
    on<EnviarFormulario>(_onEnviarFormulario);
    on<CrearPrendaSubmitted>(_onCrearPrendaSubmitted);
    on<CargarNotasConPrendas>(_onCargarNotasConPrendas);
    on<ActualizarEstadosNota>(_onActualizarEstadosNota);
    on<ActualizarEstadosPago>(_onActualizarEstadosPago);
    on<ActualizarServicios>(_onActualizarServicios);
    on<ActualizarTiposPrenda>(_onActualizarTiposPrenda);
  }

  void _onValidarFormulario(ValidarFormulario event, Emitter<CrearNotaState> emit) {
    if (event.nombreCliente.isEmpty || event.telefonoCliente.isEmpty) {
      emit(FormularioInvalido('El nombre y teléfono son requeridos'));
    } else {
      emit(FormularioValido());
    }
  }

  Future<void> _onEnviarFormulario(EnviarFormulario event, Emitter<CrearNotaState> emit) async {
    emit(CrearPrendaInProgress());
    try {
      await BdModel.crearNotaConPrendas(event.nota, event.prendas);
      emit(FormularioEnviado());
    } catch (e) {
      emit(FormularioInvalido('Error al guardar la nota: $e'));
    }
  }

  Future<void> _onCrearPrendaSubmitted(CrearPrendaSubmitted event, Emitter<CrearNotaState> emit) async {
    emit(CrearPrendaInProgress());
    try {
      await BdModel.agregarPrenda(event.prenda);
      emit(CrearPrendaSuccess());
    } catch (e) {
      emit(CrearPrendaFailure('Error al agregar la prenda: $e'));
    }
  }

  Future<void> _onCargarNotasConPrendas(CargarNotasConPrendas event, Emitter<CrearNotaState> emit) async {
    try {
      final datos = await BdModel.obtenerNotasConPrendas();
      emit(NotasConPrendasState(datos));
    } catch (e) {
      emit(FormularioInvalido('Error al cargar notas: $e'));
    }
  }

  void _onActualizarEstadosNota(ActualizarEstadosNota event, Emitter<CrearNotaState> emit) {
    final estadoActual = state as CrearNotaInicial;
    emit(CrearNotaInicial(
      estadosNota: event.nuevosEstados,
      estadosPago: estadoActual.estadosPago,
      servicios: estadoActual.servicios,
      tiposPrenda: estadoActual.tiposPrenda,
    ));
  }

  void _onActualizarEstadosPago(ActualizarEstadosPago event, Emitter<CrearNotaState> emit) {
    final estadoActual = state as CrearNotaInicial;
    emit(CrearNotaInicial(
      estadosNota: estadoActual.estadosNota,
      estadosPago: event.nuevosEstados,
      servicios: estadoActual.servicios,
      tiposPrenda: estadoActual.tiposPrenda,
    ));
  }

  void _onActualizarServicios(ActualizarServicios event, Emitter<CrearNotaState> emit) {
    final estadoActual = state as CrearNotaInicial;
    emit(CrearNotaInicial(
      estadosNota: estadoActual.estadosNota,
      estadosPago: estadoActual.estadosPago,
      servicios: event.nuevosServicios,
      tiposPrenda: estadoActual.tiposPrenda,
    ));
  }

  void _onActualizarTiposPrenda(ActualizarTiposPrenda event, Emitter<CrearNotaState> emit) {
    final estadoActual = state as CrearNotaInicial;
    emit(CrearNotaInicial(
      estadosNota: estadoActual.estadosNota,
      estadosPago: estadoActual.estadosPago,
      servicios: estadoActual.servicios,
      tiposPrenda: event.nuevosTiposPrenda,
    ));
  }
}
