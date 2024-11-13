import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/proveedoresBloc.dart';
import '../repositorios/proveedoresRepositorio.dart';
import '../bd/bdmodel.dart';

class Proveedores extends StatefulWidget {
  const Proveedores({super.key});

  @override
  State<Proveedores> createState() => _ProveedoresState();
}

class _ProveedoresState extends State<Proveedores> {
  // Controladores para el formulario
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _razonController = TextEditingController();
  final TextEditingController _contacto1Controller = TextEditingController();
  final TextEditingController _contacto2Controller = TextEditingController();

  bool mostrarFormulario = false; // Control para mostrar/ocultar el formulario

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

    // Insertar proveedor en la base de datos
    await BdModel.agregarProveedor(nuevoProveedor);

    // Limpiar los campos
    _nombreController.clear();
    _razonController.clear();
    _contacto1Controller.clear();
    _contacto2Controller.clear();

    // Ocultar formulario
    setState(() {
      mostrarFormulario = false;
    });

    // Recargar la lista de proveedores
    context.read<ProveedoresBloc>().add(ObtenerProveedores());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProveedoresBloc(ProveedoresRepositorio())..add(ObtenerProveedores()),
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    mostrarFormulario = !mostrarFormulario;
                  });
                },
                child: Text(mostrarFormulario ? 'Cancelar' : 'Agregar Proveedor'),
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                ),
              ),
            ),
            if (mostrarFormulario)
              Padding(
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
                        labelText: 'Razón Social',
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
                      child: const Text('Guardar Proveedor'),
                    ),
                  ],
                ),
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
              ],
            ),
        ],
      ),
    );
  }
}
