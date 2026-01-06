import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/core/theme/theme_extensions.dart';
import 'package:weather_app/services/routes/route_name.dart';
import 'package:weather_app/src/controllers/search_controller.dart';
import 'package:weather_app/src/models/place_model.dart';

class SearchResultTile extends StatelessWidget {
  final PlaceModel place;
  final VoidCallback? onTap;

  const SearchResultTile({super.key, required this.place, this.onTap});

  @override
  Widget build(BuildContext context) {
    final searchController = Get.find<WeatherSearchController>();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: context.onBackground.withOpacity(0.1),
   
      ),
      child: ListTile(
        leading: Icon(Icons.location_on, color: context.onBackground),
        title: Text(place.name, style: context.textTheme.titleMedium),
        subtitle: Text(
          place.displayName,
          style: context.textTheme.bodyMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Icon(Icons.chevron_right, color: context.onBackground),
        onTap: () {
          onTap?.call();
          // Save to recent searches
          searchController.addRecentSearch(place);
          // Navigate to detail screen where weather will be loaded
          context.push(RouteName.details.path, extra: place);
        },
      ),
    );
  }
}
