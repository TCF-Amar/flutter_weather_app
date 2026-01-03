import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';

class DetailsSection extends StatelessWidget {
  final WeatherModel weather;
  const DetailsSection(this.weather, {super.key});

  @override
  Widget build(BuildContext context) {
    /// Safe access to UV Index - use first value if available, otherwise show N/A
    final uvIndexValue = weather.daily.uvIndex.isNotEmpty
        ? weather.daily.uvIndex[0].toStringAsFixed(1)
        : "N/A";

    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.5,
        children: [
          _DetailsCard(
            title: "Temperature",
            value: "${weather.current.temperature} °C",
          ),
          _DetailsCard(
            title: "Humidity",
            value: "${weather.current.humidity} %",
          ),
          _DetailsCard(
            title: "Pressure",
            value: "${weather.current.pressure.toStringAsFixed(0)} hPa",
          ),
          _DetailsCard(title: "UV Index", value: uvIndexValue),
        ],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final String title;
  final String value;

  const _DetailsCard({required this.title, required this.value});

  String _getIconPath(String title) {
    switch (title.toLowerCase()) {
      case 'humidity':
        return 'assets/images/Vector (4).svg';
      case 'pressure':
        return 'assets/images/Vector (2).svg';
      case 'uv index':
        return 'assets/images/Vector (3).svg';
      case "temperature":
        return 'assets/images/Vector (1).svg';
      default:
        return 'assets/images/Vector.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(_getIconPath(title), height: 34, width: 34),
            const SizedBox(width: 8),
            Column(
              children: [
                const SizedBox(height: 8),
                AppText(text: title, fontSize: 14, bold: false),
                const SizedBox(height: 4),
                AppText(text: value, fontSize: 18, bold: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
