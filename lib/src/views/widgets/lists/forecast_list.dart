import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/core/utils/date_utils.dart';
import 'package:weather_app/core/utils/weather_icon_mapper.dart';
import 'package:weather_app/src/controllers/settings_controller.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/core/theme/theme_extensions.dart';

class ForecastList extends StatelessWidget {
  final dynamic daily;
  final List<int> indexes;

  ForecastList({super.key, required this.daily, required this.indexes});
  final SettingsController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: indexes.length,
        itemBuilder: (context, index) {
          final i = indexes[index];
          final date = daily.date[i];
          final weatherCode = daily.weatherCode[i];
          final maxTemp = daily.maxTemp[i];
          final minTemp = daily.minTemp[i];
          return Container(
            margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Column(
              children: [
                DateTimeHelper.isToday(date)
                    ? AppText(
                        text: DateTimeHelper.formatShortDate(date),
                        bold: true,
                        color: AppColors.blue,
                      )
                    : AppText(
                        text: DateTimeHelper.formatShortDate(date),
                        color: context.onSurface,
                      ),
                const SizedBox(height: 8),
                Icon(
                  WeatherIconMapper.getIcon(weatherCode),
                  size: 30,
                  color: AppColors.orangeAccent,
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    Row(
                      children: [
                        AppText(
                          text: " ${controller.formatTemperature(maxTemp)}",
                          fontSize: 14,
                          bold: true,
                        ),
                        AppText(text: " /", fontSize: 12, bold: true),
                        AppText(
                          text: " ${controller.formatTemperature(minTemp)}",
                          fontSize: 10,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (index < daily.rainProbability.length &&
                        daily.rainProbability[index] > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.water_drop,
                              size: 12,
                              color: AppColors.blueAccent,
                            ),
                            const SizedBox(width: 2),
                            AppText(
                              text: "${daily.rainProbability[index]}%",
                              fontSize: 11,
                              color: AppColors.blue,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
