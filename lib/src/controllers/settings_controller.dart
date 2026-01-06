import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/core/storage/local_storage.dart';

/// Temperature unit options
enum TemperatureUnit { celsius, fahrenheit }

/// Wind speed unit options
enum WindSpeedUnit { kmh, mph }

/// Controller for user settings and preferences
/// Manages temperature and wind speed unit preferences
class SettingsController extends GetxController {
  final LocalStorage _storage = Get.find<LocalStorage>();

  // Storage keys
  static const String _themeKey = 'theme_mode';
  static const String _temperatureKey = 'temperature_unit';
  static const String _windSpeedKey = 'wind_speed_unit';

  var temperatureUnit = TemperatureUnit.celsius.obs;
  var windSpeedUnit = WindSpeedUnit.kmh.obs;
  var themeMode = ThemeMode.dark.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  /// Load saved settings from storage
  Future<void> _loadSettings() async {
    // Load theme mode
    final savedTheme = await _storage.getString(_themeKey);
    if (savedTheme != null) {
      switch (savedTheme) {
        case 'light':
          themeMode.value = ThemeMode.light;
          break;
        case 'dark':
          themeMode.value = ThemeMode.dark;
          break;
        case 'system':
          themeMode.value = ThemeMode.system;
          break;
      }
    }

    // Load temperature unit
    final savedTemp = await _storage.getString(_temperatureKey);
    if (savedTemp == 'fahrenheit') {
      temperatureUnit.value = TemperatureUnit.fahrenheit;
    }

    // Load wind speed unit
    final savedWind = await _storage.getString(_windSpeedKey);
    if (savedWind == 'mph') {
      windSpeedUnit.value = WindSpeedUnit.mph;
    }
  }

  /// Set theme mode and save to storage
  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    Get.changeThemeMode(mode);

    // Save to storage
    String themeValue;
    switch (mode) {
      case ThemeMode.light:
        themeValue = 'light';
        break;
      case ThemeMode.dark:
        themeValue = 'dark';
        break;
      case ThemeMode.system:
        themeValue = 'system';
        break;
    }
    _storage.saveString(_themeKey, themeValue);
  }

  /// Toggle between Celsius and Fahrenheit
  void toggleTemperatureUnit() {
    if (temperatureUnit.value == TemperatureUnit.celsius) {
      temperatureUnit.value = TemperatureUnit.fahrenheit;
      _storage.saveString(_temperatureKey, 'fahrenheit');
    } else {
      temperatureUnit.value = TemperatureUnit.celsius;
      _storage.saveString(_temperatureKey, 'celsius');
    }
  }

  /// Toggle between km/h and mph
  void toggleWindSpeedUnit() {
    if (windSpeedUnit.value == WindSpeedUnit.kmh) {
      windSpeedUnit.value = WindSpeedUnit.mph;
      _storage.saveString(_windSpeedKey, 'mph');
    } else {
      windSpeedUnit.value = WindSpeedUnit.kmh;
      _storage.saveString(_windSpeedKey, 'kmh');
    }
  }

  // ─────────── Formatters ───────────

  /// Format temperature based on current unit preference
  String formatTemperature(double temp) {
    if (temperatureUnit.value == TemperatureUnit.fahrenheit) {
      return "${((temp * 9 / 5) + 32).toStringAsFixed(1)}°F";
    }
    return "${temp.toStringAsFixed(1)}°C";
  }

  /// Format wind speed based on current unit preference
  String formatWindSpeed(double speed) {
    if (windSpeedUnit.value == WindSpeedUnit.mph) {
      return "${(speed * 0.621371).toStringAsFixed(1)} mph";
    }
    return "${speed.toStringAsFixed(1)} km/h";
  }
}
