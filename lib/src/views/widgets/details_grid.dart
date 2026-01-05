import 'package:flutter/material.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';

import 'package:get/get.dart';
import 'package:weather_app/src/controllers/settings_controller.dart';

class DetailsGrid extends StatelessWidget {
  final WeatherModel weather;
  DetailsGrid({super.key, required this.weather});

  final SettingsController settingsController = Get.find();

  @override
  Widget build(BuildContext context) {
    final uvIndexValue =
        weather.daily.uvIndex.isNotEmpty
            ? weather.daily.uvIndex[0].toStringAsFixed(1)
            : "N/A";

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        Obx(
          () => _DetailsCard(
            title: "Temperature",
            value: settingsController.formatTemperature(
              weather.current.temperature,
            ),
          ),
        ),
        _DetailsCard(title: "Humidity", value: "${weather.current.humidity} %"),
        _DetailsCard(
          title: "Pressure",
          value: "${weather.current.pressure.toStringAsFixed(0)} hPa",
        ),
        _DetailsCard(title: "UV Index", value: uvIndexValue),
      ],
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final String title;
  final String value;

  const _DetailsCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              text: title,
              fontSize: 14,
              bold: false,
              color: Colors.black54,
            ),
            const SizedBox(height: 8),
            AppText(text: value, fontSize: 18, bold: true, color: Colors.black),
          ],
        ),
      ),
    );
  }
}

