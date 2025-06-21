import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _currentUser;
  
  bool get isAuthenticated => _isAuthenticated;
  String? get currentUser => _currentUser;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _currentUser = prefs.getString('currentUser');
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Simple validation - in real app, this would be API call
    if (email.isNotEmpty && password.isNotEmpty) {
      _isAuthenticated = true;
      _currentUser = email;
      
      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      await prefs.setString('currentUser', email);
      
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String email, String password, String confirmPassword) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Simple validation
    if (email.isNotEmpty && password.isNotEmpty && password == confirmPassword) {
      _isAuthenticated = true;
      _currentUser = email;
      
      // Save to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      await prefs.setString('currentUser', email);
      
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> signInWithGoogle() async {
    // Simulate Google sign-in delay
    await Future.delayed(const Duration(seconds: 2));
    
    // In a real app, this would integrate with Google Sign-In
    // For now, we'll simulate a successful Google sign-in
    _isAuthenticated = true;
    _currentUser = 'google_user@example.com';
    
    // Save to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', true);
    await prefs.setString('currentUser', _currentUser!);
    
    notifyListeners();
    return true;
  }

  Future<bool> resetPassword(String email) async {
    // Simulate password reset delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Simple validation - in real app, this would send reset email
    if (email.isNotEmpty && email.contains('@')) {
      // In a real app, this would send a password reset email
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _currentUser = null;
    
    // Clear local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isAuthenticated');
    await prefs.remove('currentUser');
    
    notifyListeners();
  }
} 