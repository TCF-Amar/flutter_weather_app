import 'package:go_router/go_router.dart';
import 'package:weather_app/services/routes/route_name.dart';
import 'package:weather_app/src/models/news_model.dart';
import 'package:weather_app/src/models/place_model.dart';
import 'package:weather_app/src/views/screens/details_screen.dart';
import 'package:weather_app/src/views/screens/home_wrapper.dart';
import 'package:weather_app/src/views/screens/my_location.dart';
import 'package:weather_app/src/views/screens/news_screen.dart';
import 'package:weather_app/src/views/screens/search_screen.dart';
import 'package:weather_app/src/views/screens/splash_screen.dart';
import 'package:weather_app/src/views/screens/settings_screen.dart';

class AppRoute {
  static final GoRouter router = GoRouter(
    initialLocation: RouteName.splash.path,
    debugLogDiagnostics: false,

    routes: <GoRoute>[
      GoRoute(
        path: RouteName.splash.path,
        name: RouteName.splash.name,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteName.home.path,
        name: RouteName.home.name,
        builder: (context, state) => HomeWrapper(),
      ),
      GoRoute(
        path: RouteName.details.path,
        name: RouteName.details.name,
        builder: (context, state) {
          return DetailsScreen(place: state.extra as PlaceModel);
        },
      ),
      GoRoute(
        path: RouteName.search.path,
        name: RouteName.search.name,
        builder: (context, state) {
          return SearchScreen(title: state.uri.queryParameters['title']);
        },
      ),
      GoRoute(
        path: RouteName.news.path,
        name: RouteName.news.name,
        builder: (context, state) {
          return NewsScreen(news: state.extra as NewsModel);
        },
      ),
      GoRoute(
        path: RouteName.settings.path,
        name: RouteName.settings.name,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: RouteName.myLocations.path,
        name: RouteName.myLocations.name,
        builder: (context, state) {

         return   MyLocationsScreen();
        }
      ),
    ],
  );
}
