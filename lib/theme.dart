import 'package:flutter/material.dart';

final theme = ThemeData(
  useMaterial3: true,
  primaryColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      disabledBackgroundColor: const Color(0xFF0600FF),
      backgroundColor: const Color(0xFF0600FF),
      elevation: 8,
      shadowColor: const Color(0x28FF585D),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(
      color: Color(0xFF8799A5),
      fontSize: 17,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFF0600FF),
        width: 2,
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFFE4E6EC),
      ),
    ),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Color(0xFFFF585D),
    selectionHandleColor: Color(0xFF0600FF),
    selectionColor: Color.fromARGB(44, 0, 0, 0),
  ),
);
