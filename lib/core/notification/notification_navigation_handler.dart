import 'package:flutter/foundation.dart';
import 'package:weather_app/services/notification/notification_service.dart';
import 'package:weather_app/services/routes/app_route.dart';
import 'package:weather_app/core/notification/notification_payload.dart';

class NotificationNavigationHandler {
  static void init() {
    NotificationService.instance.onTap.listen((response) {
      final payloadStr = response.payload;
      if (payloadStr == null) return;

      try {
        final payload = NotificationPayload.fromJson(payloadStr);
        AppRoute.router.push(payload.route);
      } catch (e) {
        debugPrint('Notification navigation error: $e');
      }
    });
  }
}
