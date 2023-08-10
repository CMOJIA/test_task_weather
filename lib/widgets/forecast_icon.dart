import 'package:flutter/material.dart';

/// Виджет отображающий иконку погоды в списке прогноза погоды по часам в зависимоти от [id] погоды
class ForecastIcon extends StatelessWidget {
  const ForecastIcon({
    super.key,
    required this.id,
    required this.icon,
  });

  final int id;
  final String icon;

  @override
  Widget build(BuildContext context) {
    switch (id) {
      // Гроза
      case 200:
      case 201:
      case 202:
      case 210:
      case 211:
      case 212:
      case 221:
      case 230:
      case 231:
      case 232:
        return Image.asset(
          'assets/smallIcons/CloudLightning.png',
        );
      // Морось
      case 300:
      case 301:
      case 302:
      case 310:
      case 311:
      case 312:
      case 313:
      case 314:
      case 321:
      // Дождь и солнце
      case 500:
      case 501:
      case 502:
      case 503:
      case 504:
      // Дождь
      case 520:
      case 521:
      case 522:
      case 533:
        return Image.asset(
          'assets/smallIcons/CloudRain.png',
        );
      // Снег
      case 511:
      case 600:
      case 601:
      case 692:
      case 611:
      case 612:
      case 613:
      case 615:
      case 616:
      case 620:
      case 621:
      case 622:
        return Image.asset(
          'assets/smallIcons/CloudSnow.png',
        );
      // Солнце
      case 800:
        if (icon.contains('d')) {
          return Image.asset(
            'assets/smallIcons/Sun.png',
          );
        }
        // иконки луны нет, поэтому для ясной погоды ночью используется
        // Переменная облачность с луной
        else {
          return Image.asset(
            'assets/smallIcons/CloudMoon.png',
          );
        }
      // Туман
      // Подходящей иконки нет, аиболее похожее - морось
      case 701:
      case 711:
      case 721:
      case 731:
      case 741:
      case 751:
      case 761:
      case 762:
      case 771:
      case 781:
        return Image.asset(
          'assets/smallIcons/CloudRain.png',
        );
      // Облачность
      case 801:
      case 802:
      case 803:
      case 804:
        // Большой иконки облачности с проснениями нет, поэтому используется иконка солнца
        if (icon.contains('d')) {
          return Image.asset(
            'assets/smallIcons/CloudSun.png',
          );
        } else {
          return Image.asset(
            'assets/smallIcons/CloudMoon.png',
          );
        }
      default:
        return Image.asset(
          'assets/smallIcons/Sun.png',
        );
    }
  }
}
