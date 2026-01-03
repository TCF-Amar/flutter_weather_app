import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/core/utils/weather_icon_mapper.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';
import 'package:weather_app/src/views/widgets/hourly_hours_row.dart';

class HourlyForecastCard extends StatelessWidget {
  final WeatherModel weather;

  const HourlyForecastCard({super.key, required this.weather});

  /// 🔹 Get current hour index (NOW → first item)
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


  String _formatDate(String time) {
    return DateFormat('MMMM d, yyyy').format(DateTime.parse(time));
  }


  @override
  Widget build(BuildContext context) {
    final hourly = weather.hourly;

    final startIndex = _getCurrentHourIndex(hourly.time);
    final endIndex = (startIndex + 24) > hourly.time.length
        ? hourly.time.length
        : startIndex + 24;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 HEADER
          const AppText(
            text: 'Hourly Forecast',
            bold: true,
            color: Colors.black,
            fontSize: 20,
          ),

          const SizedBox(height: 12),

          /// 🔹 CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 Condition
                AppText(
                  text: WeatherIconMapper.getText(
                    hourly.weatherCode[startIndex],
                  ),
                  fontSize: 14,
                  color: Colors.grey,
                ),

                const SizedBox(height: 4),

                /// 🔹 Date
                AppText(
                  text: _formatDate(hourly.time[startIndex]),
                  fontSize: 18,
                  bold: true,
                ),

                const SizedBox(height: 16),

                /// 🔹 24 HOURS (Scrollable)
                //   SizedBox(
                //     height: 110,
                //     child: ListView.separated(
                //       scrollDirection: Axis.horizontal,
                //       itemCount: endIndex - startIndex,
                //       separatorBuilder: (_, __) => const SizedBox(width: 20),
                //       itemBuilder: (context, i) {
                //         final index = startIndex + i;
                //         final isNow = _isNow(hourly.time[index]);

                //         return Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             /// Hour / NOW
                //             AppText(
                //               text: _formatHour( hourly.time[index]),
                //               fontSize: 13,
                //               color: isNow ? Colors.blue : Colors.grey,
                //               bold: isNow,
                //             ),

                //             const SizedBox(height: 8),

                //             /// Weather Icon
                //             Icon(
                //               WeatherIconMapper.getIcon(
                //                 hourly.weatherCode[index],
                //               ),
                //               size: 30,
                //               color: Colors.orangeAccent,
                //             ),

                //             const SizedBox(height: 8),

                //             /// Temperature
                //             AppText(
                //               text: "${ isNow ? weather.current.temperature : hourly.temperature[index]}°C",
                //               fontSize: 14,
                //               bold: true,
                //             ),
                //           ],
                //         );
                //       },
                //     ),
                //   ),
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
