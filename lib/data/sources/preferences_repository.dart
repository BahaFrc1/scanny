import 'package:shared_preferences/shared_preferences.dart';

class PreferencesRepository {
  Future<bool> getDarkTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkTheme') ?? false;
  }

  Future<void> setDarkTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', value);
  }

  Future<bool> getSingleQRScanner() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isSingleQRScanner') ?? false;
  }

  Future<void> setSingleQRScanner(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSingleQRScanner', value);
  }
}