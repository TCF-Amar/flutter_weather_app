import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/src/controllers/settings_controller.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';
import 'package:weather_app/src/views/widgets/settings_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.find();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const AppText(
          text: 'Settings',
          fontSize: 20,
          bold: true,
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.grey[50]),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: [
              const SettingsSectionHeader(title: "Units"),
              const SizedBox(height: 12),
              SettingsCard(
                child: Column(
                  children: [
                    Obx(
                      () => SettingsToggle(
                        title: "Weather",
                        options: [
                          ToggleOption(
                            label: "°C",
                            isSelected:
                                settingsController.temperatureUnit.value ==
                                TemperatureUnit.celsius,
                            onTap: () =>
                                settingsController.temperatureUnit.value =
                                    TemperatureUnit.celsius,
                          ),
                          ToggleOption(
                            label: "°F",
                            isSelected:
                                settingsController.temperatureUnit.value ==
                                TemperatureUnit.fahrenheit,
                            onTap: () =>
                                settingsController.temperatureUnit.value =
                                    TemperatureUnit.fahrenheit,
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () => SettingsToggle(
                        title: "Wind Speed",
                        options: [
                          ToggleOption(
                            label: "km/h",
                            isSelected:
                                settingsController.windSpeedUnit.value ==
                                WindSpeedUnit.kmh,
                            onTap: () =>
                                settingsController.windSpeedUnit.value =
                                    WindSpeedUnit.kmh,
                          ),
                          ToggleOption(
                            label: "mph",
                            isSelected:
                                settingsController.windSpeedUnit.value ==
                                WindSpeedUnit.mph,
                            onTap: () =>
                                settingsController.windSpeedUnit.value =
                                    WindSpeedUnit.mph,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const SettingsSectionHeader(title: "App"),
              const SizedBox(height: 12),
              SettingsCard(
                child: Column(
                  children: [
                    SettingsItem(
                      icon: Icons.check_circle_outline,
                      title: "Terms of service",
                      onTap: () {},
                    ),
                    SettingsItem(
                      icon: Icons.info_outline,
                      title: "About weather app",
                      onTap: () {},
                    ),
                    SettingsItem(
                      icon: Icons.share,
                      title: "Share app",
                      onTap: () {},
                    ),
                    SettingsItem(
                      icon: Icons.group_outlined,
                      title: "Join with us",
                      onTap: () {},
                    ),
                    SettingsItem(
                      icon: Icons.data_usage,
                      title: "Mobile data limit",
                      onTap: () {},
                    ),
                    const SettingsItem(
                      icon: Icons.info_outline,
                      title: "Version",
                      trailing: AppText(
                        text: "1.0.0",
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const SettingsSectionHeader(title: "Account"),
              const SizedBox(height: 12),
              SettingsCard(
                child: Column(
                  children: [
                    SettingsItem(
                      icon: Icons.logout,
                      title: "Logout",
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
