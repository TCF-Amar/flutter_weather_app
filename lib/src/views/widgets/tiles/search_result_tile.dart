import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/services/routes/route_name.dart';
import 'package:weather_app/src/controllers/search_controller.dart';
import 'package:weather_app/src/models/place_model.dart';

class SearchResultTile extends StatelessWidget {
  final PlaceModel place;

  const SearchResultTile({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final searchController = Get.find<WeatherSearchController>();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: const Icon(
          Icons.location_on,
          color: Color.fromARGB(255, 33, 37, 243),
        ),
        title: Text(
          place.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          place.displayName,
          style: const TextStyle(fontSize: 12),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Save to recent searches
          searchController.addRecentSearch(place);
          // Navigate to detail screen where weather will be loaded
          context.push(RouteName.details.path, extra: place);
        },
      ),
    );
  }
}
