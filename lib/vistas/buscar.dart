import 'package:flutter/material.dart';
import 'package:tintoreriadigital/bd/bdmodel.dart';

class Buscar extends StatefulWidget {
  const Buscar({super.key});

  @override
  State<Buscar> createState() => _BuscarState();
}

class _BuscarState extends State<Buscar> {
  final SearchController _controller = SearchController();
  Map<String, List<Map<String, dynamic>>> datos = {};
  Map<String, List<Map<String, dynamic>>> resultadosFiltrados = {};

  @override
  void initState() {
    super.initState();
    _cargarDatos();
    _controller.addListener(_buscarTexto);
  }

  @override
  void dispose() {
    _controller.removeListener(_buscarTexto);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    final resultados = await BdModel.obtenerDatosDeTodasLasTablas();
    setState(() {
      datos = resultados;
      resultadosFiltrados = {};
    });
  }

  void _buscarTexto() {
    String texto = _controller.text.toLowerCase().trim();

    if (texto.isEmpty) {
      setState(() {
        resultadosFiltrados = {};
      });
      return;
    }

    Map<String, List<Map<String, dynamic>>> nuevosResultados = {};

    datos.forEach((tabla, registros) {
      List<Map<String, dynamic>> coincidencias = registros.where((registro) {
        return registro.values.any((valor) =>
            valor.toString().toLowerCase().contains(texto));
      }).toList();

      if (coincidencias.isNotEmpty) {
        nuevosResultados[tabla] = coincidencias;
      }
    });

    setState(() {
      resultadosFiltrados = nuevosResultados;
    });
  }

  Widget _buildItem(Map<String, dynamic> item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: item.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Text(
                "${entry.key}: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Expanded(
                child: Text(
                  entry.value.toString(),
                  style: TextStyle(color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SearchBar(
              controller: _controller,
              padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
              leading: const Icon(Icons.search),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _controller.text.isEmpty
                  ? const Center(child: Text(''))
                  : resultadosFiltrados.isEmpty
                      ? const Center(child: Text('No hay resultados'))
                      : ListView(
                          children: resultadosFiltrados.entries.map((entry) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.key,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ...entry.value.map((item) {
                                  return Card(
                                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                                    elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: _buildItem(item),
                                    ),
                                  );
                                }).toList(),
                                const SizedBox(height: 20),
                              ],
                            );
                          }).toList(),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
