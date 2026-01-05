import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:weather_app/services/routes/route_name.dart';
import 'package:weather_app/src/controllers/place_controller.dart';
import 'package:weather_app/src/controllers/saved_locations_controller.dart';
import 'package:weather_app/src/controllers/settings_controller.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/views/widgets/animated_text.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';
import 'package:weather_app/src/views/widgets/tiles/saved_location_tile.dart';
import 'package:weather_app/core/constants/app_colors.dart';

class AppDrawer extends StatelessWidget {
  final VoidCallback onMenuTap;
  final WeatherModel? weather;
  AppDrawer({super.key, required this.onMenuTap, this.weather});

  final SettingsController settingsController = Get.find();
  final PlaceController placeController = Get.find();
  final SavedLocationsController savedLocationsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.grigent1, AppColors.grigent2],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                /// Current location
                const AppText(
                  text: 'Current location',
                  fontSize: 12,
                  color: AppColors.white,
                ),
                const SizedBox(height: 10),

                GestureDetector(
                  onTap: () {
                    context.pushNamed(
                      RouteName.myLocations.name,
                      extra: weather,
                    );
                    // Just close the drawer when tapping current location
                    onMenuTap();
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Obx(
                          () => AnimatedText(
                            text:
                                placeController.currentPlace.value?.displayName
                                    .split(',')[1] ??
                                'Unknown',
                            fontSize: 18,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),

                /// Add location
                GestureDetector(
                  onTap: () {
                    // onMenuTap();

                    ///
                    context.pushNamed(
                      RouteName.search.name,
                      queryParameters: {'title': 'Add Location'},
                    );
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.add_location_alt, color: AppColors.yellow),
                      SizedBox(width: 10),
                      AppText(
                        text: 'Add Location',
                        fontSize: 16,
                        bold: true,
                        color: AppColors.yellow,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// Saved locations
                const AppText(
                  text: 'Saved Locations',
                  fontSize: 12,
                  color: AppColors.white,
                ),
                const SizedBox(height: 10),

                /// Saved locations list
                Expanded(
                  flex: 3,
                  child: Obx(() {
                    if (savedLocationsController.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                        ),
                      );
                    }

                    if (savedLocationsController.savedLocations.isEmpty) {
                      return const Center(
                        child: AppText(
                          text: 'No saved locations',
                          fontSize: 14,
                          color: AppColors.white,
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: savedLocationsController.savedLocations.length,
                      itemBuilder: (context, index) {
                        final place =
                            savedLocationsController.savedLocations[index];
                        return SavedLocationTile(place: place);
                      },
                    );
                  }),
                ),

                const Spacer(),

                /// Bottom menu
                _bottomItem(
                  context,
                  title: 'Settings',
                  onTap: () {
                    onMenuTap();
                    context.pushNamed(RouteName.settings.name);
                  },
                ),
                const SizedBox(height: 16),
                _bottomItem(
                  context,
                  title: 'Share this app',
                  onTap: () {
                    // onMenuTap();
                    SharePlus.instance.share(
                      ShareParams(text: 'Share this app'),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _bottomItem(
                  context,
                  title: 'Rate this app',
                  onTap: () {
                    onMenuTap();
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Bottom menu item
  Widget _bottomItem(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AppText(
        text: title,
        fontSize: 18,
        color: AppColors.white,
        bold: true,
      ),
    );
  }
}
