import 'package:tintoreriadigital/bd/bdmodel.dart';

class PrioridadesRepositorio {

  Future<List<Map<String, dynamic>>> obtenerNotasConPrioridad1() async {
    final notasConPrioridad1 = await BdModel.obtenerNotas();
    return notasConPrioridad1
        .where((nota) => nota['prioridad'] == 1)
        .toList();
  }

  Future<List<Map<String, dynamic>>> obtenerNotasPendientes() async {
    final notasPendientes = await BdModel.obtenerNotas();
    return notasPendientes
        .where((nota) => nota['estado'] == 'Pendiente')
        .toList();
  }

  Map<DateTime, List<String>> mapearEventos(List<Map<String, dynamic>> notas) {
    Map<DateTime, List<String>> eventos = {};

    for (var nota in notas) {
      DateTime fechaRecibido = DateTime.parse(nota['fechaRecibido']);
      if (eventos.containsKey(fechaRecibido)) {
        eventos[fechaRecibido]!.add(nota['nombreCliente']);
      } else {
        eventos[fechaRecibido] = [nota['nombreCliente']];
      }
    }

    return eventos;
  }
}
