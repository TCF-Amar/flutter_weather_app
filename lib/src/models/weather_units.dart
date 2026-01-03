class WeatherUnits {
  final Map<String, String> units;

  WeatherUnits({required this.units});

  factory WeatherUnits.fromJson(Map<String, dynamic> json) {
    return WeatherUnits(units: json.map((k, v) => MapEntry(k, v.toString())));
  }

  String unitOf(String key) => units[key] ?? '';
}
