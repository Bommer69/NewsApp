import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

/// Service xử lý authentication với MongoDB backend
class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userEmail;
  String? _userName;
  String? _token;

  bool get isLoggedIn => _isLoggedIn;
  String? get userEmail => _userEmail;
  String? get userName => _userName;

  AuthService() {
    _loadAuthData();
  }

  /// Load token và thông tin user từ SharedPreferences khi khởi động
  Future<void> _loadAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final email = prefs.getString('user_email');
      final name = prefs.getString('user_name');

      if (token != null && token.isNotEmpty) {
        _token = token;
        _userEmail = email;
        _userName = name;
        _isLoggedIn = true;
        notifyListeners();
        
        // Verify token với server
        await _verifyToken();
      }
    } catch (e) {
      debugPrint('Error loading auth data: $e');
    }
  }

  /// Lưu token và thông tin user vào SharedPreferences
  Future<void> _saveAuthData(String token, String email, String? name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('user_email', email);
      if (name != null && name.isNotEmpty) {
        await prefs.setString('user_name', name);
      }
    } catch (e) {
      debugPrint('Error saving auth data: $e');
    }
  }

  /// Xóa token và thông tin user khỏi SharedPreferences
  Future<void> _clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_email');
      await prefs.remove('user_name');
    } catch (e) {
      debugPrint('Error clearing auth data: $e');
    }
  }

  /// Verify token với server
  Future<void> _verifyToken() async {
    if (_token == null) return;
    
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.meEndpoint}');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: ApiConfig.requestTimeout));

      if (response.statusCode != 200) {
        // Token không hợp lệ, đăng xuất
        await logout();
      }
    } catch (e) {
      debugPrint('Error verifying token: $e');
      // Nếu không kết nối được server, vẫn giữ trạng thái đăng nhập
    }
  }

  /// Login với email và password
  Future<bool> login(String email, String password) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.loginEndpoint}');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email.trim(),
          'password': password,
        }),
      ).timeout(Duration(seconds: ApiConfig.requestTimeout));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final token = data['data']['token'];
        final user = data['data']['user'];
        
        _token = token;
        _userEmail = user['email'];
        _userName = user['fullName'] ?? email.split('@')[0];
        _isLoggedIn = true;
        
        await _saveAuthData(token, _userEmail!, _userName);
        notifyListeners();

        return true;
      } else {
        debugPrint('Login error: ${data['message'] ?? 'Unknown error'}');
        return false;
      }
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  /// Register với email và password
  Future<bool> register(String email, String password, {String? fullName}) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.registerEndpoint}');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email.trim(),
          'password': password,
          'fullName': fullName?.trim(),
        }),
      ).timeout(Duration(seconds: ApiConfig.requestTimeout));

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        final token = data['data']['token'];
        final user = data['data']['user'];
        
        _token = token;
        _userEmail = user['email'];
        _userName = user['fullName'] ?? email.split('@')[0];
        _isLoggedIn = true;
        
        await _saveAuthData(token, _userEmail!, _userName);
        notifyListeners();

        return true;
      } else {
        debugPrint('Register error: ${data['message'] ?? 'Unknown error'}');
        return false;
      }
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
    _token = null;
    await _clearAuthData();
    notifyListeners();
  }

  /// Check if user is logged in (for splash screen)
  Future<bool> checkAuthStatus() async {
    // Đã load trong constructor, chỉ cần return
    return _isLoggedIn;
  }
}


