import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

class MyLocationsScreen extends StatelessWidget {
  MyLocationsScreen({super.key});
  final SettingsController settingsController = Get.find();
  final WeatherController weatherController = Get.find();

  @override
  Widget build(BuildContext context) {
    final weather = weatherController.weather.value!;
    return AppScaffold(
      title: 'My Locations',
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
                      colors: [
                        Color.fromARGB(255, 0, 140, 255),
                        Color.fromARGB(255, 92, 182, 255),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        WeatherIconMapper.getIcon(weather.current.weatherCode),
                        size: 50,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 20),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedText(
                              text: weather.place!.displayName,
                              color: Colors.white,
                            ),
                            AppText(
                              text: WeatherIconMapper.getText(
                                weather.current.weatherCode,
                              ),
                              color: Colors.white,
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
                        color: Colors.white,
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
