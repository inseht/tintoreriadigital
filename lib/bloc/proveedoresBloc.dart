import 'package:flutter_bloc/flutter_bloc.dart';
import '../bd/bdmodel.dart';

abstract class ProveedoresState {}

class ProveedoresInitial extends ProveedoresState {}

class ProveedoresLoading extends ProveedoresState {}

class ProveedoresLoaded extends ProveedoresState {
  final List<Map<String, dynamic>> proveedores;

  ProveedoresLoaded(this.proveedores);
}

class ProveedoresError extends ProveedoresState {
  final String error;

  ProveedoresError(this.error);
}

abstract class ProveedoresEvent {}

class ObtenerProveedores extends ProveedoresEvent {}

class ProveedoresBloc extends Bloc<ProveedoresEvent, ProveedoresState> {
  ProveedoresBloc() : super(ProveedoresInitial()) {
    on<ObtenerProveedores>(_onObtenerProveedores);
  }

  Future<void> _onObtenerProveedores(
      ObtenerProveedores event, Emitter<ProveedoresState> emit) async {
    emit(ProveedoresLoading());
    try {
      final proveedores = await BdModel.obtenerProveedores();
      emit(ProveedoresLoaded(proveedores));
    } catch (e) {
      emit(ProveedoresError('Error al cargar provedores $e'));
    }
  }

  
}
