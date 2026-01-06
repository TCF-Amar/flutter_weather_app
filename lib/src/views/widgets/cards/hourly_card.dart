import 'package:flutter/material.dart';
import 'package:weather_app/core/theme/theme_extensions.dart';
import 'package:weather_app/core/utils/date_utils.dart';
import 'package:weather_app/core/utils/weather_icon_mapper.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';
import 'package:weather_app/src/views/widgets/lists/hourly_hours_row.dart';

class HourlyForecastCard extends StatelessWidget {
  final WeatherModel weather;

  const HourlyForecastCard({super.key, required this.weather});

  /// Get current hour index (NOW → first item)
  int _getCurrentHourIndex(List<String> times) {
    final now = DateTime.now();

    final currentHour = DateTime(now.year, now.month, now.day, now.hour);

    for (int i = 0; i < times.length; i++) {
      final time = DateTime.parse(times[i]);
      if (!time.isBefore(currentHour)) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final hourly = weather.hourly;

    final startIndex = _getCurrentHourIndex(hourly.time);
    final endIndex = (startIndex + 24) > hourly.time.length
        ? hourly.time.length
        : startIndex + 24;

    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          AppText(
            text: 'Hourly Forecast',
            bold: true,
            color: context.onBackground,
            fontSize: 20,
          ),

          const SizedBox(height: 12),

          /// CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.isDark
                  ? context.onBackground.withOpacity(0.01)
                  : context.surface,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: context.shadowColor,
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///  Condition
                AppText(
                  text: WeatherIconMapper.getText(
                    hourly.weatherCode[startIndex],
                  ),
                  fontSize: 14,
                  color: context.onBackground,
                ),

                const SizedBox(height: 4),

                ///  Date
                AppText(
                  text: DateTimeHelper.formatDate(hourly.time[startIndex]),
                  fontSize: 18,
                  bold: true,
                  color: context.onBackground,
                ),

                const SizedBox(height: 16),

                HourlyHoursRow(
                  times: hourly.time,
                  weatherCodes: hourly.weatherCode,
                  temperatures: hourly.temperature,
                  currentTemperature: weather.current.temperature,
                  startIndex: startIndex,
                  itemCount: endIndex - startIndex,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
