import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  set isDark(bool value) {
    _isDark = value;
    notifyListeners();  
  }

  void toggleTheme() {
    _isDark = !_isDark; 
    notifyListeners();  
  }
}
