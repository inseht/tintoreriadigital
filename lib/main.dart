import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  print("ElevatedButton pressed");
                },
                child: Text('ElevatedButton'),
              ),
              ElevatedButton(
                onPressed: () {
                  print("ElevatedButton2 pressed");
                },
                child: Text('ElevatedButton'),
              ),
              ElevatedButton(
                onPressed: () {
                  print("ElevatedButton3 pressed");
                },
                child: Text('ElevatedButton'),
              ),     
                            ElevatedButton(
                onPressed: () {
                  print("ElevatedButton3 pressed");
                },
                child: Text('ElevatedButton'),
              ),     
                            ElevatedButton(
                onPressed: () {
                  print("ElevatedButton3 pressed");
                },
                child: Text('ElevatedButton'),
              ),             
            ],
          ),
        ),
      ),
    );
  }
}
