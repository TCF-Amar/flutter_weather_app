import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:weather_app/core/theme/notification_channels.dart';
import 'package:weather_app/core/notification/notification_healper.dart';
import 'package:weather_app/core/notification/notification_payload.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  final StreamController<NotificationResponse> _onTapStream =
      StreamController.broadcast();

  Stream<NotificationResponse> get onTap => _onTapStream.stream;

  ///  INIT (call in main)
  Future<void> init() async {
    // Initialize timezone
    tz.initializeTimeZones();
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone.identifier));

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosInit = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
      macOS: iosInit,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onTapStream.add,
    );

    await NotificationPermission.request(_plugin);
  }

  ///  SIMPLE NOTIFICATION
  Future<void> show({
    required String title,
    required String body,
    NotificationPayload? payload,
  }) async {
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,

      const NotificationDetails(
        android: NotificationChannels.weatherAndroidDetails,
      ),
      payload: payload?.toJson(),
    );
  }

  ///  CANCEL
  Future<void> cancelAll() async => _plugin.cancelAll();

  ///  CANCEL SPECIFIC
  Future<void> cancel(int id) async => _plugin.cancel(id);
}
