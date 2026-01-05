import 'package:flutter/material.dart';
import 'package:weather_app/core/utils/date_utils.dart';
import 'package:weather_app/core/utils/weather_icon_mapper.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';

class WeeklyList extends StatelessWidget {
  final dynamic daily;
  final List<int> indexes;

  const WeeklyList({super.key, required this.daily, required this.indexes});

  @override
  Widget build(BuildContext context) {
    if (indexes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: AppText(text: 'No data available'),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: indexes.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final index = indexes[i];

        // Validate index bounds
        if (index >= daily.date.length ||
            index >= daily.weatherCode.length ||
            index >= daily.maxTemp.length ||
            index >= daily.minTemp.length) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            // color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            // border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: Row(
            children: [
              ///  Icon
              Icon(
                WeatherIconMapper.getIcon(daily.weatherCode[index]),
                size: 32,
                color: Colors.orangeAccent,
              ),
              const SizedBox(width: 10),

              ///  Day + Date
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: DateTimeHelper.formatDay(daily.date[index]),
                      bold: true,
                      fontSize: 15,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      text: DateTimeHelper.formatDate(daily.date[index]),
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),

              ///  Temp + Rain probability
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppText(
                          text: "${daily.maxTemp[index].round()}°",
                          bold: true,
                          fontSize: 16,
                        ),
                        const SizedBox(width: 4),
                        AppText(
                          text: "/ ${daily.minTemp[index].round()}°",
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
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
              ),
            ],
          ),
        );
      },
    );
  }
}
