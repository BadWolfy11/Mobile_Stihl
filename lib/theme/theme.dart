import 'package:flutter/material.dart';
import 'light_color.dart';

class AppTheme {
  const AppTheme();

  static ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: LightColor.background, // ВАЖНО
    primaryColor: LightColor.background,
    cardColor: LightColor.background,
    textTheme: ThemeData.light().textTheme.copyWith(
      bodyLarge: const TextStyle(color: LightColor.black),
    ),
    iconTheme: const IconThemeData(color: LightColor.iconColor),
    bottomAppBarTheme: BottomAppBarTheme(
      color: LightColor.background, // Здесь указываем цвет фона
    ),
    dividerColor: LightColor.lightGrey,
    primaryTextTheme: ThemeData.light().textTheme.copyWith(
      bodyLarge: const TextStyle(color: LightColor.titleTextColor),
    ),
  );

  // Заголовки
  static const TextStyle titleStyle = TextStyle(
    color: LightColor.titleTextColor,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle subTitleStyle = TextStyle(
    color: LightColor.subTitleTextColor,
    fontSize: 12,
  );

  // Стандартные размеры шрифтов для заголовков
  static const TextStyle h1Style = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle h2Style = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle h3Style = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle h4Style = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle h5Style = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle h6Style = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  // Тень для элементов
  static const List<BoxShadow> shadow = [
    BoxShadow(
      color: Color(0xFFF8F8F8),
      blurRadius: 10,
      spreadRadius: 15,
    ),
  ];

  // Отступы
  static const EdgeInsets padding = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 10,
  );

  static const EdgeInsets hPadding = EdgeInsets.symmetric(
    horizontal: 10,
  );

  // Утилиты для размеров экрана
  static double fullWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double fullHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
