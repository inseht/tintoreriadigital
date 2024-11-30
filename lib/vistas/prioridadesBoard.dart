import 'package:flutter/material.dart';
import 'package:appflowy_board/appflowy_board.dart';
import 'package:tintoreriadigital/bd/bdmodel.dart'; 

class prioridadesBoard extends StatefulWidget {
  const prioridadesBoard({super.key});

  @override
  _PrioridadesBoardState createState() => _PrioridadesBoardState();
}

class _PrioridadesBoardState extends State<prioridadesBoard> {
  late Future<List<Map<String, dynamic>>> _notasConPrioridad;
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

  late AppFlowyBoardScrollController boardController;

  @override
  void initState() {
    super.initState();
    boardController = AppFlowyBoardScrollController();
    _notasConPrioridad = BdModel.obtenerNotasConPrioridad1(); 
    _notasConPrioridad.then((notas) {
      final groupPrioridades = AppFlowyGroupData(
        id: "Prioridades",
        name: "Prioridades",
        items: notas.map((nota) {
          return RichTextItem(
            title: '${nota['nombreCliente']} - Nota #${nota['idNota']}',
            subtitle: 'Importe: ${nota['importe']} | Fecha: ${nota['fechaRecibido']} | Estado: ${nota['estado']}',
          );
        }).toList(),
      );

      controller.addGroup(groupPrioridades);
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = AppFlowyBoardConfig(
      groupBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      stretchGroupHeight: false,
    );

    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _notasConPrioridad,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay notas con prioridad 1.'));
          } else {

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
          }
        },
      ),
    );
  }

  Widget _buildCard(AppFlowyGroupItem item) {
    final cardBackgroundColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    if (item is RichTextItem) {
      return RichTextCard(item: item);
    }

    throw UnimplementedError();
  }
}

class RichTextCard extends StatelessWidget {
  final RichTextItem item;

  const RichTextCard({
    required this.item,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color cardBackgroundColor = Theme.of(context).cardColor;
    final Color titleColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final Color subtitleColor = Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7) ?? Colors.grey;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: subtitleColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RichTextItem extends AppFlowyGroupItem {
  final String title;
  final String subtitle;

  RichTextItem({required this.title, required this.subtitle});

  @override
  String get id => title;
}
