import 'package:flutter/material.dart';
import 'package:weather_app/core/DI/initialize_dependency.dart';
import 'package:weather_app/services/routes/app_route.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env.development');
  } catch (e) {
    debugPrint('Warning: Could not load .env.development file: $e');
  }

InitializeDependency().dependencies();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationParser: AppRoute.router.routeInformationParser,
      routerDelegate: AppRoute.router.routerDelegate,
      routeInformationProvider: AppRoute.router.routeInformationProvider,
    );
  }
}
