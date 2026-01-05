import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';

import 'package:get/get.dart';
import 'package:weather_app/src/controllers/settings_controller.dart';

class DetailsSection extends StatelessWidget {
  final WeatherModel weather;
  DetailsSection(this.weather, {super.key});

  final SettingsController settingsController = Get.find();
  @override
  Widget build(BuildContext context) {
    /// Safe access to UV Index - use first value if available, otherwise show N/A
    final uvIndexValue = weather.daily.uvIndex.isNotEmpty
        ? weather.daily.uvIndex[0].toStringAsFixed(1)
        : "N/A";

    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.5,
        children: [
          Obx(
            () => _DetailsCard(
              title: "Temperature",
              value: settingsController.formatTemperature(
                weather.current.temperature,
              ),
            ),
          ),
          _DetailsCard(
            title: "Humidity",
            value: "${weather.current.humidity} %",
          ),
          _DetailsCard(
            title: "Wind Speed",
            value:
                "${settingsController.formatWindSpeed(weather.current.windSpeed)}",
          ),
          _DetailsCard(title: "UV Index", value: uvIndexValue),
        ],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final String title;
  final String value;

  const _DetailsCard({required this.title, required this.value});

  String _getIconPath(String title) {
    switch (title.toLowerCase()) {
      case 'humidity':
        return 'assets/images/icon_humidity.svg';
      case 'wind speed':
        return 'assets/images/icon_wind.svg';
      case 'uv index':
        return 'assets/images/icon_uv_index.svg';
      case "temperature":
        return 'assets/images/icon_temperature.svg';
      default:
        return 'assets/images/icon_fallback.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              _getIconPath(title),
              height: 34,
              width: 34,
              colorFilter: const ColorFilter.mode(
                AppColors.black,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  text: title,
                  fontSize: 14,
                  bold: false,
                  color: AppColors.black,
                ),
                const SizedBox(height: 4),
                AppText(
                  text: value,
                  fontSize: 18,
                  bold: true,
                  color: AppColors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
