import 'package:flutter/widgets.dart';
import 'package:test_task_weather_service/app/bloc/app_bloc.dart';
import 'package:test_task_weather_service/login/view/login_page.dart';
import 'package:test_task_weather_service/weather/view/weather_page.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.authenticated:
      return [WeatherPage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}
