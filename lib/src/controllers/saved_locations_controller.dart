import 'dart:convert';
import 'package:get/get.dart';
import 'package:weather_app/core/storage/local_storage.dart';
import 'package:weather_app/core/storage/storage_keys.dart';
import 'package:weather_app/src/models/place_model.dart';

class SavedLocationsController extends GetxController {
  final LocalStorage storage = Get.find();

  final RxList<PlaceModel> savedLocations = <PlaceModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedLocations();
  }

  Future<void> loadSavedLocations() async {
    isLoading.value = true;

    try {
      final jsonString = await storage.getString(StorageKeys.savedLocations);

      if (jsonString != null && jsonString.isNotEmpty) {
        final List list = json.decode(jsonString);
        savedLocations.assignAll(
          list.map((e) => PlaceModel.fromJson(e)).toList(),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> saveLocation(PlaceModel place) async {
    if (isLocationSaved(place)) return false;

    savedLocations.add(place);
    return _persist();
  }

  Future<bool> removeLocation(PlaceModel place) async {
    savedLocations.removeWhere((p) => p.lat == place.lat && p.lon == place.lon);
    return _persist();
  }

  bool isLocationSaved(PlaceModel place) {
    return savedLocations.any((p) => p.lat == place.lat && p.lon == place.lon);
  }

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
