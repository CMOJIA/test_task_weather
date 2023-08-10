import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test_task_weather_service/services/http_error_handler.dart';
import 'package:test_task_weather_service/services/secrets.dart';
import 'package:test_task_weather_service/services/weather_exception.dart';
import 'package:test_task_weather_service/weather/models/forecast.dart';
import 'package:test_task_weather_service/weather/models/current_weather.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart';

class WeatherApiServices {
  Future<CurrentWeather> getCurrentWeather(
      {required double lat, required double lon}) async {
    final uri = Uri(
        scheme: 'https',
        host: 'api.openweathermap.org',
        path: '/data/2.5/weather',
        queryParameters: {
          'lat': '$lat',
          'lon': '$lon',
          'appid': weatherApiKey,
          'lang': 'ru',
          'units': 'metric',
        });

    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception(httpErrorHandler(response));
      } else {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody.isEmpty) {
          throw WeatherException('Невозможно получить данные о погоде');
        }

        // OpenWeather в данных о местоположении передает только населенный пункт
        // На макете отображена еще и страна, поэтому использую для этого YandexGeocoder
        final YandexGeocoder geocoder = YandexGeocoder(apiKey: yandexApiKey);

        final GeocodeResponse geocodeFromPoint =
            await geocoder.getGeocode(GeocodeRequest(
          geocode: PointGeocode(latitude: lat, longitude: lon),
          lang: Lang.ru,
        ));
        //

        return CurrentWeather.fromJson(
            json: responseBody,
            country: geocodeFromPoint.firstCountry?.countryName ?? '');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Forecast>> getDailyForecast({
    required double lat,
    required double lon,
  }) async {
    final uri = Uri(
        scheme: 'https',
        host: 'api.openweathermap.org',
        path: '/data/2.5/forecast',
        queryParameters: {
          'lat': '$lat',
          'lon': '$lon',
          'appid': weatherApiKey,
          'lang': 'ru',
          'units': 'metric',
        });
    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception(httpErrorHandler(response));
      } else {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody.isEmpty) {
          throw WeatherException('Невозможно получить данные о погоде');
        }
        return (responseBody['list'] as List)
            .map(
              (e) => Forecast.fromJson(
                json: e,
              ),
            )
            // Отбор  погоды только на сегодняшний день
            // Почасовая погода платная
            // Бесплатно достпуна только погода на 5 дней с интервалом 3 часа
            .where((element) => element.dateTime.day == DateTime.now().day)
            .toList();
      }
    } catch (e) {
      rethrow;
    }
  }
}
