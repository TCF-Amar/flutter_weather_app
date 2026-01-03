import 'package:get/get.dart';
import 'package:weather_app/services/api/lat_lon_to_place.dart';
import 'package:weather_app/src/controllers/location_controller.dart';
import 'package:weather_app/src/models/place_model.dart';

class PlaceController extends GetxController {
  final LocationController locationController = Get.find<LocationController>();

  final Rx<PlaceModel?> currentPlace = Rx<PlaceModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;


  double? _lastLat;
  double? _lastLon;

  @override
  void onInit() {
    super.onInit();

    everAll([locationController.latitude, locationController.longitude], (_) {
      if (!_hasValidLocation) return;
      if (_isSameLocation) return;

      _lastLat = locationController.latitude.value;
      _lastLon = locationController.longitude.value;

      _fetchPlace(_lastLat!, _lastLon!);
    });
  }

  bool get _hasValidLocation =>
      locationController.latitude.value != 0.0 &&
      locationController.longitude.value != 0.0;

  bool get _isSameLocation =>
      _lastLat != null &&
      _lastLon != null &&
      (_lastLat! - locationController.latitude.value).abs() < 0.00001 &&
      (_lastLon! - locationController.longitude.value).abs() < 0.00001;

  Future<void> _fetchPlace(double lat, double lon) async {
    isLoading.value = true;
    error.value = '';

    final result = await LatLonToPlace.getPlaceName(lat, lon);

    result.fold(
      (failure) {
        error.value = failure.message;
        currentPlace.value = null;
      },
      (place) {
        currentPlace.value = place;
      },
    );

    isLoading.value = false;
  }

  ///  Search selection
  void setSelectedPlace(PlaceModel place) {
    currentPlace.value = place;

    /// IMPORTANT: WeatherController ko trigger karega
    locationController.latitude.value = place.lat;
    locationController.longitude.value = place.lon;
  }
}
