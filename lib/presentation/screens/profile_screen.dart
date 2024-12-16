import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/keys.dart';
import '../providers/providers.dart';
import '../providers/theme_provider.dart';
import '../widgets/toast.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isDarkTheme = false;
  bool _isSingleQRScanner = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final preferencesRepository = ref.read(preferencesRepositoryProvider);
    final isDarkTheme = await preferencesRepository.getDarkTheme();
    final isSingleQRScanner = await preferencesRepository.getSingleQRScanner();
    setState(() {
      _isDarkTheme = isDarkTheme;
      _isSingleQRScanner = isSingleQRScanner;
    });
  }

  @override
  Widget build(BuildContext context) {
    final preferencesRepository = ref.read(preferencesRepositoryProvider);
    final profile = ref.watch(profileViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(appBarTitleProfile,
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                  radius: 80,
                  backgroundImage: profile != null && profile.photoURL != null
                      ? NetworkImage(profile.photoURL ?? '')
                      : AssetImage(userPlaceholderImagePath)),
              const SizedBox(height: 16),
              Text(
                profile?.displayName ?? '',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                profile?.email ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // todo: Implement login feature
                  featureNotImplementedToast();
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(logoutDelete),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(darkThemeText),
                          Switch(
                            value: _isDarkTheme,
                            onChanged: (value) async {
                              setState(() {
                                _isDarkTheme = value;
                              });
                              await preferencesRepository.setDarkTheme(value);
                              // Handle theme change
                              if (value) {
                                ref.read(themeProvider.notifier).setDarkTheme();
                              } else {
                                ref
                                    .read(themeProvider.notifier)
                                    .setLightTheme();
                              }
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // closes screen after scanning one QR code
                          const Text(singleQRCodeScannerText),
                          Switch(
                            value: _isSingleQRScanner,
                            onChanged: (value) async {
                              setState(() {
                                _isSingleQRScanner = value;
                              });
                              await preferencesRepository
                                  .setSingleQRScanner(value);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
