import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:weather_app/core/constants/app_colors.dart';
import 'package:weather_app/src/controllers/search_controller.dart';
import 'package:weather_app/src/views/widgets/app_scaffold.dart';
import 'package:weather_app/src/views/widgets/tiles/search_result_tile.dart';

class SearchScreen extends StatelessWidget {
  final String? title;

  SearchScreen({super.key, this.title = 'Search'});

  final WeatherSearchController controller = Get.find();
  final TextEditingController queryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: title,
      titleColor: AppColors.textPrimary,

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ///  Search Field
            Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Obx(
                () => TextFormField(
                  controller: queryController,
                  style: const TextStyle(fontSize: 16, color: AppColors.black),

                  decoration: InputDecoration(
                    /// border transparent
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,

                    // labelText: 'Search',
                    hintText: 'Search city name',
                    prefixIcon: const Icon(Icons.search),

                    suffixIcon: controller.currentQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: AppColors.grey,
                            ),
                            onPressed: () {
                              queryController.clear();
                              controller.currentQuery = '';
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    controller.currentQuery = value;
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.currentQuery.isEmpty) {
                  return _buildRecentSearches();
                }

                if (controller.places.isEmpty) {
                  return const Center(child: Text('No results found'));
                }

                return ListView.builder(
                  itemCount: controller.places.length,
                  itemBuilder: (context, index) {
                    final place = controller.places[index];
                    return SearchResultTile(place: place);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Obx(() {
      if (controller.recentSearches.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search, size: 64, color: AppColors.grey),
              SizedBox(height: 16),
              Text(
                'Search for a city',
                style: TextStyle(fontSize: 16, color: AppColors.grey),
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Searches',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  controller.clearRecentSearches();
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: controller.recentSearches.length,
              itemBuilder: (context, index) {
                final place = controller.recentSearches[index];
                return SearchResultTile(place: place);
              },
            ),
          ),
        ],
      );
    });
  }
}
