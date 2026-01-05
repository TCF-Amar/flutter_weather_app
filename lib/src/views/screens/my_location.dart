import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/core/utils/weather_icon_mapper.dart';
import 'package:weather_app/src/controllers/settings_controller.dart';
import 'package:weather_app/src/controllers/weather_controller.dart';
import 'package:weather_app/src/views/widgets/animated_text.dart';
import 'package:weather_app/src/views/widgets/app_scaffold.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';
import 'package:weather_app/src/views/widgets/cards/hourly_card.dart';
import 'package:weather_app/src/views/widgets/cards/seven_day_forecast.dart';
import 'package:weather_app/src/views/widgets/cards/sun_condition_card.dart';
import 'package:weather_app/src/views/widgets/cards/wind_card.dart';
import 'package:weather_app/src/views/widgets/share_options_sheet.dart';

class MyLocationsScreen extends StatelessWidget {
  MyLocationsScreen({super.key});
  final SettingsController settingsController = Get.find();
  final WeatherController weatherController = Get.find();

  @override
  Widget build(BuildContext context) {
    final weather = weatherController.weather.value!;
    return AppScaffold(
      title: 'My Locations',
      actions: [
        IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) =>
                  ShareOptionsSheet(weather: weather, place: weather.place!),
            );
          },
          icon: Icon(Icons.share),
        ),
      ],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      colors: [AppColors.grigent1, AppColors.grigent2],
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        WeatherIconMapper.getIcon(weather.current.weatherCode),
                        size: 50,
                        color: AppColors.orange,
                      ),
                      SizedBox(width: 20),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedText(
                              text: weather.place!.displayName,
                              color: AppColors.white,
                            ),
                            AppText(
                              text: WeatherIconMapper.getText(
                                weather.current.weatherCode,
                              ),
                              color: AppColors.white,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),

                      AppText(
                        text: settingsController.formatTemperature(
                          weather.current.temperature,
                        ),
                        fontSize: 26,
                        color: AppColors.white,
                        // bold: true,
                      ),
                    ],
                  ),
                ),
                HourlyForecastCard(weather: weather),
                SevenDayForecast(weather: weather),
                WindPressureCard(weather: weather),
                SunConditionCard(weather: weather),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
