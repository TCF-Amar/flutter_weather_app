import 'package:get/get.dart';
import 'package:weather_app/services/api/weather_api.dart';
import 'package:weather_app/src/controllers/location_controller.dart';
import 'package:weather_app/src/controllers/place_controller.dart';
import 'package:weather_app/src/models/weather_model.dart';

class WeatherController extends GetxController {
  late final LocationController locationController;
  late final PlaceController placeController;

  /// Weather state with optional place information
  final Rx<WeatherModel?> weather = Rx<WeatherModel?>(null);

  /// UI state
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  double? _lastLat;
  double? _lastLon;

  late Worker _locationWorker;
  late Worker _placeWorker;

  @override
  void onInit() {
    super.onInit();

    // Safely find after super.onInit()
    locationController = Get.find<LocationController>();
    placeController = Get.find<PlaceController>();

    // Listen to coordinate changes
    _locationWorker = everAll(
      [locationController.latitude, locationController.longitude],
      (_) {
        if (!_hasValidLocation) return;
        if (_isSameLocation) return;

        _lastLat = locationController.latitude.value;
        _lastLon = locationController.longitude.value;

        loadWeather(_lastLat!, _lastLon!);
      },
    );

    // Listen to place changes and update weather model
    _placeWorker = ever(
      placeController.currentPlace,
      (place) {
        if (weather.value != null) {
          // Update existing weather model with new place
          weather.value = WeatherModel(
            currentUnits: weather.value!.currentUnits,
            current: weather.value!.current,
            hourlyUnits: weather.value!.hourlyUnits,
            hourly: weather.value!.hourly,
            dailyUnits: weather.value!.dailyUnits,
            daily: weather.value!.daily,
            place: place,
          );
        }
      },
    );
  }

  @override
  void onReady() {
    super.onReady();
    //  Load initial weather if location already available
    if (_hasValidLocation) {
      _lastLat = locationController.latitude.value;
      _lastLon = locationController.longitude.value;
      loadWeather(_lastLat!, _lastLon!);
    }
  }

  /// ───────────────── Helpers ─────────────────

  bool get _hasValidLocation =>
      locationController.latitude.value != 0.0 &&
      locationController.longitude.value != 0.0;

  bool _sameCoords(double a, double b) => (a - b).abs() < 0.001;

  bool get _isSameLocation =>
      _lastLat != null &&
      _lastLon != null &&
      _sameCoords(_lastLat!, locationController.latitude.value) &&
      _sameCoords(_lastLon!, locationController.longitude.value);

  /// ───────────────── API ─────────────────

  Future<void> loadWeather(double lat, double lon) async {
    isLoading.value = true;
    error.value = '';

    try {
      final result = await WeatherApi.fetchWeather(lat: lat, lon: lon);

      result.fold(
        (failure) {
          error.value = failure.message;
          weather.value = null;
        },
        (data) {
          // Attach current place to weather model
          final currentPlace = placeController.currentPlace.value;
          weather.value = WeatherModel(
            currentUnits: data.currentUnits,
            current: data.current,
            hourlyUnits: data.hourlyUnits,
            hourly: data.hourly,
            dailyUnits: data.dailyUnits,
            daily: data.daily,
            place: currentPlace,
          );
        },
      );
    } catch (e) {
      error.value = 'Unexpected error: $e';
      weather.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _locationWorker.dispose();
    _placeWorker.dispose();
    super.onClose();
  }
}
