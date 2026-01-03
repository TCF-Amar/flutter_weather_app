class DailyWeather {
  final List<String> date;
  final List<int> weatherCode;
  final List<double> maxTemp;
  final List<double> minTemp;
  final List<String> sunrise;
  final List<String> sunset;
  final List<double> uvIndex;
  final List<int> rainProbability;
  final List<double> windSpeedMax;

  DailyWeather({
    required this.date,
    required this.weatherCode,
    required this.maxTemp,
    required this.minTemp,
    required this.sunrise,
    required this.sunset,
    required this.uvIndex,
    required this.rainProbability,
    required this.windSpeedMax,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    return DailyWeather(
      date: List<String>.from(json['time']),
      weatherCode: List<int>.from(json['weather_code']),
      maxTemp: _toDoubleList(json['temperature_2m_max']),
      minTemp: _toDoubleList(json['temperature_2m_min']),
      sunrise: List<String>.from(json['sunrise']),
      sunset: List<String>.from(json['sunset']),
      uvIndex: _toDoubleList(json['uv_index_max']),
      rainProbability: List<int>.from(json['precipitation_probability_max']),
      windSpeedMax: _toDoubleList(json['wind_speed_10m_max']),
    );
  }

  static List<double> _toDoubleList(List list) =>
      list.map((e) => (e as num).toDouble()).toList();
}
