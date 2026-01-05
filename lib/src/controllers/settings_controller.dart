import 'package:get/get.dart';

enum TemperatureUnit { celsius, fahrenheit }

enum WindSpeedUnit { kmh, mph }

class SettingsController extends GetxController {
  var temperatureUnit = TemperatureUnit.celsius.obs;
  var windSpeedUnit = WindSpeedUnit.kmh.obs;

  void toggleTemperatureUnit() {
    if (temperatureUnit.value == TemperatureUnit.celsius) {
      temperatureUnit.value = TemperatureUnit.fahrenheit;
    } else {
      temperatureUnit.value = TemperatureUnit.celsius;
    }
  }

  void toggleWindSpeedUnit() {
    if (windSpeedUnit.value == WindSpeedUnit.kmh) {
      windSpeedUnit.value = WindSpeedUnit.mph;
    } else {
      windSpeedUnit.value = WindSpeedUnit.kmh;
    }
  }

  String formatTemperature(double temp) {
    if (temperatureUnit.value == TemperatureUnit.fahrenheit) {
      return "${((temp * 9 / 5) + 32).toStringAsFixed(1)}°F";
    }
    return "${temp.toStringAsFixed(1)}°C";
  }

  String formatWindSpeed(double speed) {
    if (windSpeedUnit.value == WindSpeedUnit.mph) {
      return "${(speed * 0.621371).toStringAsFixed(1)} mph";
    }
    return "${speed.toStringAsFixed(1)} km/h";
  }
}
