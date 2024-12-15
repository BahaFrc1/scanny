import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/models/qr_code.dart';
import 'presentation/providers/theme_provider.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(QRCodeModelAdapter());
  await Hive.openBox<QRCodeModel>('barcodeHistory');
  runApp(ProviderScope(child: MyApp()));
}

void initLocalDatabase() async {}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'QR Scanner App',
      theme: theme,
      routerConfig: appRouter,
    );
  }
}
