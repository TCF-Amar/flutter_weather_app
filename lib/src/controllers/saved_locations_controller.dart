import 'dart:convert';
import 'package:get/get.dart';
import 'package:weather_app/core/storage/local_storage.dart';
import 'package:weather_app/core/storage/storage_keys.dart';
import 'package:weather_app/services/api/weather_api.dart';
import 'package:weather_app/src/models/place_model.dart';
import 'package:weather_app/src/models/weather_model.dart';

class SavedLocationsController extends GetxController {
  final LocalStorage storage = Get.find();

  final RxList<PlaceModel> savedLocations = <PlaceModel>[].obs;
  final RxBool isLoading = false.obs;

  // Weather data for saved locations
  final RxMap<String, WeatherModel> savedWeatherData =
      <String, WeatherModel>{}.obs;
  final RxSet<String> loadingWeather = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedLocations();
  }

  /// Generate unique key for location
  String _getLocationKey(PlaceModel place) {
    return '${place.lat}_${place.lon}';
  }

  /// Load saved locations from storage
  Future<void> loadSavedLocations() async {
    isLoading.value = true;

    try {
      final jsonString = await storage.getString(StorageKeys.savedLocations);

      if (jsonString != null && jsonString.isNotEmpty) {
        final List list = json.decode(jsonString);
        savedLocations.assignAll(
          list.map((e) => PlaceModel.fromJson(e)).toList(),
        );

        // Fetch weather for all saved locations
        await fetchAllSavedLocationsWeather();
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch weather for all saved locations
  Future<void> fetchAllSavedLocationsWeather() async {
    for (final place in savedLocations) {
      await fetchWeatherForLocation(place);
    }
  }

  /// Fetch weather for a specific location
  Future<void> fetchWeatherForLocation(PlaceModel place) async {
    final key = _getLocationKey(place);

    // Skip if already loading or already have data
    if (loadingWeather.contains(key)) return;

    loadingWeather.add(key);

    try {
      final result = await WeatherApi.fetchWeather(
        lat: place.lat,
        lon: place.lon,
      );

      result.fold(
        (failure) {
        },
        (data) {
          savedWeatherData[key] = WeatherModel(
            currentUnits: data.currentUnits,
            current: data.current,
            hourlyUnits: data.hourlyUnits,
            hourly: data.hourly,
            dailyUnits: data.dailyUnits,
            daily: data.daily,
            place: place,
          );
        },
      );
    } finally {
      loadingWeather.remove(key);
    }
  }

  /// Get weather for a specific location
  WeatherModel? getWeatherForLocation(PlaceModel place) {
    final key = _getLocationKey(place);
    return savedWeatherData[key];
  }

  /// Check if weather is loading for a location
  bool isWeatherLoading(PlaceModel place) {
    final key = _getLocationKey(place);
    return loadingWeather.contains(key);
  }

  /// Save a new location
  Future<bool> saveLocation(PlaceModel place) async {
    if (isLocationSaved(place)) return false;

    savedLocations.add(place);
    final success = await _persist();

    if (success) {
      // Fetch weather for the newly added location
      await fetchWeatherForLocation(place);
    }

    return success;
  }

  /// Remove a location
  Future<bool> removeLocation(PlaceModel place) async {
    final key = _getLocationKey(place);

    savedLocations.removeWhere((p) => p.lat == place.lat && p.lon == place.lon);
    savedWeatherData.remove(key);
    loadingWeather.remove(key);

    return _persist();
  }

  /// Check if location is saved
  bool isLocationSaved(PlaceModel place) {
    return savedLocations.any((p) => p.lat == place.lat && p.lon == place.lon);
  }

  /// Refresh weather for all saved locations
  Future<void> refreshAllWeather() async {
    await fetchAllSavedLocationsWeather();
  }

  /// Persist saved locations to storage
  Future<bool> _persist() async {
    try {
      final json = jsonEncode(savedLocations.map((e) => e.toJson()).toList());
      await storage.saveString(StorageKeys.savedLocations, json);
      return true;
    } catch (_) {
      return false;
    }
  }
}
