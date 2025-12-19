import 'package:flutter/foundation.dart';

/// Service quản lý app preferences
class PreferencesService extends ChangeNotifier {
  bool _isDarkMode = true;
  bool _notificationsEnabled = true;
  String _fontSize = 'medium'; // small, medium, large

  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  String get fontSize => _fontSize;

  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
    _savePreferences();
  }

  void setNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
    _savePreferences();
  }

  void setFontSize(String size) {
    _fontSize = size;
    notifyListeners();
    _savePreferences();
  }

  Future<void> loadPreferences() async {
    // TODO: Load from shared preferences
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _savePreferences() async {
    // TODO: Save to shared preferences
    await Future.delayed(const Duration(milliseconds: 100));
  }
}


