import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/core/theme/theme_extensions.dart';
import 'package:weather_app/core/utils/weather_icon_mapper.dart';
import 'package:weather_app/services/routes/route_name.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';

import 'package:get/get.dart';
import 'package:weather_app/src/controllers/settings_controller.dart';

class MainCard extends StatelessWidget {
  final WeatherModel weather;

  MainCard({super.key, required this.weather});

  final SettingsController settingsController = Get.find();

  @override
  Widget build(BuildContext context) {
    final place = weather.place;
    if (place == null) return const SizedBox();

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        context.pushNamed(RouteName.details.name, extra: weather.place);
      },
      child: Container(
        // height: 200,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            colors: [context.gradient1, context.gradient2],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///  Top Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: "Chance of rain ${weather.current.precipitation}%",
                      color: AppColors.white,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      text: WeatherIconMapper.getText(
                        weather.current.weatherCode,
                      ),
                      fontSize: 30,
                      bold: true,
                      color: AppColors.white,
                    ),
                  ],
                ),
                Icon(
                  WeatherIconMapper.getIcon(
                    weather.current.weatherCode,
                    isDay: weather.current.isDay,
                  ),
                  size: 90,
                  color: AppColors.white,
                ),
              ],
            ),

            const SizedBox(height: 10),

            ///  Location
            Row(
              children: [
                const Icon(Icons.location_on, color: AppColors.white),
                const SizedBox(width: 4),
                Expanded(
                  child: AppText(
                    text: place.name.split(',').take(2).join(', '),
                    color: AppColors.white,
                    bold: true,
                    maxLines: 1,
                  ),
                ),
              ],
            ),

            const Spacer(),

            ///  Bottom Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => AppText(
                    text: settingsController.formatTemperature(
                      weather.current.temperature,
                    ),
                    fontSize: 30,
                    bold: true,
                    color: AppColors.white,
                  ),
                ),

                Obx(
                  () => _infoItem(
                    'assets/images/Vector (2).svg',
                    settingsController.formatWindSpeed(
                      weather.current.windSpeed,
                    ),
                  ),
                ),

                _infoItem(
                  'assets/images/icon_humidity.svg',
                  "${weather.current.humidity}%",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///  Reusable Info Item
  Widget _infoItem(String asset, String text) {
    return Row(
      children: [
        SvgPicture.asset(
          asset,
          height: 20,
          width: 20,
          colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
        ),
        const SizedBox(width: 6),
        AppText(text: text, color: AppColors.white, bold: true),
      ],
    );
  }
}
