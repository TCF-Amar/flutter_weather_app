import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/services/routes/route_name.dart';
import 'package:weather_app/src/controllers/location_controller.dart';
import 'package:weather_app/src/controllers/place_controller.dart';
import 'package:weather_app/src/controllers/weather_controller.dart';
import 'package:weather_app/src/views/widgets/animated_text.dart';
import 'package:weather_app/src/views/widgets/app_drawer.dart';
import 'package:weather_app/src/views/widgets/app_scaffold.dart';
import 'package:weather_app/src/views/widgets/home_screen_widgets.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onMenuTap;
  final bool isDrawerOpen;

  HomeScreen({super.key, required this.onMenuTap, required this.isDrawerOpen});

  final LocationController locationController = Get.find();
  final WeatherController weatherController = Get.find();
  final PlaceController placeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      onMenuTab: onMenuTap,
      isDrawerOpen: isDrawerOpen,
      showBackButton: false,
      titleWidget: Obx(() {
        final weather = weatherController.weather.value;
        return AnimatedText(
          text: weather?.place?.name.split(',')[1] ?? 'Weather',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        );
      }),

      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.textPrimary),
          onPressed: () {
            context.pushNamed(
              RouteName.search.name,

              queryParameters: {'title': 'Search'},
            );
          },
        ),
      ],

      drawer: AppDrawer(
        onMenuTap: onMenuTap,
        weather: weatherController.weather.value,
      ),
      body: SafeArea(
        child: Obx(() {
          switch (locationController.status.value) {
            case LocationStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case LocationStatus.denied:
              return PermissionView(
                message: locationController.error.value.isNotEmpty
                    ? locationController.error.value
                    : 'Location permission denied',
                onRetry: () async {
                  // Try requesting permission again
                  await locationController.refreshLocation();
                },
                showSettingsButton: true,
                onOpenSettings: () async {
                  await locationController.openAppSettings();
                },
              );

            case LocationStatus.permanentlyDenied:
              return PermissionView(
                message: locationController.error.value.isNotEmpty
                    ? locationController.error.value
                    : 'Location permission permanently denied',
                onRetry: () async {
                  await locationController.openAppSettings();
                },
              );

            case LocationStatus.serviceDisabled:
              return PermissionView(
                message: locationController.error.value.isNotEmpty
                    ? locationController.error.value
                    : 'Location service is disabled',
                onRetry: () async {
                  await locationController.openLocationSettings();
                },
              );

            case LocationStatus.error:
              return ErrorView(
                message: locationController.error.value,
                onRetry: () async {
                  await locationController.refreshLocation();
                },
              );

            case LocationStatus.granted:
              return WeatherView(
                locationController: locationController,
                weatherController: weatherController,
                placeController: placeController,
              );

            case LocationStatus.initial:
              return const SizedBox.shrink();
          }
        }),
      ),
    );
  }
}
