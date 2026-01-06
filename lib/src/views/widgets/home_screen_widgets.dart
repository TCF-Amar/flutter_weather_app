import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/src/controllers/location_controller.dart';
import 'package:weather_app/src/controllers/place_controller.dart';
import 'package:weather_app/src/controllers/weather_controller.dart';
import 'package:weather_app/src/models/news_model.dart';
import 'package:weather_app/src/views/test_notification_button.dart';
import 'package:weather_app/src/views/widgets/cards/hourly_card.dart';
import 'package:weather_app/src/views/widgets/cards/news_container.dart';
import 'package:weather_app/src/views/widgets/cards/seven_day_forecast.dart';
import 'package:weather_app/src/views/widgets/cards/sun_condition_card.dart';
import 'package:weather_app/src/views/widgets/cards/wind_card.dart';
import 'package:weather_app/src/views/widgets/locations_carousel.dart';

class WeatherView extends StatelessWidget {
  final LocationController locationController;
  final WeatherController weatherController;

  final PlaceController placeController;

  WeatherView({
    super.key,
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
        'https://images.unsplash.com/photo-1767304590980-9c075c875c38?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw3fHx8ZW58MHx8fHx8',
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
            LocationsCarousel(currentWeather: weather),
            TestNotificationButton(),
            HourlyForecastCard(weather: weather),
            // WeeklyForecastCard(weather: weather),
            SevenDayForecast(weather: weather),
            SunConditionCard(weather: weather),
            WindPressureCard(weather: weather),
            NewsCard(news: news),
          ],
        ),
      );
    });
  }
}

class PermissionView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final bool showSettingsButton;
  final VoidCallback? onOpenSettings;

  const PermissionView({
    super.key,
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
            const Icon(Icons.location_off, size: 64, color: AppColors.grey),
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

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: AppColors.error),
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
