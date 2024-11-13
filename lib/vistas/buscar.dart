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

  // Método para cargar los datos de todas las tablas
  Future<void> _cargarDatos() async {
    final resultados = await BdModel.obtenerDatosDeTodasLasTablas();
    setState(() {
      datos = resultados;
      resultadosFiltrados = {}; // No mostrar nada inicialmente
    });
  }

  // Método para buscar coincidencias en todas las tablas
  void _buscarTexto() {
    String texto = _controller.text.toLowerCase().trim();

    if (texto.isEmpty) {
      // Si la barra de búsqueda está vacía, no mostrar resultados
      setState(() {
        resultadosFiltrados = {}; // No mostrar nada hasta que haya texto
      });
      return;
    }

    // Filtrar resultados
    Map<String, List<Map<String, dynamic>>> nuevosResultados = {};

    datos.forEach((tabla, registros) {
      List<Map<String, dynamic>> coincidencias = registros.where((registro) {
        // Buscar coincidencias en los valores de cada registro
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Barra de búsqueda
            SearchBar(
              controller: _controller,
              padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
              leading: const Icon(Icons.search),
            ),
            const SizedBox(height: 20),
            // Mostrar resultados solo si hay texto en la barra de búsqueda
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
                                // Mostrar cada item en la lista sin necesidad de expansión
                                ...entry.value.map((item) {
                                  return ListTile(
                                    title: Text(item.toString()),
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
