import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:test_task_weather_service/services/weather_api.dart';
import 'package:test_task_weather_service/services/weather_exception.dart';
import 'package:test_task_weather_service/weather/models/custom_error.dart';
import 'package:test_task_weather_service/weather/models/forecast.dart';
import 'package:test_task_weather_service/weather/models/current_weather.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

class WeatherRepository {
  final WeatherApiServices weatherApiServices;

  WeatherRepository({
    required this.weatherApiServices,
  });

  Future<CurrentWeather?> loadCurrentWeatherFromCache() async {
    await getIt.isReady<SharedPreferences>();
    final prefs = getIt<SharedPreferences>();
    if (!prefs.containsKey("currentWeather")) {
      return null;
    }

    final cachedData = json.decode(prefs.getString('currentWeather') as String);

    return CurrentWeather.fromMap(cachedData['currentWeather']);
  }

  Future<List<Forecast>?> loadForecastFromCache() async {
    await getIt.isReady<SharedPreferences>();
    final prefs = getIt<SharedPreferences>();
    if (!prefs.containsKey("forecast")) {
      return null;
    }

    final cachedData = json.decode(prefs.getString('forecast') as String);
    final list = (cachedData['forecast'] as List)
        .map((e) => Forecast.fromMap(e))
        .toList();
    return list;
  }

  void cachingdData({
    required CurrentWeather currentWeather,
    required List<Forecast> forecast,
  }) async {
    await getIt.isReady<SharedPreferences>();
    final prefs = getIt<SharedPreferences>();
    final currentEncoded = json.encode({
      'currentWeather': currentWeather.toMap(),
    });
    final forecastEncoded = json.encode({
      'forecast': forecast.map((e) => e.toMap()).toList(),
    });
    await prefs.setString('currentWeather', currentEncoded);
    await prefs.setString('forecast', forecastEncoded);
  }

  Future<CurrentWeather> fetchWeather({
    required double lat,
    required double lon,
  }) async {
    try {
      final CurrentWeather weather =
          await weatherApiServices.getCurrentWeather(lat: lat, lon: lon);
      return weather;
    } on WeatherException catch (e) {
      throw CustomError(errMsg: e.message);
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }

  Future<List<Forecast>> fetchForecast({
    required double lat,
    required double lon,
  }) async {
    try {
      final forecast =
          await weatherApiServices.getDailyForecast(lat: lat, lon: lon);
      return forecast;
    } on WeatherException catch (e) {
      throw CustomError(errMsg: e.message);
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
