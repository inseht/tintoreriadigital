import '../bd/bdmodel.dart';

class CrearNotasRepositorio {
  Future<void> crearNota(Map<String, dynamic> nota) async {
    await BdModel.crearNota(nota);
  }

  List<String> obtenerEstadosPago() {
    return ['Pendiente', 'Pagado', 'Abonado'];
  }
}


