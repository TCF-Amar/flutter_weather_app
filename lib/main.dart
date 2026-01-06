import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/core/DI/initialize_dependency.dart';
import 'package:weather_app/core/storage/local_storage.dart';
import 'package:weather_app/core/storage/shared_prefs_storage.dart';
import 'package:weather_app/core/theme/app_theme.dart';
import 'package:weather_app/services/notification/notification_service.dart';
import 'package:weather_app/services/routes/app_route.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/src/controllers/settings_controller.dart';
import 'package:weather_app/src/views/widgets/notification_payload.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init();

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

  // Listen for notification taps and navigate to the specified route
  NotificationService.instance.onTap.listen((response) {
    final payloadStr = response.payload;
    if (payloadStr == null) return;

    try {
      final payload = NotificationPayload.fromJson(payloadStr);
      // Use GoRouter to navigate to the route specified in the payload
      AppRoute.router.push(payload.route);
    } catch (e) {
      debugPrint('Error handling notification tap: $e');
    }
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.find();

    return Obx(
      () => GetMaterialApp.router(
        title: 'Weather App',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: settingsController.themeMode.value,
        debugShowCheckedModeBanner: false,
        routeInformationParser: AppRoute.router.routeInformationParser,
        routerDelegate: AppRoute.router.routerDelegate,
        routeInformationProvider: AppRoute.router.routeInformationProvider,
      ),
    );
  }
}
