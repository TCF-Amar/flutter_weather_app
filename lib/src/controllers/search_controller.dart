import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:weather_app/core/storage/local_storage.dart';
import 'package:weather_app/core/storage/storage_keys.dart';
import 'package:weather_app/services/api/place_to_lat_lon.dart';
import 'package:weather_app/src/models/place_model.dart';

class WeatherSearchController extends GetxController {
  ///  Search result list
  final RxList<PlaceModel> places = <PlaceModel>[].obs;

  final LocalStorage storage = Get.find();

  ///  Search text
  final RxString query = ''.obs;

  ///  UI states
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  final RxList<PlaceModel> recentSearches = <PlaceModel>[].obs;
  static const int _maxItems = 5;
  Timer? _debounce;

  String get currentQuery => query.value;
  set currentQuery(String value) {
    query.value = value;
    _onQueryChanged();
  }

  @override
  void onInit() {
    super.onInit();
    loadRecentSearches();
  }

  ///  Debounce handler
  void _onQueryChanged() {
    _debounce?.cancel();

    _debounce = Timer(const Duration(seconds: 1), () {
      searchPlace();
    });
  }

  Future<void> searchPlace() async {
    final q = query.value.trim().toLowerCase();

    if (q.isEmpty) {
      places.clear();
      error.value = '';
      return;
    }

    try {
      isLoading.value = true;
      error.value = '';

      final result = await PlaceToLatLon.getLatLon(q);

      result.fold(
        (failure) {
          error.value = failure.message;
          places.clear();
        },
        (data) {
          places.value = data;
        },
      );
    } catch (e) {
      error.value = 'Unable to search location';
      places.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadRecentSearches() async {
    final jsonString = await storage.getString(StorageKeys.recentSearches);

    if (jsonString == null || jsonString.isEmpty) return;

    final List list = jsonDecode(jsonString);
    recentSearches.assignAll(list.map((e) => PlaceModel.fromJson(e)).toList());
  }

  Future<void> addRecentSearch(PlaceModel place) async {
    recentSearches.removeWhere((p) => p.lat == place.lat && p.lon == place.lon);

    recentSearches.insert(0, place);

    if (recentSearches.length > _maxItems) {
      recentSearches.removeLast();
    }

    await _persist();
  }

  Future<void> clearRecentSearches() async {
    recentSearches.clear();
    await storage.remove(StorageKeys.recentSearches);
  }

  Future<void> _persist() async {
    final json = jsonEncode(recentSearches.map((e) => e.toJson()).toList());
    await storage.saveString(StorageKeys.recentSearches, json);
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}
