import 'package:flutter_bloc/flutter_bloc.dart';

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

// Definir los estados
abstract class CrearNotaState {}

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
  CrearNotaBloc() : super(FormularioInvalido('')) {
    
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
      // Simulación de operación asincrónica (ejemplo: llamada a una API)
      emit(FormularioEnviado());
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
