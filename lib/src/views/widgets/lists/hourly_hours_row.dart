import 'package:flutter/material.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/core/utils/date_utils.dart';
import 'package:weather_app/core/utils/weather_icon_mapper.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';

import 'package:get/get.dart';
import 'package:weather_app/src/controllers/settings_controller.dart';

class HourlyHoursRow extends StatelessWidget {
  final List<String> times;
  final List<int> weatherCodes;
  final List<double> temperatures;
  final double currentTemperature;
  final int startIndex;
  final int itemCount;

  HourlyHoursRow({
    super.key,
    required this.times,
    required this.weatherCodes,
    required this.temperatures,
    required this.currentTemperature,
    required this.startIndex,
    required this.itemCount,
  });

  final SettingsController settingsController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Validate bounds to prevent crashes
    final maxValidIndex = [
      times.length,
      weatherCodes.length,
      temperatures.length,
    ].reduce((a, b) => a < b ? a : b);

    final safeItemCount = itemCount > 0 && startIndex < maxValidIndex
        ? (startIndex + itemCount <= maxValidIndex
              ? itemCount
              : maxValidIndex - startIndex)
        : 0;

    if (safeItemCount <= 0) {
      return const Center(child: AppText(text: "No hourly data available"));
    }

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: safeItemCount,
        separatorBuilder: (_, _) => const SizedBox(width: 20),
        itemBuilder: (context, i) {
          final index = startIndex + i;

          // Double-check bounds (shouldn't happen, but safety first)
          if (index >= times.length ||
              index >= weatherCodes.length ||
              index >= temperatures.length) {
            return const SizedBox.shrink();
          }

          final timeStr = times[index];
          final isNow = DateTimeHelper.isNow(timeStr);

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Hour / NOW
              AppText(
                text: DateTimeHelper.formatTime(timeStr),
                fontSize: 13,
                color: isNow
                    ? AppColors.blue
                    : Theme.of(context).textTheme.bodyMedium!.color,
                bold: isNow,
              ),

              const SizedBox(height: 8),

              /// Weather Icon
              Icon(
                WeatherIconMapper.getIcon(weatherCodes[index]),
                size: 30,
                color: AppColors.orangeAccent,
              ),

              const SizedBox(height: 8),

              /// Temperature
              Obx(
                () => AppText(
                  text: settingsController.formatTemperature(
                    isNow ? currentTemperature : temperatures[index],
                  ),
                  fontSize: 14,
                  bold: true,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
