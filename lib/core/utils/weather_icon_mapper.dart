import 'package:flutter/material.dart';

class WeatherIconMapper {
  static IconData getIcon(int code, {bool isDay = true}) {
    switch (code) {
      case 0:
        return isDay ? Icons.wb_sunny : Icons.nightlight_round;

      case 1:
      case 2:
        return isDay ? Icons.sunny : Icons.cloud;

      case 3:
        return Icons.cloud;

      case 45:
      case 48:
        return Icons.foggy;

      case 51:
      case 53:
      case 55:
        return Icons.grain;

      case 61:
      case 63:
      case 65:
        return Icons.umbrella;

      case 66:
      case 67:
        return Icons.ac_unit;

      case 71:
      case 73:
      case 75:
      case 77:
        return Icons.cloudy_snowing;

      case 80:
      case 81:
      case 82:
        return Icons.beach_access;

      case 85:
      case 86:
        return Icons.snowing;

      case 95:
      case 96:
      case 99:
        return Icons.thunderstorm;

      default:
        return Icons.help_outline;
    }
  }

  static String getText(int code) {
    switch (code) {
      case 0:
        return 'Clear Sky';
      case 1:
      case 2:
        return 'Partly Cloudy';
      case 3:
        return 'Cloudy';
      case 45:
      case 48:
        return 'Fog';
      case 51:
      case 53:
      case 55:
        return 'Drizzle';
      case 61:
      case 63:
      case 65:
        return 'Rain';
      case 71:
      case 73:
      case 75:
        return 'Snow';
      case 80:
      case 81:
      case 82:
        return 'Rain Showers';
      case 95:
        return 'Thunderstorm';
      default:
        return 'Unknown';
    }
  }
}
