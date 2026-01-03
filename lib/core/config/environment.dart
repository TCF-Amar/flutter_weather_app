import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static final String baseUrlGeocoding = dotenv.env['BASE_URL_GEOCODING'] ?? '';
  static final String baseUrlReverseGeocoding = dotenv.env['BASE_URL_REVERSE_GEOCODING'] ?? '';
  static final String baseUrlWeather = dotenv.env['BASE_URL_WEATHER'] ?? '';

  /// Validates that all required environment variables are set
  static bool validate() {
    final missing = <String>[];
    
    if (baseUrlGeocoding.isEmpty) missing.add('BASE_URL_GEOCODING');
    if (baseUrlReverseGeocoding.isEmpty) missing.add('BASE_URL_REVERSE_GEOCODING');
    if (baseUrlWeather.isEmpty) missing.add('BASE_URL_WEATHER');
    
    if (missing.isNotEmpty) {
      throw Exception('Missing required environment variables: ${missing.join(', ')}');
    }
    
    return true;
  }
}