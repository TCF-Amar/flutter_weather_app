import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/core/DI/initialize_dependency.dart';
import 'package:weather_app/core/storage/local_storage.dart';
import 'package:weather_app/core/storage/shared_prefs_storage.dart';
import 'package:weather_app/services/routes/app_route.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env.development');
  } catch (e) {
    debugPrint('Warning: Could not load .env.development file: $e');
  }

  // Initialize SharedPreferences first
  final prefs = await SharedPreferences.getInstance();
  Get.put<LocalStorage>(SharedPrefsStorage(prefs), permanent: true);

  // Initialize other dependencies
  InitializeDependency().dependencies();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Weather App',
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      routeInformationParser: AppRoute.router.routeInformationParser,
      routerDelegate: AppRoute.router.routerDelegate,
      routeInformationProvider: AppRoute.router.routeInformationProvider,
    );
  }
}
