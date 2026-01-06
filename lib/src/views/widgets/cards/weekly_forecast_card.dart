import 'package:flutter/material.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/core/theme/theme_extensions.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';
import 'package:weather_app/src/views/widgets/lists/weekly_list.dart';

class WeeklyForecastCard extends StatefulWidget {
  final WeatherModel weather;

  const WeeklyForecastCard({super.key, required this.weather});

  @override
  State<WeeklyForecastCard> createState() => _WeeklyForecastCardState();
}

class _WeeklyForecastCardState extends State<WeeklyForecastCard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final daily = widget.weather.daily;

    // Validate data
    if (daily.date.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: context.shadowColor,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Center(child: AppText(text: 'No forecast data available')),
      );
    }

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    final List<int> pastIndexes = [];
    final List<int> futureIndexes = [];

    for (int i = 0; i < daily.date.length; i++) {
      try {
        final date = DateTime.parse(daily.date[i]);
        date.isBefore(todayDate) ? pastIndexes.add(i) : futureIndexes.add(i);
      } catch (e) {
        // Skip invalid dates
        continue;
      }
    }

    final past7 = pastIndexes.takeLast(7).toList();
    final next7 = futureIndexes.take(7).toList();

    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(text: 'Weekly Forecast', fontSize: 20, bold: true),
          const SizedBox(height: 12),

          ///  Card
          Container(
            decoration: BoxDecoration(
              color: context.surface,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: context.shadowColor,
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 8),

                ///  Tabs (pill style)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelColor: AppColors.white,
                    unselectedLabelColor: AppColors.grey,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorWeight: 4,
                    dividerColor: AppColors.transparent,
                    tabs: [
                      Tab(text: 'Past 7 days'),
                      Tab(text: 'Forecast'),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                ///  Content
                SizedBox(
                  height: 550,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      WeeklyList(daily: daily, indexes: past7.toList()),
                      WeeklyList(daily: daily, indexes: next7),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension TakeLast<E> on List<E> {
  List<E> takeLast(int n) => length <= n ? this : sublist(length - n);
}
