import 'package:flutter/material.dart';
import 'package:appflowy_board/appflowy_board.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/prioridadesBloc.dart';

class prioridadesBoard extends StatefulWidget {
  const prioridadesBoard({super.key});

  @override
  _PrioridadesBoardState createState() => _PrioridadesBoardState();
}

class _PrioridadesBoardState extends State<prioridadesBoard> {
  late AppFlowyBoardScrollController boardController;
  final AppFlowyBoardController controller = AppFlowyBoardController(
    onMoveGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      debugPrint('Move item from $fromIndex to $toIndex');
    },
    onMoveGroupItem: (groupId, fromIndex, toIndex) {
      debugPrint('Move $groupId:$fromIndex to $groupId:$toIndex');
    },
    onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      debugPrint('Move $fromGroupId:$fromIndex to $toGroupId:$toIndex');
    },
  );

  @override
  void initState() {
    super.initState();
    boardController = AppFlowyBoardScrollController();
    context.read<PrioridadesBloc>().add(CargarNotasEvent());
  }

  @override
  Widget build(BuildContext context) {
    final config = AppFlowyBoardConfig(
      groupBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      stretchGroupHeight: false,
    );

    return Scaffold(
      body: BlocBuilder<PrioridadesBloc, PrioridadesState>(
        builder: (context, state) {
          if (state is NotasCargadasState) {
            if (state.notas.isEmpty) {
              return const Center(child: Text('No hay notas con prioridad 1.'));
            }

            final groupPrioridades = AppFlowyGroupData(
              id: "Prioridades",
              name: "Prioridades",
              items: state.notas.map((nota) {
                return SimpleItem(
                  title: '${nota['nombreCliente']} - Nota #${nota['idNota']}',
                  subtitle: 'Importe: ${nota['importe']} | Fecha: ${nota['fechaRecibido']} | Estado: ${nota['estado']}',
                  notas: nota,  // Pasa la nota completa si es necesario mostrarla
                );
              }).toList(),
            );

            controller.addGroup(groupPrioridades);

            return AppFlowyBoard(
              controller: controller,
              cardBuilder: (context, group, groupItem) {
                return AppFlowyGroupCard(
                  key: ValueKey(groupItem.id),
                  child: _buildCard(groupItem),
                );
              },
              boardScrollController: boardController,
              headerBuilder: (context, columnData) {
                return AppFlowyGroupHeader(
                  icon: const Icon(Icons.priority_high_outlined),
                  title: SizedBox(
                    width: 200,
                    child: Text(
                      columnData.headerData.groupName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
                      ),
                    ),
                  ),
                  height: 50,
                  margin: config.groupBodyPadding,
                );
              },
              groupConstraints: const BoxConstraints.tightFor(width: 400),
              config: config,
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildCard(AppFlowyGroupItem item) {
    final cardBackgroundColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    if (item is SimpleItem) {
      return _buildNotaCard(item);  // Ahora usamos este método
    }

    throw UnimplementedError();
  }

  Widget _buildNotaCard(SimpleItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              item.subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            // Aquí puedes agregar detalles adicionales si es necesario
            Text(
              'Detalles de la Nota:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Observaciones: ${item.notas['observaciones'] ?? 'N/A'}'),
            Text('Abono: ${item.notas['abono']}'),
            // Si deseas mostrar las prendas asociadas, puedes iterar sobre ellas aquí
          ],
        ),
      ),
    );
  }
}

class SimpleItem extends AppFlowyGroupItem {
  final String title;
  final String subtitle;
  final Map<String, dynamic> notas;

  SimpleItem({required this.title, required this.subtitle, required this.notas});

  @override
  String get id => title;
}
