import 'package:weather_app/core/notification/notification_payload.dart';

class AppNotification {
  final String title;
  final String body;
  final DateTime time;
  final NotificationPayload payload;

  AppNotification({
    required this.title,
    required this.body,
    required this.time,
    required this.payload,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'body': body,
    'time': time.toIso8601String(),
    'payload': payload.toJson(),
  };

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      title: json['title'],
      body: json['body'],
      time: DateTime.parse(json['time']),
      payload: NotificationPayload.fromJson(json['payload']),
    );
  }
}
