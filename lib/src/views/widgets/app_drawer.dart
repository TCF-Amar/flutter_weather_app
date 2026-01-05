import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/services/routes/route_name.dart';
import 'package:weather_app/src/controllers/place_controller.dart';
import 'package:weather_app/src/controllers/saved_locations_controller.dart';
import 'package:weather_app/src/controllers/settings_controller.dart';
import 'package:weather_app/src/views/widgets/animated_text.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';
import 'package:weather_app/src/views/widgets/tiles/saved_location_tile.dart';

class AppDrawer extends StatelessWidget {
  final VoidCallback onMenuTap;

  AppDrawer({super.key, required this.onMenuTap});

  final SettingsController settingsController = Get.find();
  final PlaceController placeController = Get.find();
  final SavedLocationsController savedLocationsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3F6FD8), Color(0xFF7BA7F9)],
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
                  color: Colors.white70,
                ),
                const SizedBox(height: 10),

                GestureDetector(
                  onTap: () {
                    onMenuTap();
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Obx(
                          () => AnimatedText(
                            text:
                                placeController.currentPlace.value?.name ??
                                'Unknown',
                            fontSize: 18,
                            color: Colors.white,
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
                    onMenuTap();

                    ///
                    context.pushNamed(
                      RouteName.search.name,
                      queryParameters: {'title': 'Add Location'},
                    );
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.add_location_alt, color: Colors.yellow),
                      SizedBox(width: 10),
                      AppText(
                        text: 'Add Location',
                        fontSize: 16,
                        bold: true,
                        color: Colors.yellow,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// Saved locations
                const AppText(
                  text: 'Saved Locations',
                  fontSize: 12,
                  color: Colors.white70,
                ),
                const SizedBox(height: 10),

                /// Saved locations list
                Expanded(
                  flex: 3,
                  child: Obx(() {
                    if (savedLocationsController.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    if (savedLocationsController.savedLocations.isEmpty) {
                      return const Center(
                        child: AppText(
                          text: 'No saved locations',
                          fontSize: 14,
                          color: Colors.white70,
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
                    onMenuTap();
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
      child: AppText(text: title, fontSize: 15, color: Colors.white),
    );
  }
}
