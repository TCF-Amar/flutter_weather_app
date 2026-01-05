import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/src/controllers/saved_locations_controller.dart';
import 'package:weather_app/src/models/place_model.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/views/widgets/cards/main_card.dart';

class LocationsCarousel extends StatelessWidget {
  final WeatherModel currentWeather;

  const LocationsCarousel({super.key, required this.currentWeather});

  @override
  Widget build(BuildContext context) {
    final SavedLocationsController controller = Get.find();

    return Obx(() {
      final savedLocations = controller.savedLocations;
      final totalCount = 1 + savedLocations.length; // Current + saved

      return SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: totalCount,
          padding: const EdgeInsets.symmetric(horizontal: 0),
          itemBuilder: (context, index) {
            // Index 0: Current location
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SizedBox(
                  width: savedLocations.isNotEmpty ? 300 : 320,
                  child: MainCard(weather: currentWeather),
                ),
              );
            }

            // Index 1+: Saved locations
            final savedIndex = index - 1;
            final place = savedLocations[savedIndex];
            final weather = controller.getWeatherForLocation(place);
            final isLoading = controller.isWeatherLoading(place);

            if (isLoading || weather == null) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SizedBox(width: 300, child: _buildLoadingCard(place)),
              );
            }

            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: SizedBox(width: 300, child: MainCard(weather: weather)),
            );
          },
        ),
      );
    });
  }

  Widget _buildLoadingCard(PlaceModel place) {
    return Container(
      height: 200,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          colors: [
            Color.fromARGB(255, 100, 100, 100),
            Color.fromARGB(255, 150, 150, 150),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  place.name.split(',').take(2).join(', '),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Center(child: CircularProgressIndicator(color: Colors.white)),
          const Spacer(),
        ],
      ),
    );
  }
}
