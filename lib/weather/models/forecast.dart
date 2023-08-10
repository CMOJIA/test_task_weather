import 'package:equatable/equatable.dart';

class Forecast extends Equatable {
  const Forecast({
    required this.dateTime,
    required this.temp,
    required this.humidity,
    required this.windSpeed,
    required this.windDeg,
    required this.forecastId,
    required this.forecastIcon,
  });

  final DateTime dateTime;
  final int temp;
  final int humidity;
  final int windSpeed;
  final int windDeg;
  final int forecastId;
  final String forecastIcon;

  @override
  List<Object?> get props => [
        dateTime,
        temp,
        humidity,
        windSpeed,
        windDeg,
        forecastId,
        forecastIcon,
      ];

  factory Forecast.fromJson({
    required Map<String, dynamic> json,
  }) {
    final main = json['main'];
    final weather = json['weather'][0];
    final wind = json['wind'];

    return Forecast(
      dateTime: DateTime.fromMillisecondsSinceEpoch(
        (json['dt'] as int) * 1000,
      ),
      temp: main['temp'].round() ?? 0,
      humidity: main['humidity'] ?? 0,
      windSpeed: wind['speed'].round() ?? 0,
      windDeg: wind['deg'] ?? 0,
      forecastId: weather['id'] ?? 0,
      forecastIcon: weather['icon'] ?? '',
    );
  }

  factory Forecast.initial() => Forecast(
      dateTime: DateTime.fromMillisecondsSinceEpoch(0),
      temp: 0,
      humidity: 0,
      windSpeed: 0,
      windDeg: 0,
      forecastId: 0,
      forecastIcon: '');

  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'temp': temp,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'windDeg': windDeg,
      'forecastId': forecastId,
      'forecastIcon': forecastIcon
    };
  }

  factory Forecast.fromMap(Map<String, dynamic> map) {
    return Forecast(
        dateTime: DateTime.parse(map['dateTime']),
        temp: map['temp'].round(),
        humidity: map['humidity'],
        windSpeed: map['windSpeed'].round(),
        windDeg: map['windDeg'],
        forecastId: map['forecastId'],
        forecastIcon: map['forecastIcon']);
  }
}
