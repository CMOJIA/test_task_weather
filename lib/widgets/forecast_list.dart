import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:test_task_weather_service/weather/cubit/weather_cubit.dart';
import 'package:test_task_weather_service/widgets/forecast_icon.dart';

/// Список прогноза погоды по часам
class ForecastList extends StatelessWidget {
  const ForecastList({super.key, required this.state});

  final WeatherState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(state.forecast.length, (index) {
              String formattedDate =
                  DateFormat.Hm().format(state.forecast[index].dateTime);
              return GestureDetector(
                onTap: () {
                  context.read<WeatherCubit>().selectForecastItem(index: index);
                },
                child: Container(
                  decoration: index == state.selectedItem
                      ? BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        )
                      : null,
                  // Чтобы на экран вмещалось ровно 4 элемента списка
                  width: (constraints.maxWidth) / 4,
                  // Если элемент выбран - добавляются границы к контейнеру, которые увеличивают его размер на 1 по пириметру
                  padding: index == state.selectedItem
                      ? const EdgeInsets.all(15)
                      : const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Время
                      Text(
                        formattedDate,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ForecastIcon(
                        icon: state.forecast[index].forecastIcon,
                        id: state.forecast[index].forecastId,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      // Температура
                      Text(
                        state.forecast[index].temp.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
