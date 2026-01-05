import 'package:flutter/material.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';

class WindPressureCard extends StatelessWidget {
  final WeatherModel weather;

  const WindPressureCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          const AppText(
            text: 'Wind',
            fontSize: 20,
            bold: true,
            color: AppColors.black,
          ),

          /// 🔹 Card
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///  Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        AppText(
                          text: 'Conditions',
                          fontSize: 12,
                          color: AppColors.grey,
                        ),
                        SizedBox(height: 4),
                        AppText(text: 'Pressure', fontSize: 16, bold: true),
                      ],
                    ),
                    const Icon(Icons.tune, size: 18, color: AppColors.indigo),
                  ],
                ),

                const SizedBox(height: 24),

                /// 🔹 Content Row
                Row(
                  children: [
                    /// 🌬 Wind Icon
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        // color: AppColors.indigo.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.air_rounded,
                        color: AppColors.indigo,
                        size: 46,
                      ),
                    ),

                    const SizedBox(width: 36),

                    /// 📊 Wind & Pressure
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// Wind
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AppText(
                                text: 'Wind',
                                fontSize: 12,
                                color: AppColors.grey,
                              ),
                              const SizedBox(height: 4),
                              AppText(
                                text:
                                    '${weather.current.windSpeed.toStringAsFixed(0)} mph',
                                fontSize: 16,
                                bold: true,
                              ),
                            ],
                          ),

                          /// Barometer
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AppText(
                                text: 'Barrometer',
                                fontSize: 12,
                                color: AppColors.grey,
                              ),
                              const SizedBox(height: 4),
                              AppText(
                                text:
                                    '${weather.current.pressure.toStringAsFixed(0)} mBar',
                                fontSize: 16,
                                bold: true,
                              ),
                            ],
                          ),
                        ],
                      ),
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
