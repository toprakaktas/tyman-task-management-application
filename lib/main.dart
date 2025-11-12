import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tyman/core/notifications/notifications.dart';
import 'package:tyman/core/providers/router_provider.dart';
import 'package:tyman/core/themes/dark_theme.dart';
import 'package:tyman/core/themes/light.theme.dart';
import 'package:tyman/firebase/firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final apiKey = dotenv.env['API_KEY'];
  await Notifications().initNotification();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  initializeDateFormatting()
      .then((_) => runApp(ProviderScope(child: MyApp(apiKey: apiKey))));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key, String? apiKey});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      title: 'TyMan',
      routerConfig: router,
    );
  }
}
