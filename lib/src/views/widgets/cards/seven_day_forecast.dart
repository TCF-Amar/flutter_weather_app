import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/core/utils/weather_icon_mapper.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';
import 'package:weather_app/src/views/widgets/weekly_list.dart';

class SevenDayForecast extends StatelessWidget {
  final WeatherModel weather;

  const SevenDayForecast({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final daily = weather.daily;

    /// Validation
    if (daily.date.isEmpty) {
      return _emptyState();
    }

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    ///  Future day indexes
    final List<int> futureIndexes = [];

    for (int i = 0; i < daily.date.length; i++) {
      try {
        final date = DateTime.parse(daily.date[i]);
        if (!date.isBefore(todayDate)) {
          futureIndexes.add(i);
        }
      } catch (_) {
        continue;
      }
    }

    ///  Take max 7 days
    final forecastIndexes = futureIndexes.take(7).toList();

    if (forecastIndexes.isEmpty) {
      return _emptyState();
    }

    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(text: "Weekly Forecast", fontSize: 20, bold: true),
          const SizedBox(height: 12),
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 26),

                  child: Row(
                    children: [
                      Column(
                        children: [
                          AppText(
                            text: WeatherIconMapper.getText(
                              weather.current.weatherCode,
                            ),
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 4),
                          AppText(
                            /// 1 jun 2026
                            text: DateFormat(
                              'd MMM yyyy',
                            ).format(DateTime.now()),
                            fontSize: 20,
                            // color: Colors.grey,
                            bold: true,


                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                WeeklyList(daily: daily, indexes: forecastIndexes),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Empty UI
  Widget _emptyState() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Center(child: AppText(text: 'No forecast data available')),
    );
  }
}
