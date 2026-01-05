import 'package:weather_app/src/models/route_model.dart';

class RouteName {
  static final home = RouteModel(name: "home", path: "/");
  static final splash = RouteModel(name: "splash", path: "/splash");
  static final details = RouteModel(name: "details", path: "/details");
  static final search = RouteModel(name: "search", path: "/search");
  static final news = RouteModel(name: "news", path: "/news");
  static final settings = RouteModel(name: "settings", path: "/settings");
  static final myLocations = RouteModel(name: "myLocations", path: "/myLocations");
}
