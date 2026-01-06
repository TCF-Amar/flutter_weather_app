import 'package:flutter/material.dart';
import 'package:weather_app/services/notification/notification_service.dart';
import 'package:weather_app/src/views/widgets/notification_payload.dart';

class TestNotificationButton extends StatelessWidget {
  const TestNotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.notifications_active),
          label: const Text('Test Now'),
          onPressed: () {
            NotificationService.instance.show(
              title: 'Test Notification',
              body: 'Notification service is working!',
              payload: NotificationPayload(
                type: 'test',
                data: 'from_button',
                route: '/search',
              ),
            );
          },
        ),
      ],
    );
  }
}
