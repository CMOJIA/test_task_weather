import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_task_weather_service/repositories/weather_repository/weather_repository.dart';
import 'package:test_task_weather_service/services/weather_api.dart';
import 'package:test_task_weather_service/weather/cubit/weather_cubit.dart';
import 'package:test_task_weather_service/widgets/current_weather_icon.dart';
import 'package:test_task_weather_service/widgets/error_dialog.dart';
import 'package:intl/intl.dart';
import 'package:test_task_weather_service/widgets/forecast_list.dart';
import 'package:test_task_weather_service/widgets/humidity_gradation.dart';
import 'package:test_task_weather_service/widgets/wind_direction.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: WeatherPage());

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) =>
          WeatherRepository(weatherApiServices: WeatherApiServices()),
      child: BlocProvider(
        create: (context) => WeatherCubit(
          weatherRepository: context.read<WeatherRepository>(),
        )..fetchWeather(),
        child: BlocConsumer<WeatherCubit, WeatherState>(
          listener: (context, state) {
            if (state.status == WeatherStatus.error) {
              errorDialog(context, state.error.errMsg);
            }
          },
          builder: (context, state) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.21, -0.98),
                  end: Alignment(-0.21, 0.98),
                  colors: [Color(0x700700FF), Colors.black],
                ),
              ),
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.light,
                ),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Location
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svgIcons/pin.svg',
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    state.currentWeather.destination.isNotEmpty
                                        ? '${state.currentWeather.destination[0].toUpperCase()}${state.currentWeather.destination.substring(1)}'
                                        : '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // CurrentWeatherIcon
                          Container(
                            decoration: const ShapeDecoration(
                                color: Colors.transparent,
                                shape: OvalBorder(),
                                shadows: [
                                  BoxShadow(
                                      color: Color(0xFFBC86FF),
                                      blurRadius: 90,
                                      offset: Offset(0, -10),
                                      spreadRadius: -8)
                                ]),
                            child: CurrentWeatherIcon(
                              icon: state.currentWeather.weatherIcon,
                              id: state.currentWeather.weatherId,
                            ),
                          ),
                          // Current temp
                          Text(
                            '${state.currentWeather.temp}º',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 64,
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                            ),
                          ),
                          // Current weather description
                          Text(
                            state.currentWeather.weatherDescription.isNotEmpty
                                ? '${state.currentWeather.weatherDescription[0].toUpperCase()}${state.currentWeather.weatherDescription.substring(1)}'
                                : '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          // min max temp
                          Text(
                            'Макс: ${state.currentWeather.tempMax}º Мин: ${state.currentWeather.tempMin}º',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          // Forecast contaier
                          Container(
                            margin: const EdgeInsets.all(24),
                            decoration: ShapeDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        // Показывает когда обновлялся прогноз
                                        // Сегодня или n дней назад
                                        state.currentWeather.dateTime.day ==
                                                DateTime.now().day
                                            ? 'Сегодня'
                                            : '${DateTime.now().day - state.currentWeather.dateTime.day}  дней назад',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      // Дата прогноза
                                      Text(
                                        DateFormat('dd MMMM', 'ru_RU').format(
                                            state.currentWeather.dateTime),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 1,
                                  indent: 0,
                                  endIndent: 0,
                                  color: Colors.white,
                                ),
                                ForecastList(state: state),
                              ],
                            ),
                          ),
                          // Wind Speed & humidity container
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(
                                left: 24, right: 24, bottom: 24),
                            decoration: ShapeDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 10,
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/svgIcons/Wind.svg',
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              // Если выбран элемент из списка прогноза на день - показываются данные для выбранного часа
                                              // Если нет показываются данные на текущий момент
                                              state.selectedItem == null
                                                  ? '${state.currentWeather.windSpeed} м/с'
                                                  : '${state.forecast[state.selectedItem ?? 0].windSpeed} м/с',
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.2),
                                                fontSize: 15,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Expanded(
                                          flex: 3, child: SizedBox.shrink()),
                                      WindDirection(
                                        state: state,
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 10,
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/svgIcons/Drop.svg',
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              // Тоже самое, если не выбрано ничего - данные на текущий момент
                                              state.selectedItem == null
                                                  ? '${state.currentWeather.humidity}%'
                                                  : '${state.forecast[state.selectedItem ?? 0].humidity}%',
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.2),
                                                fontSize: 15,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 3,
                                        child: SizedBox.shrink(),
                                      ),
                                      HumidityGradation(
                                        state: state,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
