import 'package:get/get.dart';

/// Temperature unit options
enum TemperatureUnit { celsius, fahrenheit }

/// Wind speed unit options
enum WindSpeedUnit { kmh, mph }

/// Controller for user settings and preferences
/// Manages temperature and wind speed unit preferences
class SettingsController extends GetxController {
  // ─────────── State Variables ───────────
  var temperatureUnit = TemperatureUnit.celsius.obs;
  var windSpeedUnit = WindSpeedUnit.kmh.obs;

  // ─────────── Public Methods ───────────

  /// Toggle between Celsius and Fahrenheit
  void toggleTemperatureUnit() {
    if (temperatureUnit.value == TemperatureUnit.celsius) {
      temperatureUnit.value = TemperatureUnit.fahrenheit;
    } else {
      temperatureUnit.value = TemperatureUnit.celsius;
    }
  }

  /// Toggle between km/h and mph
  void toggleWindSpeedUnit() {
    if (windSpeedUnit.value == WindSpeedUnit.kmh) {
      windSpeedUnit.value = WindSpeedUnit.mph;
    } else {
      windSpeedUnit.value = WindSpeedUnit.kmh;
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
