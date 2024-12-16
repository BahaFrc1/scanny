import 'package:flutter_test/flutter_test.dart';
import 'package:qr_scanner_workerbase/config/keys.dart';
import 'package:qr_scanner_workerbase/data/repositories/preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late PreferencesRepositoryImpl preferencesRepository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    preferencesRepository = PreferencesRepositoryImpl();
  });

  group('PreferencesRepositoryImpl', () {
    test('getDarkTheme should return false when no value is set', () async {
      final result = await preferencesRepository.getDarkTheme();
      expect(result, false);
    });

    test('setDarkTheme should save the value', () async {
      await preferencesRepository.setDarkTheme(true);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool(dbIsDarkTheme), true);
    });

    test('getDarkTheme should return the saved value', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(dbIsDarkTheme, true);
      final result = await preferencesRepository.getDarkTheme();
      expect(result, true);
    });

    test('getSingleQRScanner should return false when no value is set',
            () async {
          final result = await preferencesRepository.getSingleQRScanner();
          expect(result, false);
        });

    test('setSingleQRScanner should save the value', () async {
      await preferencesRepository.setSingleQRScanner(true);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool(dbIsSingleQRScanner), true);
    });

    test('getSingleQRScanner should return the saved value', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(dbIsSingleQRScanner, true);
      final result = await preferencesRepository.getSingleQRScanner();
      expect(result, true);
    });
  });
}
