class HourlyWeather {
  final List<String> time;
  final List<double> temperature;
  final List<double> feelsLike;
  final List<int> humidity;
  final List<int> weatherCode;
  final List<double> windSpeed;
  final List<int> windDirection;
  final List<double> windGust;
  final List<double> precipitation;
  final List<int> precipitationProbability;
  final List<int> cloudCover;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.weatherCode,
    required this.windSpeed,
    required this.windDirection,
    required this.windGust,
    required this.precipitation,
    required this.precipitationProbability,
    required this.cloudCover,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    final int length = (json['time'] as List).length;

    return HourlyWeather(
      time: List<String>.from(json['time']),
      temperature: _toDoubleList(json['temperature_2m']),
      feelsLike: _toDoubleList(json['apparent_temperature']),
      humidity: List<int>.from(json['relative_humidity_2m']),
      weatherCode: List<int>.from(json['weather_code']),
      windSpeed: _toDoubleList(json['wind_speed_10m']),
      windDirection: List<int>.from(json['wind_direction_10m']),
      windGust: _toDoubleList(json['wind_gusts_10m']),
      precipitation: _toDoubleList(json['precipitation']),
      precipitationProbability: json['precipitation_probability'] != null
          ? List<int>.from(json['precipitation_probability'])
          : List.filled(length, 0),
      cloudCover: List<int>.from(json['cloud_cover']),
    );
  }

  static List<double> _toDoubleList(List list) =>
      list.map((e) => (e as num).toDouble()).toList();
}
