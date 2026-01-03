import 'dart:async';
import 'package:get/get.dart';
import 'package:weather_app/services/routes/route_name.dart';
import 'package:weather_app/src/controllers/location_controller.dart';

class SplashController extends GetxController {
  final locationController = Get.find<LocationController>();

  final RxBool isInitialized = false.obs;
  final RxString statusMessage = 'Loading...'.obs;

  /// Timer
  Timer? _timer;

  /// Navigation callback
  Function(String)? onNavigate;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    /// Update status
    statusMessage.value = 'Initializing app...';

    /// Wait for minimum splash duration (1 second)
    await Future.delayed(const Duration(seconds: 1));

    /// Check if location is ready
    try {
      /// Wait for location to finish initializing 
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

    // Navigate to home via callback
    if (onNavigate != null) {
      onNavigate!(RouteName.home.path);
    }
  }

  /// Dispose timer
  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
