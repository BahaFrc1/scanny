import 'package:shared_preferences/shared_preferences.dart';

import '../../config/keys.dart';
import '../../domain/repositories/preferences_repository.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  @override
  Future<bool> getDarkTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(dbIsDarkTheme) ?? false;
  }

  @override
  Future<void> setDarkTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(dbIsDarkTheme, value);
  }

  @override
  Future<bool> getSingleQRScanner() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(dbIsSingleQRScanner) ?? false;
  }

  @override
  Future<void> setSingleQRScanner(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(dbIsSingleQRScanner, value);
  }
}
