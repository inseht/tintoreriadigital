import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  set isDark(bool value) {
    _isDark = value;
    notifyListeners();  // Notifica a los consumidores cuando cambia el estado
  }

  void toggleTheme() {
    _isDark = !_isDark;  // Cambia el estado de _isDark
    notifyListeners();  // Notifica a los consumidores sobre el cambio
  }
}
