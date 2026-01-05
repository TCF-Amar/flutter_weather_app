import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/src/controllers/splash_controller.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashController splashController;

  @override
  void initState() {
    super.initState();
    // Initialize splash controller
    splashController = Get.put(SplashController(), permanent: false);

    // Set navigation callback
    splashController.onNavigate = (path) {
      if (mounted) {
        context.go(path);
      }
    };
  }

  @override
  void dispose() {
    // Clean up controller when screen is disposed
    Get.delete<SplashController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder: (controller) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.grigent1,
                  AppColors.grigent1,
                  AppColors.grigent1,
                  AppColors.grigent2,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud,
                    size: 100,
                    color: AppColors.white,
                    shadows: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const AppText(
                    text: 'Cloudy',
                    fontSize: 44,
                    bold: true,
                    color: AppColors.white,
                  ),
                  const SizedBox(height: 10),
                  const AppText(
                    text: "Don't  worry, we'll get you \nthe weather you need",
                    fontSize: 20,
                    bold: true,
                    color: AppColors.white,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 40),
                  const CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => AppText(
                      text: controller.statusMessage.value,
                      fontSize: 14,
                      color: AppColors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
