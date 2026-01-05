import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/core/utils/weather_icon_mapper.dart';
import 'package:weather_app/services/api/weather_api.dart';
import 'package:weather_app/services/routes/route_name.dart';
import 'package:weather_app/src/controllers/saved_locations_controller.dart';
import 'package:weather_app/src/models/place_model.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/views/widgets/alert_dialog.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';

import 'package:weather_app/src/controllers/settings_controller.dart';
import 'package:weather_app/core/constants/app_colors.dart';

class SavedLocationTile extends StatefulWidget {
  final PlaceModel place;

  const SavedLocationTile({super.key, required this.place});

  @override
  State<SavedLocationTile> createState() => SavedLocationTileState();
}

class SavedLocationTileState extends State<SavedLocationTile> {
  WeatherModel? _weather;
  bool _isLoading = false;
  final SettingsController settingsController = Get.find();

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await WeatherApi.fetchWeather(
        lat: widget.place.lat,
        lon: widget.place.lon,
      );

      if (!mounted) return;

      result.fold(
        (failure) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        },
        (data) {
          if (mounted) {
            setState(() {
              _weather = data;
              _isLoading = false;
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final savedLocationsController = Get.find<SavedLocationsController>();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: AppColors.textLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: const Icon(Icons.location_on, color: AppColors.textLight),
        title: AppText(
          text: widget.place.name,
          fontSize: 16,
          bold: true,
          color: AppColors.textLight,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: widget.place.displayName,
              fontSize: 12,
              color: AppColors.textLight.withValues(alpha: 0.7),
            ),
            if (_isLoading)
              const SizedBox(
                height: 12,
                width: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.textLight,
                ),
              )
            else if (_weather != null)
              Row(
                children: [
                  Icon(
                    WeatherIconMapper.getIcon(_weather!.current.weatherCode),
                    size: 16,
                    color: AppColors.textLight,
                  ),
                  const SizedBox(width: 4),
                  Obx(
                    () => AppText(
                      text: settingsController.formatTemperature(
                        _weather!.current.temperature,
                      ),
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textLight, size: 20),
          onPressed: () async {
            final bool? res = await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AppAlertDialog(
                  title: 'Remove Location',
                  content: 'Are you sure you want to remove this location?',
                  cancelText: 'Cancel',
                  okText: 'Remove',
                );
              },
            );

            if (res == true) {
              await savedLocationsController.removeLocation(widget.place);
            }
          },
        ),
        onTap: () {
          if (Scaffold.of(context).isDrawerOpen) {
            Scaffold.of(context).closeDrawer();
          }
          // Navigate to detail screen after drawer closes
          Future.delayed(const Duration(milliseconds: 100), () {
            // ignore: use_build_context_synchronously
            context.pushNamed(RouteName.details.name, extra: widget.place);
          });
        },
      ),
    );
  }
}
