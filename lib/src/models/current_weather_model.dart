import 'package:equatable/equatable.dart';

class CurrentWeather extends Equatable {
  final DateTime time;
  final bool isDay;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final int weatherCode;
  final double pressure;
  final int cloudCover;
  final double windSpeed;
  final double windGust;
  final int windDirection;
  final double precipitation;

  const CurrentWeather({
    required this.time,
    required this.isDay,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.weatherCode,
    required this.pressure,
    required this.cloudCover,
    required this.windSpeed,
    required this.windGust,
    required this.windDirection,
    required this.precipitation,
  });

  ///  API → Model
  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      time: DateTime.parse(json['time']),
      isDay: json['is_day'] == 1,
      temperature: (json['temperature_2m'] as num).toDouble(),
      feelsLike: (json['apparent_temperature'] as num).toDouble(),
      humidity: json['relative_humidity_2m'] as int,
      weatherCode: json['weather_code'] as int,
      pressure: (json['pressure_msl'] as num).toDouble(),
      cloudCover: json['cloud_cover'] as int,
      windSpeed: (json['wind_speed_10m'] as num).toDouble(),
      windGust: (json['wind_gusts_10m'] as num).toDouble(),
      windDirection: json['wind_direction_10m'] as int,
      precipitation: (json['precipitation'] as num).toDouble(),
    );
  }

  ///  Model → JSON (cache / storage ke liye)
  Map<String, dynamic> toJson() {
    return {
      'time': time.toIso8601String(),
      'is_day': isDay ? 1 : 0,
      'temperature_2m': temperature,
      'apparent_temperature': feelsLike,
      'relative_humidity_2m': humidity,
      'weather_code': weatherCode,
      'pressure_msl': pressure,
      'cloud_cover': cloudCover,
      'wind_speed_10m': windSpeed,
      'wind_gusts_10m': windGust,
      'wind_direction_10m': windDirection,
      'precipitation': precipitation,
    };
  }

  /// Immutable update (recommended)
  CurrentWeather copyWith({
    DateTime? time,
    bool? isDay,
    double? temperature,
    double? feelsLike,
    int? humidity,
    int? weatherCode,
    double? pressure,
    int? cloudCover,
    double? windSpeed,
    double? windGust,
    int? windDirection,
    double? precipitation,
  }) {
    return CurrentWeather(
      time: time ?? this.time,
      isDay: isDay ?? this.isDay,
      temperature: temperature ?? this.temperature,
      feelsLike: feelsLike ?? this.feelsLike,
      humidity: humidity ?? this.humidity,
      weatherCode: weatherCode ?? this.weatherCode,
      pressure: pressure ?? this.pressure,
      cloudCover: cloudCover ?? this.cloudCover,
      windSpeed: windSpeed ?? this.windSpeed,
      windGust: windGust ?? this.windGust,
      windDirection: windDirection ?? this.windDirection,
      precipitation: precipitation ?? this.precipitation,
    );
  }

  ///  Equatable (state comparison)
  @override
  List<Object?> get props => [
    time,
    isDay,
    temperature,
    feelsLike,
    humidity,
    weatherCode,
    pressure,
    cloudCover,
    windSpeed,
    windGust,
    windDirection,
    precipitation,
  ];
}
