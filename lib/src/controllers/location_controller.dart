import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather_app/core/utils/location_helper.dart';

enum LocationStatus {
  initial,
  loading,
  granted,
  denied,
  permanentlyDenied,
  serviceDisabled,
  error,
}

class LocationController extends GetxController {
  final Rx<LocationStatus> status = LocationStatus.initial.obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  final RxDouble latitude = 0.0.obs;
  final RxDouble longitude = 0.0.obs;

  bool _isInitializing = false;

  @override
  void onInit() {
    super.onInit();
    initLocation();
  }

  Future<void> initLocation() async {
    /// Prevent concurrent initialization
    if (_isInitializing) return;

    _isInitializing = true;
    isLoading.value = true;
    status.value = LocationStatus.loading;
    error.value = '';

    try {
      /// Check if location service is enabled first
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        status.value = LocationStatus.serviceDisabled;
        error.value = 'Location service is disabled. Please enable GPS.';
        return;
      }

      final hasPermission = await LocationHelper.handlePermission();
      final isPermanentlyDenied = await LocationHelper.isPermanentlyDenied();

      if (isPermanentlyDenied) {
        status.value = LocationStatus.permanentlyDenied;
        error.value =
            'Location permission permanently denied. Please enable it in app settings.';
        return;
      }

      if (!hasPermission) {
        status.value = LocationStatus.denied;
        error.value =
            'Location permission denied. Please grant location permission.';
        return;
      }

      // Get current position
      final position = await LocationHelper.getCurrentPosition();

      latitude.value = position.latitude;
      longitude.value = position.longitude;
      status.value = LocationStatus.granted;
      error.value = '';
    } on TimeoutException {
      status.value = LocationStatus.error;
      error.value = 'Location request timed out. Please try again.';
    } catch (e) {
      status.value = LocationStatus.error;
      error.value = 'Failed to get location: ${e.toString()}';
    } finally {
      isLoading.value = false;
      _isInitializing = false;
    }
  }

  /// UI can call this after user enables permission or location service
  Future<void> refreshLocation() async {
    await initLocation();
  }

  /// Open app settings for permissions
  Future<void> openAppSettings() async {
    try {
      final opened = await LocationHelper.openAppSettings();
      if (!opened) {
        error.value =
            'Could not open app settings. Please open settings manually.';
        return;
      }
      // Wait a bit for user to return from settings
      await Future.delayed(const Duration(seconds: 1));
      await refreshLocation();
    } catch (e) {
      error.value = 'Error opening app settings: ${e.toString()}';
    }
  }

  /// Open location settings for GPS
  Future<void> openLocationSettings() async {
    try {
      final opened = await LocationHelper.openLocationSettings();
      if (!opened) {
        error.value =
            'Could not open location settings. Please enable GPS manually in your device settings.';
        return;
      }
      // Wait a bit for user to return from settings
      await Future.delayed(const Duration(seconds: 1));
      await refreshLocation();
    } catch (e) {
      error.value = 'Error opening location settings: ${e.toString()}';
    }
  }

  /// Check if location service is enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }
}
