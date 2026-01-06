import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/core/constants/app_colors.dart';

class AppAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelText;
  final String okText;

  const AppAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.cancelText,
    required this.okText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: Text(content, style: const TextStyle(fontSize: 14)),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          child: Text(
            cancelText,
            style: const TextStyle(color: AppColors.grey),
          ),
        ),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => context.pop(true),
          child: Text(okText),
        ),
      ],
    );
  }
}
