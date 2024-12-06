import 'package:flutter/material.dart';
import 'package:tintoreriadigital/bd/bdmodel.dart';

class Buscar extends StatefulWidget {
  @override
  State<Buscar> createState() => _BuscarState();
}

class _BuscarState extends State<Buscar> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> notas = [];
  List<Map<String, dynamic>> proveedores = [];
  bool cargando = true;

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
    setState(() => cargando = true);

    final todasNotas = await BdModel.obtenerNotas();
    final todosProveedores = await BdModel.obtenerProveedores();

    setState(() {
      notas = todasNotas;
      proveedores = todosProveedores;
      cargando = false;
    });
  }

  Future<void> _buscarTexto() async {
    final filtro = _controller.text.trim().toLowerCase();

    if (filtro.isEmpty) {
      await _cargarDatos(); // Si no hay texto, carga todos los datos
    } else {
      setState(() => cargando = true);

      final notasFiltradas = await BdModel.obtenerNotasFiltradas(filtro);
      final proveedoresFiltrados = await BdModel.obtenerProveedoresFiltrados(filtro);

      setState(() {
        notas = notasFiltradas;
        proveedores = proveedoresFiltrados;
        cargando = false;
      });
    }
  }

  Widget _buildItem(String titulo, List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return Center(child: Text('No hay resultados en $titulo.'));
    }

return ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    final item = items[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0), // Margen alrededor de las tarjetas
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: item.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  "${entry.key}: ${entry.value}",
                  style: const TextStyle(
                    fontSize: 18, // Texto más grande
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  },
);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Buscar',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            cargando
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Notas',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(),
                              Expanded(child: _buildItem('Notas', notas)),
                            ],
                          ),
                        ),
                        const VerticalDivider(width: 1),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Proveedores',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(),
                              Expanded(child: _buildItem('Proveedores', proveedores)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
