import 'package:flutter/foundation.dart';

/// Service xử lý authentication
class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userEmail;
  String? _userName;

  bool get isLoggedIn => _isLoggedIn;
  String? get userEmail => _userEmail;
  String? get userName => _userName;

  /// Login với email và password
  Future<bool> login(String email, String password) async {
    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      // Simulate successful login
      _isLoggedIn = true;
      _userEmail = email;
      
      // Extract username from email or use full name format
      String username = email.split('@')[0];
      // Capitalize first letter
      username = username[0].toUpperCase() + username.substring(1);
      _userName = username;
      
      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  /// Register với email và password
  Future<bool> register(String email, String password, {String? fullName}) async {
    try {
      // TODO: Implement actual API call
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      // Simulate successful registration
      _isLoggedIn = true;
      _userEmail = email;
      
      if (fullName != null && fullName.isNotEmpty) {
        _userName = fullName;
      } else {
        // Extract username from email
        String username = email.split('@')[0];
        username = username[0].toUpperCase() + username.substring(1);
        _userName = username;
      }
      
      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('Register error: $e');
      return false;
    }
  }

  /// Login với social provider (Google, Facebook)
  Future<bool> socialLogin(String provider) async {
    try {
      // TODO: Implement actual social login
      await Future.delayed(const Duration(seconds: 2));

      _isLoggedIn = true;
      
      // Simulate getting user info from social provider
      if (provider.toLowerCase() == 'google') {
        _userEmail = 'nguoidung@gmail.com';
        _userName = 'Người dùng Google';
      } else if (provider.toLowerCase() == 'facebook') {
        _userEmail = 'nguoidung@facebook.com';
        _userName = 'Người dùng Facebook';
      } else {
        _userEmail = 'user@$provider.com';
        _userName = 'Người dùng $provider';
      }
      
      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('Social login error: $e');
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    _isLoggedIn = false;
    _userEmail = null;
    _userName = null;
    notifyListeners();
  }

  /// Check if user is logged in (for splash screen)
  Future<bool> checkAuthStatus() async {
    // TODO: Check with secure storage or shared preferences
    await Future.delayed(const Duration(milliseconds: 500));
    return _isLoggedIn;
  }
}


