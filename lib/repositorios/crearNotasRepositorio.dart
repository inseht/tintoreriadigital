import '../bd/bdmodel.dart';

class CrearNotasRepositorio {
  Future<void> crearNotaConPrendas(Map<String, dynamic> nota, List<Map<String, dynamic>> prendas) async {
    await BdModel.crearNotaConPrendas(nota, prendas);
  }

  List<String> obtenerEstadosPago() {
    return ['Pendiente', 'Pagado', 'Abonado'];
  }

    List<String> obtenerServicios() {
    return ['Tintorería', 'Sastrería', 'Ambos', 'Otro'];
  }
}


