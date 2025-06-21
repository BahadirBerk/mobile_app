import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  
  bool get isDarkMode => _isDarkMode;
  
  // Neumorphism Color Palette
  static const Color lightBackground = Color(0xFFF4F2F8);
  static const Color lightSurface = Color(0xFFE0DFF7);
  static const Color lightAccent = Color(0xFFF2C94C);
  static const Color lightPrimary = Color(0xFF8B5CF6);
  static const Color lightSecondary = Color(0xFFA78BFA);
  
  static const Color darkBackground = Color(0xFF1A1A2E);
  static const Color darkSurface = Color(0xFF16213E);
  static const Color darkAccent = Color(0xFFFFD93D);
  static const Color darkPrimary = Color(0xFF7C3AED);
  static const Color darkSecondary = Color(0xFF8B5CF6);
  
  // Neumorphism Shadows
  static List<BoxShadow> get lightShadows => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 20,
      offset: const Offset(10, 10),
    ),
    BoxShadow(
      color: Colors.white.withOpacity(0.8),
      blurRadius: 20,
      offset: const Offset(-10, -10),
    ),
  ];
  
  static List<BoxShadow> get lightPressedShadows => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 10,
      offset: const Offset(5, 5),
    ),
  ];
  
  static List<BoxShadow> get darkShadows => [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(10, 10),
    ),
    BoxShadow(
      color: Colors.white.withOpacity(0.05),
      blurRadius: 20,
      offset: const Offset(-10, -10),
    ),
  ];
  
  static List<BoxShadow> get darkPressedShadows => [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 10,
      offset: const Offset(5, 5),
    ),
  ];
  
  // Current theme colors
  Color get backgroundColor => _isDarkMode ? darkBackground : lightBackground;
  Color get surfaceColor => _isDarkMode ? darkSurface : lightSurface;
  Color get accentColor => _isDarkMode ? darkAccent : lightAccent;
  Color get primaryColor => _isDarkMode ? darkPrimary : lightPrimary;
  Color get secondaryColor => _isDarkMode ? darkSecondary : lightSecondary;
  
  // Current shadows
  List<BoxShadow> get shadows => _isDarkMode ? darkShadows : lightShadows;
  List<BoxShadow> get pressedShadows => _isDarkMode ? darkPressedShadows : lightPressedShadows;
  
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
  
  void setTheme(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }
} 