import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/core/utils/date_utils.dart';
import 'package:weather_app/core/utils/weather_icon_mapper.dart';
import 'package:weather_app/src/controllers/details_controller.dart';
import 'package:weather_app/src/controllers/saved_locations_controller.dart';
import 'package:weather_app/src/models/place_model.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/views/widgets/animated_text.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';
import 'package:weather_app/src/views/widgets/derails_section.dart';
import 'package:weather_app/src/views/widgets/hourly_hours_row.dart';

class DetailsScreen extends StatefulWidget {
  final PlaceModel place;

  const DetailsScreen({super.key, required this.place});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final SavedLocationsController savedPlaceController = Get.find();
  final DetailsController detailsController = Get.put(DetailsController());



  // Local state for this screen only (doesn't affect home screen)


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);

    /// Schedule weather loading after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      detailsController.loadWeather(widget.place);
    });
  }

  /// Load weather data for the specific place

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// 🔹 Get 24 hourly indexes for a specific day

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoadingValue = detailsController.isLoading.value;
      final weatherValue = detailsController.weather.value;
      final errorValue = detailsController.error.value;

      if (isLoadingValue || weatherValue == null) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Loading'),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              

              onPressed: () {
                context.pop();
              },
            ),
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
      } 

      if (errorValue.isNotEmpty) {
        return Scaffold(
          appBar: AppBar(title: Text('Error')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  errorValue,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: (){
                    detailsController.loadWeather(widget.place);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }

      return Scaffold(
        body: Stack(
          children: [
            ///  HEADER
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).size.height * 0.6,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.42,
                padding: const EdgeInsets.only(top: 40),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 0, 140, 255),
                      Color.fromARGB(255, 60, 160, 243),
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(28),
                  ),
                ),
                child: Column(
                  children: [
                    /// Top bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              context.pop();
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: AnimatedText(
                              text: widget.place.name,
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Obx(() {
                            return savedPlaceController.savedLocations.contains(
                                  widget.place,
                                )
                                ? IconButton(
                                    onPressed: () {
                                      savedPlaceController.removeLocation(
                                        widget.place,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.bookmark,
                                      color: Colors.white,
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      savedPlaceController.saveLocation(
                                        widget.place,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.bookmark_outline,
                                      color: Colors.white,
                                    ),
                                  );
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// Weather icon
                    Icon(
                      WeatherIconMapper.getIcon(
                        weatherValue.current.weatherCode,
                      ),
                      size: 70,
                      color: Colors.white,
                    ),

                    AppText(
                      text: WeatherIconMapper.getText(
                        weatherValue.current.weatherCode,
                      ),
                      fontSize: 20,
                      bold: true,
                      color: Colors.white,
                    ),

                    AppText(
                      text: DateTimeHelper.formatDate(
                        weatherValue.current.time.toString(),
                      ),
                      fontSize: 16,
                      color: Colors.white70,
                      bold: true,
                    ),
                  ],
                ),
              ),
            ),

            ///  HOURLY TABS CARD
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    /// Tabs
                    TabBar(
                      controller: _tabController,

                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.blue,
                      tabs: const [
                        Tab(text: "Yesterday"),
                        Tab(text: "Today"),
                        Tab(text: "Tomorrow"),
                      ],
                    ),

                    /// Tab content
                    SizedBox(
                      height: 120,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          /// Yesterday
                          _HourlyTab(
                            weather: weatherValue,
                            indexes: detailsController.getHourlyIndexesByDay(
                              DateTime.now().subtract(const Duration(days: 1)),
                              weatherValue,
                            ),
                          ),

                          /// Today
                          _HourlyTab(
                            weather: weatherValue,
                            indexes: detailsController.getHourlyIndexesByDay(
                              DateTime.now(),
                              weatherValue,
                            ),
                          ),

                          /// Tomorrow
                          _HourlyTab(
                            weather: weatherValue,
                            indexes: detailsController.getHourlyIndexesByDay(
                              DateTime.now().add(const Duration(days: 1)),
                              weatherValue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ///  DETAILS SECTION
            Positioned(
              top: MediaQuery.of(context).size.height * 0.56,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).size.height * 0.1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(text: "Details", fontSize: 20, bold: true),
                  DetailsSection(weatherValue),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

/// ───────
/// HOURLY TAB (Reusable, uses HourlyHoursRow)
/// ───────

class _HourlyTab extends StatelessWidget {
  final WeatherModel weather;
  final List<int> indexes;

  const _HourlyTab({required this.weather, required this.indexes});

  @override
  Widget build(BuildContext context) {
    if (indexes.isEmpty) {
      return const Center(child: AppText(text: "No hourly data"));
    }

    return HourlyHoursRow(
      times: weather.hourly.time,
      weatherCodes: weather.hourly.weatherCode,
      temperatures: weather.hourly.temperature,
      currentTemperature: weather.current.temperature,
      startIndex: indexes.first,
      itemCount: indexes.length,
    );
  }
}
