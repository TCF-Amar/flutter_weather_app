import 'dart:async';

import 'package:geolocator/geolocator.dart';

class LocationHelper {
  ///  Check permission only
  static Future<bool> hasPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  ///  Request permission
  static Future<bool> handlePermission() async {
    //  Location service ON hai ya nahi
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Check if permission is permanently denied
  static Future<bool> isPermanentlyDenied() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.deniedForever;
  }

  /// Open app settings (for permissions)
  static Future<bool> openAppSettings() async {
    try {
      final result = await Geolocator.openAppSettings();
      return result;
    } catch (e) {
      // If openAppSettings fails, try alternative approach
      return false;
    }
  }

  /// Open location settings (for GPS)
  /// Note: This opens system location settings, not app-specific settings
  static Future<bool> openLocationSettings() async {
    try {
      // Geolocator.openLocationSettings() opens system location/GPS settings
      final result = await Geolocator.openLocationSettings();
      return result;
    } catch (e) {
      // If method doesn't exist or fails, fallback to app settings
      // On some platforms, location settings might not be directly accessible
      return await openAppSettings();
    }
  }

  /// Get current position (one time)
  static Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      forceAndroidLocationManager: true,
      timeLimit: const Duration(seconds: 10),
    );
  }
}
