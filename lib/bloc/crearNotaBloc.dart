import 'package:flutter_bloc/flutter_bloc.dart';

// Repositorio
import '../repositorios/crearNotasRepositorio.dart';

// Definir los eventos
abstract class CrearNotaEvent {}

// Evento para validar el formulario
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

// Evento para enviar el formulario
class EnviarFormulario extends CrearNotaEvent {}

// Evento para cargar opciones del Dropdown
class CargarOpcionesDropdown extends CrearNotaEvent {}

// Evento para seleccionar el estado de pago
class CambiarEstadoPago extends CrearNotaEvent {
  final String estadoPago;

  CambiarEstadoPago({required this.estadoPago});
}

// Definir los estados
abstract class CrearNotaState {}

class EstadoInicial extends CrearNotaState {
  final List<String> opcionesDropdown;
  final String estadoPago;

  EstadoInicial({
    this.opcionesDropdown = const [],
    this.estadoPago = 'Pendiente',
  });

  EstadoInicial copyWith({
    List<String>? opcionesDropdown,
    String? estadoPago,
  }) {
    return EstadoInicial(
      opcionesDropdown: opcionesDropdown ?? this.opcionesDropdown,
      estadoPago: estadoPago ?? this.estadoPago,
    );
  }
}

// Estado de formulario inválido con mensaje de error
class FormularioInvalido extends CrearNotaState {
  final String mensaje;

  FormularioInvalido(this.mensaje);
}

// Estado de formulario válido
class FormularioValido extends CrearNotaState {}

// Estado de formulario enviado
class FormularioEnviado extends CrearNotaState {}

// Bloc
class CrearNotaBloc extends Bloc<CrearNotaEvent, CrearNotaState> {
  final CrearNotasRepositorio repositorio;

  CrearNotaBloc({required this.repositorio}) : super(EstadoInicial()) {
    
    // Manejo del evento ValidarFormulario
    on<ValidarFormulario>((event, emit) {
      if (event.nombreCliente.isEmpty ||
          event.telefonoCliente.isEmpty ||
          event.fechaRecibido.isEmpty ||
          event.fechaEstimada.isEmpty ||
          event.importe.isEmpty ||
          event.estadoPago.isEmpty ||
          event.prioridad.isEmpty ||
          event.observaciones.isEmpty ||
          event.estado.isEmpty) {
        emit(FormularioInvalido('Todos los campos son obligatorios'));
      } else {
        emit(FormularioValido());
      }
    });

    // Manejo del evento EnviarFormulario
    on<EnviarFormulario>((event, emit) async {
      emit(FormularioEnviado());
    });

    // Manejo del evento CargarOpcionesDropdown
    on<CargarOpcionesDropdown>((event, emit) {
      // Obtener opciones del repositorio
      final opciones = repositorio.obtenerEstadosPago();
      emit((state as EstadoInicial).copyWith(opcionesDropdown: opciones));
    });

    // Manejo del evento CambiarEstadoPago
    on<CambiarEstadoPago>((event, emit) {
      emit((state as EstadoInicial).copyWith(estadoPago: event.estadoPago));
    });
  }

  // Método para validar el formato del teléfono
  bool esTelefonoValido(String telefono) {
    final regex = RegExp(r'^\d{10,}$');
    return regex.hasMatch(telefono);
  }

  // Método para validar el importe como número
  bool esImporteValido(String importe) {
    return double.tryParse(importe) != null;
  }
}
