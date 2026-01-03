import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/core/utils/weather_icon_mapper.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';

class HourlyHoursRow extends StatelessWidget {
  final List<String> times;
  final List<int> weatherCodes;
  final List<double> temperatures;
  final double currentTemperature;
  final int startIndex;
  final int itemCount;

  const HourlyHoursRow({
    super.key,
    required this.times,
    required this.weatherCodes,
    required this.temperatures,
    required this.currentTemperature,
    required this.startIndex,
    required this.itemCount,
  });

  String _formatHour(String time) {
    try {
      return DateFormat.jm().format(DateTime.parse(time));
    } catch (e) {
      return "N/A";
    }
  }

  bool _isNow(String time) {
    try {
      final now = DateTime.now();
      final t = DateTime.parse(time);
      return t.year == now.year &&
          t.month == now.month &&
          t.day == now.day &&
          t.hour == now.hour;
    } catch (e) {
      return false;
    }
  }

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
      return const Center(
        child: AppText(text: "No hourly data available"),
      );
    }

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: safeItemCount,
        separatorBuilder: (_, __) => const SizedBox(width: 20),
        itemBuilder: (context, i) {
          final index = startIndex + i;
          
          // Double-check bounds (shouldn't happen, but safety first)
          if (index >= times.length ||
              index >= weatherCodes.length ||
              index >= temperatures.length) {
            return const SizedBox.shrink();
          }

          final timeStr = times[index];
          final isNow = _isNow(timeStr);

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Hour / NOW
              AppText(
                text: _formatHour(timeStr),
                fontSize: 13,
                color: isNow ? Colors.blue : Colors.grey,
                bold: isNow,
              ),

              const SizedBox(height: 8),

              /// Weather Icon
              Icon(
                WeatherIconMapper.getIcon(weatherCodes[index]),
                size: 30,
                color: Colors.orangeAccent,
              ),

              const SizedBox(height: 8),

              /// Temperature
              AppText(
                text: "${isNow ? currentTemperature : temperatures[index]}°C",
                fontSize: 14,
                bold: true,
              ),
            ],
          );
        },
      ),
    );
  }
}
