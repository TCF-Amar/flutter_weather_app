import 'package:flutter/material.dart';
import 'package:weather_app/core/utils/date_utils.dart';
import 'package:weather_app/core/utils/weather_icon_mapper.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';

class ForecastList extends StatelessWidget {
  final dynamic daily;
  final List<int> indexes;

  const ForecastList({super.key, required this.daily, required this.indexes});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                // AppText(
                //   text: DateTimeHelper.isToday(date)
                //       ? "Today"
                //       : DateTimeHelper.formatShortDate(date),
                // ),
                DateTimeHelper.isToday(date)
                    ? AppText(
                        text: DateTimeHelper.formatShortDate(date),
                        bold: true,
                        color: Colors.blue,
                      )
                    : AppText(
                        text: DateTimeHelper.formatShortDate(date),
                        color: Colors.black,
                      ),
                const SizedBox(height: 8),
                Icon(
                  WeatherIconMapper.getIcon(weatherCode),
                  size: 30,
                  color: Colors.orangeAccent,
                ),
                const SizedBox(height: 8),
                Column(
                  children: [
                    Row(
                      children: [
                        AppText(text: "$maxTemp°", fontSize: 14, bold: true),
                        AppText(text: "/", fontSize: 14, bold: true),
                        AppText(text: "$minTemp°", fontSize: 14),
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
                              color: Colors.blue.shade400,
                            ),
                            const SizedBox(width: 2),
                            AppText(
                              text: "${daily.rainProbability[index]}%",
                              fontSize: 11,
                              color: Colors.blue.shade600,
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
