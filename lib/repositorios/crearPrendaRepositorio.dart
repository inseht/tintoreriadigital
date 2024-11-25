import 'package:tintoreriadigital/bd/bdmodel.dart';

class crearPrendarRepositorio {
  Future<void> agregarPrenda(Map<String, dynamic> prenda) async {
    try {
      await BdModel.agregarPrenda(prenda);
    } catch (e) {
      throw Exception('Error al agregar prenda: $e');
    }
  }

  Future<List<Map<String, dynamic>>> obtenerPrendas() async {
    try {
      return await BdModel.obtenerPrendas();
    } catch (e) {
      throw Exception('Error al obtener prendas: $e');
    }
  }
}