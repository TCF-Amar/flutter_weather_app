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

  /// Calculate moon progress (0.0 = sunset, 1.0 = next sunrise)
  double _getMoonProgress(String sunset, String nextSunrise) {
    final now = DateTime.now();
    final set = DateTime.parse(sunset);
    final nextRise = DateTime.parse(nextSunrise);

    // Before sunset - position at left (0.0)
    if (now.isBefore(set)) {
      return 0.0;
    }

    // After next sunrise - position at right (1.0)
    if (now.isAfter(nextRise)) {
      return 1.0;
    }

    // During night - calculate progress
    final totalMinutes = nextRise.difference(set).inMinutes;
    if (totalMinutes <= 0) {
      return 0.5; // Default to middle if invalid
    }

    final passedMinutes = now.difference(set).inMinutes;
    return passedMinutes / totalMinutes;
  }

  @override
  Widget build(BuildContext context) {
    final daily = weather.daily;

    final todayIndex = _getTodayIndex(daily.date);

    final sunrise = daily.sunrise[todayIndex];
    final sunset = daily.sunset[todayIndex];
    final uvIndex = daily.uvIndex[todayIndex];

    // Get tomorrow's sunrise for moon path
    final tomorrowIndex = todayIndex + 1;
    final nextSunrise = tomorrowIndex < daily.sunrise.length
        ? daily.sunrise[tomorrowIndex]
        : daily.sunrise[todayIndex]; // Fallback to today's if not available

    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          AppText(
            text: '${weather.current.isDay ? 'Sun' : 'Moon'} condition',
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
                        AppText(
                          text: weather.current.isDay ? 'Day' : 'Night',
                          fontSize: 16,
                          bold: true,
                        ),
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
                  height: 40,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final sunProgress = _getSunProgress(sunrise, sunset);
                      const sunIconSize = 22.0;
                      const sunIconHalfSize = sunIconSize / 2;

                      final maxWidth = constraints.maxWidth;
                      final sunCenterX = sunProgress * maxWidth;

                      final clampedX = sunCenterX.clamp(
                        sunIconHalfSize,
                        maxWidth - sunIconHalfSize,
                      );

                      if (weather.current.isDay) {
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
                              bottom: 15,
                              child: const Icon(
                                Icons.wb_sunny_outlined,
                                color: AppColors.orange,
                                size: sunIconSize,
                              ),
                            ),
                            Positioned(
                              left: clampedX - sunIconHalfSize - 10,
                              bottom: -16,
                              child: Icon(
                                Icons.arrow_drop_up_outlined,
                                color: AppColors.indigo,
                                size: 42,
                              ),
                            ),
                          ],
                        );
                      }

                      // Nighttime - show moon path
                      final moonProgress = _getMoonProgress(
                        sunset,
                        nextSunrise,
                      );
                      final moonCenterX = moonProgress * maxWidth;
                      final clampedMoonX = moonCenterX.clamp(
                        sunIconHalfSize,
                        maxWidth - sunIconHalfSize,
                      );

                      return Stack(
                        children: [
                          // Base line for moon path
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 2,
                              color: AppColors.indigo,
                            ),
                          ),
                          // Moon icon - positioned dynamically
                          Positioned(
                            left: clampedMoonX - sunIconHalfSize,
                            bottom: 15,
                            child: Icon(
                              Icons.nights_stay,
                              color: context.textColor,
                              size: sunIconSize,
                            ),
                          ),
                          Positioned(
                            left: clampedMoonX - sunIconHalfSize - 10,
                            bottom: -16,
                            child: Icon(
                              Icons.arrow_drop_up_outlined,
                              color: AppColors.indigo,
                              size: 42,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                ///  Sunrise / Sunset or Sunset / Next Sunrise
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      text: DateTimeHelper.formatTime(
                        weather.current.isDay ? sunrise : sunset,
                      ),
                      fontSize: 12,
                      color: AppColors.grey,
                    ),
                    AppText(
                      text: DateTimeHelper.formatTime(
                        weather.current.isDay ? sunset : nextSunrise,
                      ),
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
