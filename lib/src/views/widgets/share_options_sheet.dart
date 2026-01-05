import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:weather_app/core/utils/weather_icon_mapper.dart';
import 'package:weather_app/src/models/place_model.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';

class ShareOptionsSheet extends StatelessWidget {
  final WeatherModel weather;
  final PlaceModel place;

  const ShareOptionsSheet({
    super.key,
    required this.weather,
    required this.place,
  });

  /// Format weather data for sharing
  String _formatWeatherText() {
    final location = place.name.split(',').take(2).join(', ');
    final temp = weather.current.temperature.toStringAsFixed(1);
    final condition = WeatherIconMapper.getText(weather.current.weatherCode);
    final wind = weather.current.windSpeed.toStringAsFixed(1);
    final humidity = weather.current.humidity;

    return '''
📍 Location: $location
🌡️ Temperature: $temp°C
☁️ Conditions: $condition
💨 Wind: $wind km/h
💧 Humidity: $humidity%

Shared from Weather App
''';
  }

  /// Share via native share sheet
  void _shareViaApps(BuildContext context) {
    final text = _formatWeatherText();
    SharePlus.instance.share(ShareParams(text: text));
    Navigator.pop(context);
  }

  /// Copy to clipboard
  void _copyToClipboard(BuildContext context) {
    final text = _formatWeatherText();
    Clipboard.setData(ClipboardData(text: text));
    Navigator.pop(context);

    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Weather info copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 20),

          /// Title
          const AppText(text: 'Share Weather', fontSize: 20, bold: true),

          const SizedBox(height: 24),

          /// Share options
          _ShareOption(
            icon: Icons.share,
            title: 'Share via Apps',
            subtitle: 'Share to WhatsApp, Messages, etc.',
            onTap: () => _shareViaApps(context),
          ),

          const SizedBox(height: 12),

          _ShareOption(
            icon: Icons.copy,
            title: 'Copy to Clipboard',
            subtitle: 'Copy weather information',
            onTap: () => _copyToClipboard(context),
          ),

          const SizedBox(height: 24),

          /// Cancel button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Cancel'),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// Share option tile
class _ShareOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ShareOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.blue, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(text: title, fontSize: 16, bold: true),
                  const SizedBox(height: 4),
                  AppText(
                    text: subtitle,
                    fontSize: 13,
                    color: Colors.grey[600]!,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
