import 'package:equatable/equatable.dart';

class CurrentWeather extends Equatable {
  const CurrentWeather({
    required this.dateTime,
    required this.destination,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.weatherDescription,
    required this.weatherId,
    required this.weatherIcon,
    required this.windSpeed,
    required this.humidity,
    required this.windDeg,
  });

  final DateTime dateTime;
  final String destination;
  final int temp;
  final int tempMin;
  final int tempMax;
  final String weatherDescription;
  final int weatherId;
  final String weatherIcon;
  final int windSpeed;
  final int humidity;
  final int windDeg;

  @override
  List<Object> get props => [
        dateTime,
        destination,
        temp,
        tempMin,
        tempMax,
        weatherDescription,
        weatherId,
        weatherIcon,
        windSpeed,
        humidity,
        windDeg
      ];

  factory CurrentWeather.fromJson({
    required Map<String, dynamic> json,
    required String country,
  }) {
    final main = json['main'];
    final weather = json['weather'][0];
    final wind = json['wind'];
    return CurrentWeather(
      dateTime: DateTime.fromMillisecondsSinceEpoch(
        (json['dt'] as int) * 1000,
      ),
      destination: '${json['name']}, $country',
      temp: main['temp'].round() ?? 0,
      tempMin: main['temp_min'].round() ?? 0,
      tempMax: main['temp_max'].round() ?? 0,
      weatherDescription: weather['description'] ?? '',
      weatherId: weather['id'] ?? 0,
      weatherIcon: weather['icon'] ?? '',
      windSpeed: wind['speed'].round() ?? 0,
      humidity: main['humidity'] ?? 0,
      windDeg: wind['deg'] ?? 0,
    );
  }

  factory CurrentWeather.initial() => CurrentWeather(
        dateTime: DateTime.fromMillisecondsSinceEpoch(0),
        destination: '',
        temp: 0,
        tempMin: 0,
        tempMax: 0,
        weatherDescription: '',
        weatherId: 0,
        weatherIcon: '',
        humidity: 0,
        windSpeed: 0,
        windDeg: 0,
      );

  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'temp': temp,
      'destination': destination,
      'tempMin': tempMin,
      'tempMax': tempMax,
      'weatherDescription': weatherDescription,
      'weatherId': weatherId,
      'weatherIcon': weatherIcon,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'windDeg': windDeg,
    };
  }

  factory CurrentWeather.fromMap(Map<String, dynamic> map) {
    return CurrentWeather(
      dateTime: DateTime.parse(map['dateTime']),
      temp: map['temp'].round(),
      destination: map['destination'],
      tempMin: map['tempMin'].round(),
      tempMax: map['tempMax'].round(),
      weatherDescription: map['weatherDescription'],
      weatherId: map['weatherId'],
      weatherIcon: map['weatherIcon'],
      humidity: map['humidity'],
      windSpeed: map['windSpeed'],
      windDeg: map['windDeg'],
    );
  }
}
