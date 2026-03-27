import 'package:flutter/foundation.dart';

class SettingsViewModel extends ChangeNotifier {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _language = 'English';
  bool _isLoading = false;

  bool get notificationsEnabled => _notificationsEnabled;
  bool get darkModeEnabled => _darkModeEnabled;
  String get language => _language;
  bool get isLoading => _isLoading;

  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
    _saveSettings();
  }

  void toggleDarkMode(bool value) {
    _darkModeEnabled = value;
    notifyListeners();
    _saveSettings();
  }

  void setLanguage(String newLanguage) {
    _language = newLanguage;
    notifyListeners();
    _saveSettings();
  }

  Future<void> _saveSettings() async {
    // Simulate saving to storage
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> clearCache() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }

  Future<void> exportData() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _isLoading = false;
    notifyListeners();
  }
}
