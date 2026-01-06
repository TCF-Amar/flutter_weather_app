import 'dart:convert';

class NotificationPayload {
  final String type;
  final String? data;
  final String route;
  NotificationPayload({required this.type, this.data, required this.route});

  String toJson() => jsonEncode({'type': type, 'data': data, 'route': route});

  static NotificationPayload fromJson(String payload) {
    final map = jsonDecode(payload);
    return NotificationPayload(
      type: map['type'],
      data: map['data'],
      route: map['route'],
    );
  }
}
