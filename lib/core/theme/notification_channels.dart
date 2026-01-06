import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationChannels {
  NotificationChannels._();

  static const String weatherChannelId = 'weather_alerts';
  static const String weatherChannelName = 'Weather Alerts';
  static const String weatherChannelDesc =
      'Weather alerts and important updates';

  static const AndroidNotificationDetails weatherAndroidDetails =
      AndroidNotificationDetails(
        weatherChannelId,
        weatherChannelName,
        channelDescription: weatherChannelDesc,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        enableLights: true,
      );
}
