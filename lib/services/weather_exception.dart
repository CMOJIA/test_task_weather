class WeatherException implements Exception {
  String message;

  WeatherException([this.message = 'Что-то пошло не так']) {
    message = 'Ошибка погоды $message';
  }

  @override
  String toString() {
    return message;
  }
}
