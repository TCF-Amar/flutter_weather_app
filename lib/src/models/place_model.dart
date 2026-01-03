class PlaceModel {
  final String name;
  final String country;
  final String? state;
  final double lat;
  final double lon;

  const PlaceModel({
    required this.name,
    required this.country,
    this.state,
    required this.lat,
    required this.lon,
  });

  /// 🔍 Name → Lat/Lon (Open-Meteo search)
  factory PlaceModel.fromSearchJson(Map<String, dynamic> json) {
    final latValue = json['latitude'];
    final lonValue = json['longitude'];

    if (latValue == null || lonValue == null) {
      throw FormatException('Missing latitude or longitude in place data');
    }

    return PlaceModel(
      name: json['name']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      state: json['admin1']?.toString(),
      lat: (latValue as num).toDouble(),
      lon: (lonValue as num).toDouble(),
    );
  }

  /// 📍 Lat/Lon → Place (Reverse geocoding)
  factory PlaceModel.fromReverseJson(Map<String, dynamic> json) {
    final address = json['address'] as Map<String, dynamic>?;

    return PlaceModel(
      name: json['display_name'] ?? address?['city'] ?? 'Unknown',
      country: address?['country'] ?? '',
      state: address?['state'],
      lat: double.parse(json['lat']),
      lon: double.parse(json['lon']),
    );
  }

  /// From JSON (for SharedPreferences)
  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      name: json['name']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      state: json['state']?.toString(),
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );
  }

  /// To JSON (for SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
      'state': state,
      'lat': lat,
      'lon': lon,
    };
  }

  String get displayName =>
      state != null ? '$name, $state, $country' : '$name, $country';
}
