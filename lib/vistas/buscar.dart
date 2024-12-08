import 'package:flutter/material.dart';
import 'package:tintoreriadigital/bd/bdmodel.dart';

class Buscar extends StatefulWidget {
  const Buscar({super.key});

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
      await _cargarDatos();
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

  Widget _buildItem(String titulo, List<Map<String, dynamic>> items, IconData icon) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          'No hay resultados en $titulo.',
          style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final keys = item.keys.toList();

        // Usamos un campo clave como título y otro como subtítulo
        final String title = item[keys[0]].toString();
        final String subtitle = keys.length > 1 ? item[keys[1]].toString() : "";

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: Icon(icon, size: 36, color: Colors.blueAccent),
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
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
                              Expanded(child: _buildItem('Notas', notas, Icons.note)),
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
                              Expanded(child: _buildItem('Proveedores', proveedores, Icons.store)),
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
