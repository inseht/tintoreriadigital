import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../bloc/prioridadesBloc.dart';

class prioridadesBoard extends StatelessWidget {
  const prioridadesBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrioridadesBloc()..add(CargarNotasEvent()), 
      child: Scaffold(
        body: BlocBuilder<PrioridadesBloc, PrioridadesState>(
          builder: (context, state) {
            if (state is NotasCargadasState) {
              if (state.notas.isEmpty) {
                return const Center(
                  child: Text(
                    'No hay notas con prioridad por el momento.',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  itemCount: state.notas.length,
                  itemBuilder: (context, index) {
                    final nota = state.notas[index];

                    // Validaciones para evitar errores
                    final nombreCliente = nota['nombreCliente'] ?? 'Cliente desconocido';
                    final idNota = nota['idNota'] ?? 'Sin ID';
                    final importe = (nota['importe'] != null)
                        ? '\$${nota['importe'].toStringAsFixed(2)}'
                        : 'Importe no disponible';
                    final estado = nota['estado'] ?? 'Estado no especificado';
                    final prendas = nota['prendas'] ?? [];

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cliente: $nombreCliente',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Nota #: $idNota',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Importe: $importe',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Estado: $estado',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
                            ),
                            const Divider(height: 24, color: Colors.grey),
                            const Text(
                              'Prendas asociadas:',
                              style: TextStyle(
                                fontSize: 18, // Proporcionalmente más grande
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (prendas.isNotEmpty)
                              ...prendas
                                  .map<Widget>((prenda) => Text(
                                        '- ${prenda['tipo'] ?? 'Tipo desconocido'} '
                                        '(${prenda['servicio'] ?? 'Servicio desconocido'} - '
                                        '${prenda['color'] ?? 'Color desconocido'})',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(fontSize: 16),
                                      ))
                                  .toList()
                            else
                              const Text(
                                'No hay prendas asociadas.',
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              // Estado inicial o de carga
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Cargando notas prioritarias...',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
