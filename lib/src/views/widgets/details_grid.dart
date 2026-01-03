import 'package:flutter/material.dart';
import 'package:weather_app/src/models/weather_model.dart';
import 'package:weather_app/src/views/widgets/app_text.dart';

class DetailsGrid extends StatelessWidget {
  final WeatherModel weather;
  const DetailsGrid({super.key, required this.weather});

 @override
  Widget build(BuildContext context) {
    final uvIndexValue = weather.daily.uvIndex.isNotEmpty
        ? weather.daily.uvIndex[0].toStringAsFixed(1)
        : "N/A";

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _DetailsCard(
          title: "Temperature",
          value: "${weather.current.temperature} °C",
        ),
        _DetailsCard(title: "Humidity", value: "${weather.current.humidity} %"),
        _DetailsCard(
          title: "Pressure",
          value: "${weather.current.pressure.toStringAsFixed(0)} hPa",
        ),
        _DetailsCard(title: "UV Index", value: uvIndexValue),
      ],
    );
  }
}


class _DetailsCard extends StatelessWidget {
  final String title;
  final String value;

  const _DetailsCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(text: title, fontSize: 14, bold: false),
            const SizedBox(height: 8),
            AppText(text: value, fontSize: 18, bold: true),
          ],
        ),
      ),
    );
  }
}

