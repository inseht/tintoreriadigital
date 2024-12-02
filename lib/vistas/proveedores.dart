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
                child: Text(mostrarFormulario ? 'Cancelar' : 'Agregar Proveedor', style: TextStyle(fontSize: 30)),
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
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
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _razonController,
                      decoration: const InputDecoration(
                        labelText: 'Razón',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _contacto1Controller,
                      decoration: const InputDecoration(
                        labelText: 'Contacto 1',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _contacto2Controller,
                      decoration: const InputDecoration(
                        labelText: 'Contacto 2',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _agregarProveedor,
                      child: Text(proveedorSeleccionado == null ? 'Guardar Proveedor' : 'Actualizar Proveedor', style: TextStyle(fontSize: 30)),
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
                    return Center(child: Text(state.error));
                  } else {
                    return const Center(child: Text('Sin datos'));
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
      padding: const EdgeInsets.all(20.0),
      child: Table(
        border: TableBorder.all(),
        children: [
          const TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Nombre', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Razón', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Contacto 1', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Contacto 2', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Acciones', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          for (var proveedor in proveedores)
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(proveedor['idProveedor'].toString()),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(proveedor['nombreProveedor'] ?? 'N/A'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(proveedor['razonProveedor'] ?? 'N/A'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(proveedor['contactoProveedor1'] ?? 'N/A'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(proveedor['contactoProveedor2'] ?? 'N/A'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editarProveedor(proveedor),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _eliminarProveedor(proveedor['idProveedor']),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
