import 'package:get/get.dart';
import 'package:weather_app/src/controllers/place_controller.dart';
import 'package:weather_app/src/controllers/saved_locations_controller.dart';
import 'package:weather_app/src/controllers/search_controller.dart';
import 'package:weather_app/src/controllers/weather_controller.dart';
import 'package:weather_app/src/controllers/location_controller.dart';
import 'package:weather_app/src/controllers/settings_controller.dart';

class InitializeDependency extends Bindings {
  @override
  void dependencies() {
    Get.put(SavedLocationsController(), permanent: true);

    Get.put(SettingsController(), permanent: true);
    Get.put(LocationController(), permanent: true);
    Get.put(PlaceController(), permanent: true);
    Get.put(WeatherController(), permanent: true);
    Get.put(WeatherSearchController(), permanent: true);
  }
}
