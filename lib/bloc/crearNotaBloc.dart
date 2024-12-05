import 'package:flutter_bloc/flutter_bloc.dart';
import '../bd/bdmodel.dart';

// 1. **Estados**
abstract class CrearNotaState {}

class CrearNotaInicial extends CrearNotaState {
  final List<String> estadosNota;
  final List<String> estadosPago;
  final List<String> servicios;
  final List<String> colores;
  final List<String> tiposPrenda;

  CrearNotaInicial({
    this.estadosNota = const ['Recibido', 'En proceso', 'Finalizado'],
    this.estadosPago = const ['Pendiente', 'Pagado', 'Abonado'],
    this.servicios = const ['Tintorería', 'Sastrería', 'Ambos', 'Otro'],
    this.colores = const ['Rojo', 'Verde', 'Azul', 'Negro', 'Marrón', 'Amarillo', 'Blanco', 'Gris', 'Otro'],
    this.tiposPrenda = const ['Saco', 'Camisa', 'Pantalon', 'Vestido', 'Sueter', 'Traje', 'Colcha', 'Cortina', 'Blusa', 'Otro'],
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

class EliminarNota extends CrearNotaEvent {
  final int idNota;
  EliminarNota(this.idNota);
}

class ActualizarNota extends CrearNotaEvent {
  final int idNota;
  final Map<String, dynamic> nuevaNota;
  ActualizarNota({required this.idNota, required this.nuevaNota});
}

class ActualizarPrenda extends CrearNotaEvent {
  final int idPrenda;
  final Map<String, dynamic> nuevaPrenda;
  ActualizarPrenda({required this.idPrenda, required this.nuevaPrenda});
}

class CargarNotasConPrendas extends CrearNotaEvent {}

// 3. **BLoC**
class CrearNotaBloc extends Bloc<CrearNotaEvent, CrearNotaState> {
  CrearNotaBloc() : super(CrearNotaInicial()) {
    on<ValidarFormulario>(_onValidarFormulario);
    on<EnviarFormulario>(_onEnviarFormulario);
    on<CrearPrendaSubmitted>(_onCrearPrendaSubmitted);
    on<EliminarNota>(_onEliminarNota);
    on<ActualizarNota>(_onActualizarNota);
    on<ActualizarPrenda>(_onActualizarPrenda);
    on<CargarNotasConPrendas>(_onCargarNotasConPrendas);
  }

  void _onValidarFormulario(ValidarFormulario event, Emitter<CrearNotaState> emit) {
    if (event.nombreCliente.isEmpty || event.telefonoCliente.isEmpty) {
      emit(FormularioInvalido('El nombre y teléfono son requeridos.'));
    } else if (!RegExp(r'^\d+$').hasMatch(event.telefonoCliente)) {
      emit(FormularioInvalido('El teléfono debe contener sólo números.'));
    } else if (DateTime.parse(event.fechaEstimada).isBefore(DateTime.parse(event.fechaRecibido))) {
      emit(FormularioInvalido('La fecha estimada no puede ser anterior a la fecha recibida.'));
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

  Future<void> _onEliminarNota(EliminarNota event, Emitter<CrearNotaState> emit) async {
    try {
      await BdModel.eliminarNota(event.idNota);
      emit(FormularioEnviado());  // Aquí puedes emitir un estado de éxito o hacer algo para actualizar la vista
    } catch (e) {
      emit(FormularioInvalido('Error al eliminar la nota: $e'));
    }
  }

  Future<void> _onActualizarNota(ActualizarNota event, Emitter<CrearNotaState> emit) async {
    try {
      await BdModel.actualizarNota(event.idNota, event.nuevaNota);
      emit(FormularioEnviado());
    } catch (e) {
      emit(FormularioInvalido('Error al actualizar la nota: $e'));
    }
  }

  Future<void> _onActualizarPrenda(ActualizarPrenda event, Emitter<CrearNotaState> emit) async {
    try {
      await BdModel.actualizarPrenda(event.idPrenda, event.nuevaPrenda);
      emit(CrearPrendaSuccess());
    } catch (e) {
      emit(CrearPrendaFailure('Error al actualizar la prenda: $e'));
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
}
