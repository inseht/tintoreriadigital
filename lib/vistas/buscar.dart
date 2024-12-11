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
  List<Map<String, dynamic>> prendas = [];

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

    // Obtener todas las notas y prendas desde la base de datos
    final todasNotas = await BdModel.obtenerNotas();
    final todosPrendas = await BdModel.obtenerPrendas();

    // Imprimir los datos para verificar qué se está cargando
    print('Notas cargadas: $todasNotas');
    print('Prendas cargadas: $todosPrendas');

    setState(() {
      notas = todasNotas;
      prendas = todosPrendas;
      cargando = false;
    });
  }

  Future<void> _buscarTexto() async {
    final filtro = _controller.text.trim().toLowerCase();

    if (filtro.isEmpty) {
      // Si no hay filtro, cargar todos los datos
      await _cargarDatos();
    } else {
      setState(() => cargando = true);

      // Obtener las notas y prendas filtradas
      final notasFiltradas = await BdModel.obtenerNotasFiltradas(filtro);
      final prendasFiltradas = await BdModel.obtenerPrendasFiltradas(filtro);

      // Imprimir los resultados filtrados
      print('Notas filtradas: $notasFiltradas');
      print('Prendas filtradas: $prendasFiltradas');

      setState(() {
        notas = notasFiltradas;
        prendas = prendasFiltradas;
        cargando = false;
      });
    }
  }

  Future<void> _eliminarNota(String idNota) async {
    final confirmacion = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmación'),
        content: const Text('¿Estás seguro de que quieres eliminar esta nota?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmacion == true) {
      final int idNotaInt = int.tryParse(idNota) ?? -1;
      if (idNotaInt != -1) {
        await BdModel.eliminarNota(idNotaInt);
        await _cargarDatos();
      } else {
        print('Error: idNota no es un entero válido.');
      }
    }
  }

  // Método para construir la lista de items (Notas o Prendas)
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

        String title = "Desconocido";
        String subtitle = "Información no disponible";

        // Comprobación de si el item es una nota o una prenda
        if (item.containsKey('idNota') && item.containsKey('nombreCliente')) {
          final String idNota = item['idNota']?.toString() ?? "Desconocido";
          final String nombreCliente = item['nombreCliente']?.toString() ?? "Sin Nombre";
          title = "Nota #$idNota";
          subtitle = "Nombre del cliente: $nombreCliente";
        } else if (item.containsKey('idPrenda') && item.containsKey('nombrePrenda')) {
          final String idPrenda = item['idPrenda']?.toString() ?? "Desconocido";
          final String nombrePrenda = item['nombrePrenda']?.toString() ?? "Sin Nombre";
          title = "Prenda #$idPrenda";
          subtitle = "Nombre de la prenda: $nombrePrenda";
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: Icon(icon, size: 36, color: Color.fromARGB(255, 72, 100, 122)),
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
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _eliminarNota(item['idNota']?.toString() ?? ""),
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
              decoration: InputDecoration(
                labelText: 'Buscar',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Colors.grey[100]!,
                    width: 1.0,
                  ),
                ),
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Color(0xFFF5F5F5),
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
                                'Prendas',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(),
                              Expanded(child: _buildItem('Prendas', prendas, Icons.store)),
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
