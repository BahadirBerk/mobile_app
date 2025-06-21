import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  
  bool get isDarkMode => _isDarkMode;
  
  // Light Theme - Warm & Soft
  static const Color lightBackground = Color(0xFFFDFCFB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightPrimary = Color(0xFFFFA726); // Softer Orange
  static const Color lightSecondary = Color(0xFFFFCA28); // Softer Yellow
  static const Color lightAccent = Color(0xFFEF5350); // Softer Red
  static const Color lightText = Color(0xFF37474F); // Darker Slate
  static const Color lightTextSecondary = Color(0xFF78909C); // Lighter Slate
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE0E0E0);

  // Dark Theme - Deeper & Elegant
  static const Color darkBackground = Color(0xFF121212); // True black
  static const Color darkSurface = Color(0xFF1E1E1E); // Slightly lighter black
  static const Color darkPrimary = Color(0xFFBB86FC); // Lavender
  static const Color darkSecondary = Color(0xFF03DAC6); // Teal
  static const Color darkAccent = Color(0xFFCF6679); // Muted Red
  static const Color darkText = Color(0xFFE0E0E0); // Off-white
  static const Color darkTextSecondary = Color(0xFFB0B0B0); // Gray
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkBorder = Color(0xFF2C2C2C);
  
  // Current theme colors
  Color get backgroundColor => _isDarkMode ? darkBackground : lightBackground;
  Color get surfaceColor => _isDarkMode ? darkSurface : lightSurface;
  Color get primaryColor => _isDarkMode ? darkPrimary : lightPrimary;
  Color get secondaryColor => _isDarkMode ? darkSecondary : lightSecondary;
  Color get accentColor => _isDarkMode ? darkAccent : lightAccent;
  Color get textColor => _isDarkMode ? darkText : lightText;
  Color get textSecondaryColor => _isDarkMode ? darkTextSecondary : lightTextSecondary;
  Color get cardColor => _isDarkMode ? darkCard : lightCard;
  Color get borderColor => _isDarkMode ? darkBorder : lightBorder;
  
  // Shadows for both themes
  List<BoxShadow> get lightShadows => [
    BoxShadow(
      color: Colors.grey.withOpacity(0.2),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];
  
  List<BoxShadow> get darkShadows => [
    BoxShadow(
      color: Colors.black.withOpacity(0.5),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];
  
  List<BoxShadow> get shadows => _isDarkMode ? darkShadows : lightShadows;
  
  // Gradients
  LinearGradient get primaryGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: _isDarkMode 
        ? [darkPrimary, darkSecondary]
        : [lightPrimary, lightSecondary],
  );
  
  LinearGradient get backgroundGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: _isDarkMode 
        ? [darkBackground, darkSurface]
        : [lightBackground, lightSurface],
  );
  
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
  
  void setTheme(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }
} 