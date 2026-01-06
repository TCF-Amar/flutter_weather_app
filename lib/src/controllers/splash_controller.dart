import 'dart:async';
import 'package:get/get.dart';
import 'package:weather_app/services/routes/route_name.dart';
import 'package:weather_app/src/controllers/location_controller.dart';

/// Controller for the splash screen
/// Handles app initialization and navigation to home screen
class SplashController extends GetxController {
  // Dependencies 
  final locationController = Get.find<LocationController>();

  // State Variables 
  final RxBool isInitialized = false.obs;
  final RxString statusMessage = 'Loading...'.obs;

  /// Navigation callback
  Function(String)? onNavigate;

  /// Timer for initialization
  Timer? _timer;

  // Lifecycle 

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // Private Methods 

  /// Initialize the app and wait for location services
  Future<void> _initializeApp() async {
    /// Update status
    statusMessage.value = 'Initializing app...';

    /// Wait for minimum splash duration (1 second)
    await Future.delayed(const Duration(seconds: 1));

    /// Wait for location to finish initializing
    try {
      int waitCount = 0;
      while (locationController.status.value == LocationStatus.loading &&
          waitCount < 20) {
        await Future.delayed(const Duration(milliseconds: 100));
        waitCount++;
      }
    } catch (e) {
      /// Location controller might not be ready, continue anyway
    }

    /// Ensure minimum splash screen duration (1 more second)
    await Future.delayed(const Duration(seconds: 1));

    /// Mark as initialized
    isInitialized.value = true;
    statusMessage.value = 'Ready!';

    /// Navigate to home via callback
    if (onNavigate != null) {
      onNavigate!(RouteName.home.path);
    }
  }
}
