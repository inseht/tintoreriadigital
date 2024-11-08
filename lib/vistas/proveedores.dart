import 'package:flutter/material.dart';
import '../temas/apptheme.dart';

class Proveedores extends StatelessWidget {
  const Proveedores({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('its me, hi'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0), 
          child: Table(
            border: TableBorder.all(color: Theme.of(context).colorScheme.primary), 
            children: const [
              TableRow(children: [
                Text('Cell 1'),
                Text('Cell 2'),
                Text('Cell 3'),
              ]),
              TableRow(children: [
                Text('Cell 4'),
                Text('Cell 5'),
                Text('Cell 6'),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
