import '../bd/bdmodel.dart';
class ProveedoresRepositorio {
  Future<List<Map<String, dynamic>>> obtenerProveedores() async {
    return await BdModel.obtenerProveedores();
  }
}