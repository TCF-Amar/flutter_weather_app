import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/services/routes/route_name.dart';
import 'package:weather_app/src/controllers/location_controller.dart';
import 'package:weather_app/src/controllers/place_controller.dart';
import 'package:weather_app/src/controllers/weather_controller.dart';
import 'package:weather_app/src/models/news_model.dart';
import 'package:weather_app/src/views/widgets/animated_text.dart';
import 'package:weather_app/src/views/widgets/app_drawer.dart';
import 'package:weather_app/src/views/widgets/app_scaffold.dart';
import 'package:weather_app/src/views/widgets/cards/hourly_card.dart';
import 'package:weather_app/src/views/widgets/cards/main_card.dart';
import 'package:weather_app/src/views/widgets/cards/news_container.dart';
import 'package:weather_app/src/views/widgets/cards/seven_day_forecast.dart';
import 'package:weather_app/src/views/widgets/cards/sun_condition_card.dart';
import 'package:weather_app/src/views/widgets/cards/weekly_forecast_card.dart';
import 'package:weather_app/src/views/widgets/cards/wind_card.dart';

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
          text:
              weather?.place?.name ??
              placeController.currentPlace.value?.name ??
              'Weather',
          fontSize: 24,
          // color: Colors.white,
          fontWeight: FontWeight.bold,
        );
      }),

      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            context.pushNamed(
              RouteName.search.name,
              queryParameters: {'title': 'Search'},
            );
          },
        ),
      ],

      drawer: AppDrawer(onMenuTap: onMenuTap),
      body: SafeArea(
        child: Obx(() {
          switch (locationController.status.value) {
            case LocationStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case LocationStatus.denied:
              return _PermissionView(
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
              return _PermissionView(
                message: locationController.error.value.isNotEmpty
                    ? locationController.error.value
                    : 'Location permission permanently denied',
                onRetry: () async {
                  await locationController.openAppSettings();
                },
              );

            case LocationStatus.serviceDisabled:
              return _PermissionView(
                message: locationController.error.value.isNotEmpty
                    ? locationController.error.value
                    : 'Location service is disabled',
                onRetry: () async {
                  await locationController.openLocationSettings();
                },
              );

            case LocationStatus.error:
              return _ErrorView(
                message: locationController.error.value,
                onRetry: () async {
                  await locationController.refreshLocation();
                },
              );

            case LocationStatus.granted:
              return _WeatherView(
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

class _WeatherView extends StatelessWidget {
  final LocationController locationController;
  final WeatherController weatherController;

  final PlaceController placeController;

  _WeatherView({
    required this.locationController,
    required this.weatherController,
    required this.placeController,
  });

  final news = NewsModel(
    id: 'news_1',
    title:
        'New Visual Standards Set by Striking Portrait Emphasizing the Power of Focal Points',
    description:
        'In a bold new visual release that is rapidly gaining attention across creative circles, a striking close-up portrait has emerged as a textbook example of how the focal point can transform an image’s impact. The image places the subject’s eyes and facial features at the heart of the frame, drawing the viewer’s attention instantly to the most expressive elements of the composition. This technique—long underscored by photography and design experts as the key to compelling visuals—makes use of sharp focus, contrast, and natural lighting to guide the viewer’s gaze to precisely where the creator intends. Experts say this approach aligns perfectly with fundamental principles of visual hierarchy and image composition, where a clear focal point not only captivates but also tells a nuanced story about the subject and mood.',
    imageUrl:
        'https://ix-marketing.imgix.net/focalpoint.png?auto=format,compress&w=1946',
    author: 'John Doe',
    time: '14 min ago',
  );
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (weatherController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (weatherController.error.isNotEmpty) {
        return Center(
          child: Column(
            children: [
              Text(weatherController.error.value),
              ElevatedButton(
                onPressed: () {
                  locationController.refreshLocation();
                  weatherController.loadWeather(
                    locationController.latitude.value,
                    locationController.longitude.value,
                  );
                },
                child: Text('Retry'),
              ),
            ],
          ),
        );
      }

      final weather = weatherController.weather.value;
      if (weather == null) {
        return const Center(child: Text('No weather data'));
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainCard(weather: weather),
            HourlyForecastCard(weather: weather),
            WeeklyForecastCard(weather: weather),
            // SevenDayForecast(weather: weather),
            SunConditionCard(weather: weather),
            WindPressureCard(
              windSpeed: weather.current.windSpeed,
              pressure: weather.current.pressure,
            ),
            NewsCard(news: news),
          ],
        ),
      );
    });
  }
}

class _PermissionView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final bool showSettingsButton;
  final VoidCallback? onOpenSettings;

  const _PermissionView({
    required this.message,
    required this.onRetry,
    this.showSettingsButton = false,
    this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            if (showSettingsButton && onOpenSettings != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: onOpenSettings,
                    icon: const Icon(Icons.settings),
                    label: const Text('Settings'),
                  ),
                ],
              )
            else
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.settings),
                label: const Text('Go to settings'),
              ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
