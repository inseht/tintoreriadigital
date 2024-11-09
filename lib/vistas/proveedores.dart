import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/proveedoresBloc.dart';
import '../repositorios/proveedoresRepositorio.dart';

class Proveedores extends StatelessWidget {
  const Proveedores({super.key});

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
                  Navigator.of(context).pushNamed('/agregarProveedor');
                },
                child: const Text('Agregar Proveedor'),
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                ),
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
                child: Text('Contacto 1', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  child: Text(proveedor['contactoProveedor1'] ?? 'N/A'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
