import 'package:flutter/material.dart';
import 'package:test_task_weather_service/weather/cubit/weather_cubit.dart';

/// Отображаение угла ветра в виде текстова, вместа угла
class WindDirection extends StatelessWidget {
  const WindDirection({
    super.key,
    required this.state,
  });

  final WeatherState state;

  @override
  Widget build(BuildContext context) {
    const windDirections = [
      "северный",
      "северо-восточный",
      "восточный",
      "юго-восточный",
      "южный",
      "юго-западный",
      "западный",
      "северо-западный"
    ];
    // Для чего именно показывать направление ветра (теущая погода/выбранный час)
    final degrees = state.selectedItem == null
        ? state.currentWeather.windDeg
        : state.forecast[state.selectedItem ?? 0].windDeg;
    final direction = ((degrees / 45 + 0.5) % 8).toInt();
    return Expanded(
      flex: 21,
      child: Text(
        'Ветер ${windDirections[direction]}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
