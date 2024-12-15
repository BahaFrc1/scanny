import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/models/qr_code.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(QRCodeModelAdapter());
  await Hive.openBox<QRCodeModel>('barcodeHistory');
  runApp(const MyApp());
}

void initLocalDatabase() async {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'QR Scanner App',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.system,
          routerConfig: appRouter2,
        ));
  }
}
