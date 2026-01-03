import 'package:weather_app/src/models/current_weather_model.dart';
import 'package:weather_app/src/models/daily_model.dart';
import 'package:weather_app/src/models/hourly_model.dart';
import 'package:weather_app/src/models/place_model.dart';
import 'package:weather_app/src/models/weather_units.dart';

class WeatherModel {
  final WeatherUnits currentUnits;
  final CurrentWeather current;

  final WeatherUnits hourlyUnits;
  final HourlyWeather hourly;

  final WeatherUnits dailyUnits;
  final DailyWeather daily;

  final PlaceModel? place;

  WeatherModel({
    required this.currentUnits,
    required this.current,
    required this.hourlyUnits,
    required this.hourly,
    required this.dailyUnits,
    required this.daily,
    this.place,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      currentUnits: WeatherUnits.fromJson(json['current_units']),
      current: CurrentWeather.fromJson(json['current']),
      hourlyUnits: WeatherUnits.fromJson(json['hourly_units']),
      hourly: HourlyWeather.fromJson(json['hourly']),
      dailyUnits: WeatherUnits.fromJson(json['daily_units']),
      daily: DailyWeather.fromJson(json['daily']),
    );
  }

}
