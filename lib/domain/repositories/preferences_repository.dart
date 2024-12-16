abstract class PreferencesRepository {
  Future<bool> getDarkTheme();

  Future<void> setDarkTheme(bool value);

  Future<bool> getSingleQRScanner();

  Future<void> setSingleQRScanner(bool value);
}
