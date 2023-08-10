import 'package:flutter/material.dart';
import 'package:test_task_weather_service/weather/cubit/weather_cubit.dart';

/// Отображение влажности в виде текста вместо %
class HumidityGradation extends StatelessWidget {
  const HumidityGradation({
    super.key,
    required this.state,
  });

  final WeatherState state;

  @override
  Widget build(BuildContext context) {
    final humidity = state.selectedItem == null
        ? state.currentWeather.humidity
        : state.forecast[state.selectedItem ?? 0].humidity;
    return Expanded(
      flex: 21,
      child: Text(
        humidity >= 70
            ? 'Высокая влажность'
            : humidity >= 50
                ? 'Умеренная влажность'
                : 'Низкая влажность',
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
