part of 'weather_cubit.dart';

enum WeatherStatus {
  initial,
  loading,
  loaded,
  error,
}

class WeatherState extends Equatable {
  final WeatherStatus status;
  final CurrentWeather currentWeather;
  final List<Forecast> forecast;
  final CustomError error;
  final int? selectedItem;

  const WeatherState({
    required this.status,
    required this.currentWeather,
    required this.forecast,
    required this.error,
    required this.selectedItem,
  });

  WeatherState copyWith({
    WeatherStatus? status,
    CurrentWeather? currentWeather,
    List<Forecast>? forecast,
    CustomError? error,
    int? selectedItem,
  }) {
    return WeatherState(
      status: status ?? this.status,
      currentWeather: currentWeather ?? this.currentWeather,
      forecast: forecast ?? this.forecast,
      error: error ?? this.error,
      selectedItem: selectedItem,
    );
  }

  factory WeatherState.initial() {
    return WeatherState(
      status: WeatherStatus.initial,
      currentWeather: CurrentWeather.initial(),
      forecast: const <Forecast>[],
      error: const CustomError(),
      selectedItem: null,
    );
  }

  @override
  List<Object?> get props => [
        status,
        currentWeather,
        forecast,
        error,
        selectedItem,
      ];
}
