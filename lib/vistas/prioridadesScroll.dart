import 'package:flutter/material.dart';

class prioridadesScroll extends StatefulWidget {
  const prioridadesScroll({super.key});

  @override
  _prioridadesScrollState createState() => _prioridadesScrollState();
}

class _prioridadesScrollState extends State<prioridadesScroll> {
  List<String> items = [];
  bool isLoading = false;
  int page = 0;

  // Función para simular la carga de más datos
  void _loadMore() {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    // Simulando la carga de datos de una API o base de datos
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        items.addAll(List.generate(10, (index) => "Elemento ${page * 10 + index + 1}"));
        isLoading = false;
        page++;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMore(); // Cargar los primeros 10 elementos
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollEndNotification &&
            !isLoading && 
            scrollNotification.metrics.extentAfter == 0) {
          // Si hemos llegado al final de la lista, cargamos más
          _loadMore();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: items.length + 1, // El +1 es para el indicador de carga
        itemBuilder: (context, index) {
          if (index == items.length) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: isLoading
                    ? CircularProgressIndicator()
                    : Text('No hay más elementos'),
              ),
            );
          }
          return ListTile(
            title: Text(items[index]),
            leading: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Acción cuando se toca el item
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Seleccionaste: ${items[index]}")),
              );
            },
          );
        },
      ),
    );
  }
}
