import 'package:get/get.dart';
import 'package:weather_app/services/api/weather_api.dart';
import 'package:weather_app/src/models/place_model.dart';
import 'package:weather_app/src/models/weather_model.dart';

class DetailsController extends GetxController {

  final Rx<WeatherModel?> weather = Rx<WeatherModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  Future<void> loadWeather(PlaceModel place) async {
    isLoading.value = true;
    error.value = '';

    try {
      final result = await WeatherApi.fetchWeather(
        lat: place.lat,
        lon: place.lon,
      );

      result.fold(
            (failure) {
          error.value = failure.message;
          weather.value = null;
        },
            (data) {
          // Attach the place to the weather model
          weather.value = WeatherModel(
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
    } catch (e) {
      error.value = 'Unexpected error: $e';
      weather.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  List<int> getHourlyIndexesByDay(DateTime day, WeatherModel weather) {
    final target = DateTime(day.year, day.month, day.day);
    final times = weather.hourly.time;

    if (times.isEmpty) {
      return [];
    }

    final List<int> indexes = [];

    for (int i = 0; i < times.length; i++) {
      try {
        final t = DateTime.parse(times[i]);
        if (t.year == target.year &&
            t.month == target.month &&
            t.day == target.day) {
          indexes.add(i);
        }
      } catch (e) {
        /// Skip invalid date strings
        continue;
      }
    }

    return indexes.take(24).toList();
  }



}