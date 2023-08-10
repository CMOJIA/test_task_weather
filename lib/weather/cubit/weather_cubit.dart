import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_task_weather_service/repositories/weather_repository/weather_repository.dart';
import 'package:test_task_weather_service/weather/models/custom_error.dart';
import 'package:test_task_weather_service/weather/models/forecast.dart';
import 'package:test_task_weather_service/weather/models/current_weather.dart';
import 'package:geolocator/geolocator.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository weatherRepository;
  WeatherCubit({required this.weatherRepository})
      : super(WeatherState.initial());

  Future<void> fetchWeather() async {
    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      final currentWeatherCached =
          await weatherRepository.loadCurrentWeatherFromCache();
      final forecastCached = await weatherRepository.loadForecastFromCache();
      emit(state.copyWith(
        forecast: forecastCached ?? [Forecast.initial()],
        currentWeather: currentWeatherCached ?? CurrentWeather.initial(),
      ));

      final position = await _determinePosition();

      final currentWeather = await weatherRepository.fetchWeather(
        lat: position.latitude,
        lon: position.longitude,
      );
      final forecast = await weatherRepository.fetchForecast(
        lat: position.latitude,
        lon: position.longitude,
      );
      weatherRepository.cachingdData(
          currentWeather: currentWeather, forecast: forecast);
      emit(state.copyWith(
        status: WeatherStatus.loaded,
        currentWeather: currentWeather,
        forecast: forecast,
      ));
    } on CustomError catch (e) {
      emit(state.copyWith(
        status: WeatherStatus.error,
        error: e,
      ));
    }
  }

  void selectForecastItem({required int index}) {
    final selected = state.selectedItem == index ? null : index;
    return emit(state.copyWith(
      selectedItem: selected,
    ));
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Службы определения местоположения отключены.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Доступ к геопозиции запрещен.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Дотусп к геопозиции запрещен "навсегда", перейдите в настройки, чтобы разрешить.');
  }
  return await Geolocator.getCurrentPosition();
}
