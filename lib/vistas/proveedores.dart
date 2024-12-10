import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/proveedoresBloc.dart';
import '../bd/bdmodel.dart';

class Proveedores extends StatefulWidget {
  const Proveedores({super.key});

  @override
  State<Proveedores> createState() => _ProveedoresState();
}

class _ProveedoresState extends State<Proveedores> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _razonController = TextEditingController();
  final TextEditingController _contacto1Controller = TextEditingController();
  final TextEditingController _contacto2Controller = TextEditingController();

  bool mostrarFormulario = false;
  Map<String, dynamic>? proveedorSeleccionado;

  @override
  void initState() {
    super.initState();
    context.read<ProveedoresBloc>().add(ObtenerProveedores());
  }

  void _agregarProveedor() async {
    if (_nombreController.text.isEmpty || _contacto1Controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nombre y Contacto 1 son obligatorios')),
      );
      return;
    }

    final nuevoProveedor = {
      'nombreProveedor': _nombreController.text,
      'razonProveedor': _razonController.text,
      'contactoProveedor1': _contacto1Controller.text,
      'contactoProveedor2': _contacto2Controller.text,
    };

    if (proveedorSeleccionado == null) {
      await BdModel.agregarProveedor(nuevoProveedor);
    } else {
      int idProveedorInt = proveedorSeleccionado!['idProveedor'] is String
          ? int.tryParse(proveedorSeleccionado!['idProveedor']) ?? 0
          : proveedorSeleccionado!['idProveedor'] as int;

      nuevoProveedor['idProveedor'] = idProveedorInt.toString();
      await BdModel.actualizarProveedor(idProveedorInt, nuevoProveedor);
    }

    _limpiarFormulario();
    context.read<ProveedoresBloc>().add(ObtenerProveedores());
  }

  void _editarProveedor(Map<String, dynamic> proveedor) {
    setState(() {
      proveedorSeleccionado = proveedor;
      _nombreController.text = proveedor['nombreProveedor'];
      _razonController.text = proveedor['razonProveedor'] ?? '';
      _contacto1Controller.text = proveedor['contactoProveedor1'] ?? '';
      _contacto2Controller.text = proveedor['contactoProveedor2'] ?? '';
      mostrarFormulario = true;
    });
  }

  void _eliminarProveedor(int idProveedor) async {
    await BdModel.eliminarProveedor(idProveedor);
    context.read<ProveedoresBloc>().add(ObtenerProveedores());
  }

  void _limpiarFormulario() {
    _nombreController.clear();
    _razonController.clear();
    _contacto1Controller.clear();
    _contacto2Controller.clear();
    setState(() {
      mostrarFormulario = false;
      proveedorSeleccionado = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProveedoresBloc()..add(ObtenerProveedores()),
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    mostrarFormulario = !mostrarFormulario;
                    proveedorSeleccionado = null;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  minimumSize: const Size(200, 70),
                ),
                child: Text(
                  mostrarFormulario ? 'Cancelar' : 'Agregar Proveedor',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            AnimatedCrossFade(
              firstChild: Container(height: 0),
              secondChild: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del Proveedor',
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _razonController,
                      decoration: const InputDecoration(
                        labelText: 'Razón',
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _contacto1Controller,
                      decoration: const InputDecoration(
                        labelText: 'Contacto 1',
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _contacto2Controller,
                      decoration: const InputDecoration(
                        labelText: 'Contacto 2',
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _agregarProveedor,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                        minimumSize: const Size(200, 70),
                      ),
                      child: Text(
                        proveedorSeleccionado == null ? 'Guardar Proveedor' : 'Actualizar Proveedor',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ],
                ),
              ),
              crossFadeState: mostrarFormulario ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
            Expanded(
              child: BlocBuilder<ProveedoresBloc, ProveedoresState>(
                builder: (context, state) {
                  if (state is ProveedoresLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProveedoresLoaded) {
                    return _crearTablaProveedores(state.proveedores);
                  } else if (state is ProveedoresError) {
                    return Center(child: Text(state.error, style: const TextStyle(fontSize: 24)));
                  } else {
                    return const Center(child: Text('Sin datos', style: TextStyle(fontSize: 24)));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _crearTablaProveedores(List<Map<String, dynamic>> proveedores) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isLargeScreen = constraints.maxWidth > 600; // Define a threshold for large screens
            return DataTable(
              columnSpacing: isLargeScreen ? 120.0 : 60.0, // Adjust spacing based on screen size
              headingRowHeight: 60.0,
              border: TableBorder.all(color: Colors.grey, width: 1.5),
              columns: [
                const DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22))),
                const DataColumn(label: Text('Nombre', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22))),
                if (isLargeScreen)
                  const DataColumn(label: Text('Razón', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22))),
                const DataColumn(label: Text('Contacto 1', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22))),
                if (isLargeScreen)
                  const DataColumn(label: Text('Contacto 2', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22))),
                const DataColumn(label: Text('Acciones', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22))),
              ],
              rows: proveedores.map((proveedor) {
                return DataRow(
                  cells: [
                    DataCell(Text(proveedor['idProveedor'].toString(), style: const TextStyle(fontSize: 20))),
                    DataCell(Text(proveedor['nombreProveedor'] ?? 'N/A', style: const TextStyle(fontSize: 20))),
                    if (isLargeScreen)
                      DataCell(Text(proveedor['razonProveedor'] ?? 'N/A', style: const TextStyle(fontSize: 20))),
                    DataCell(Text(proveedor['contactoProveedor1'] ?? 'N/A', style: const TextStyle(fontSize: 20))),
                    if (isLargeScreen)
                      DataCell(Text(proveedor['contactoProveedor2'] ?? 'N/A', style: const TextStyle(fontSize: 20))),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue, size: 30),
                            onPressed: () => _editarProveedor(proveedor),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red, size: 30),
                            onPressed: () => _eliminarProveedor(proveedor['idProveedor']),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
