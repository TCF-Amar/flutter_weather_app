import 'package:flutter/material.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/core/theme/theme_extensions.dart';
import 'package:weather_app/core/utils/date_utils.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';

class SunConditionCard extends StatelessWidget {
  final WeatherModel weather;

  const SunConditionCard({super.key, required this.weather});

  int _getTodayIndex(List<String> dates) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (int i = 0; i < dates.length; i++) {
      final date = DateTime.parse(dates[i]);
      if (date.year == today.year &&
          date.month == today.month &&
          date.day == today.day) {
        return i;
      }
    }
    return 0;
  }

  /// Calculate sun progress (0.0 = sunrise, 1.0 = sunset)
  double _getSunProgress(String sunrise, String sunset) {
    final now = DateTime.now();
    final rise = DateTime.parse(sunrise);
    final set = DateTime.parse(sunset);

    // Before sunrise - position at left (0.0)
    if (now.isBefore(rise)) {
      return 0.0;
    }

    // After sunset - position at right (1.0)
    if (now.isAfter(set)) {
      return 1.0;
    }

    // During day - calculate progress
    final totalMinutes = set.difference(rise).inMinutes;
    if (totalMinutes <= 0) {
      return 0.5; // Default to middle if invalid
    }

    final passedMinutes = now.difference(rise).inMinutes;
    return passedMinutes / totalMinutes;
  }

  @override
  Widget build(BuildContext context) {
    final daily = weather.daily;

    final todayIndex = _getTodayIndex(daily.date);

    final sunrise = daily.sunrise[todayIndex];
    final sunset = daily.sunset[todayIndex];
    final uvIndex = daily.uvIndex[todayIndex];

    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          AppText(
            text: 'Sun condition',
            fontSize: 20,
            bold: true,
            color: context.textColor,
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.isDark
                  ? context.onBackground.withOpacity(0.01)
                  : context.surface,
              borderRadius: BorderRadius.circular(28),
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
                ///  Header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: 'Conditions',
                          fontSize: 12,
                          color: AppColors.grey,
                        ),
                        SizedBox(height: 4),
                        AppText(text: 'Sun', fontSize: 16, bold: true),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const AppText(
                          text: 'UV index',
                          fontSize: 12,
                          color: AppColors.grey,
                        ),
                        const SizedBox(height: 4),
                        AppText(
                          text: uvIndex.toStringAsFixed(1),
                          fontSize: 16,
                          bold: true,
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                ///  Sun path
                SizedBox(
                  height: 30,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final sunProgress = _getSunProgress(sunrise, sunset);
                      const sunIconSize = 22.0;
                      const sunIconHalfSize = sunIconSize / 2;

                      // Calculate sun position from left (0.0) to right (1.0)
                      final maxWidth = constraints.maxWidth;
                      final sunCenterX = sunProgress * maxWidth;

                      // Clamp to keep icon within bounds
                      final clampedX = sunCenterX.clamp(
                        sunIconHalfSize,
                        maxWidth - sunIconHalfSize,
                      );

                      return Stack(
                        children: [
                          // Base line
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 2,
                              color: AppColors.indigo,
                            ),
                          ),
                          // Sun icon - positioned dynamically
                          Positioned(
                            left: clampedX - sunIconHalfSize,
                            bottom: 2,
                            child: const Icon(
                              Icons.wb_sunny_outlined,
                              color: AppColors.orange,
                              size: sunIconSize,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                ///  Sunrise / Sunset
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      text: DateTimeHelper.formatTime(sunrise),
                      fontSize: 12,
                      color: AppColors.grey,
                    ),
                    AppText(
                      text: DateTimeHelper.formatTime(sunset),
                      fontSize: 12,
                      color: AppColors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
