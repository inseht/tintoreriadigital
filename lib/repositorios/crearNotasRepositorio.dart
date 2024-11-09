import '../bd/bdmodel.dart';

class Crearnotasrepositorio {
  Future<void> crearNota(Map<String, dynamic> nota) async {
    await BdModel.crearNota(nota);
  }
}
