import 'package:flutter/material.dart';
import 'package:task_manager/utils/colors.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: grayF9,
  dialogBackgroundColor: Colors.white,
  cardColor: Colors.white,
  colorScheme: ColorScheme.light(
    primary: Colors.blue,
    secondary: Colors.orange,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black87),
    labelLarge: TextStyle(color: Colors.white70),
    labelMedium: TextStyle(color: Colors.white),
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    shadowColor: Colors.grey.shade200,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.deepPurple,
  scaffoldBackgroundColor: Colors.black,
  dialogBackgroundColor: Colors.black,
  cardColor: gray75,
  colorScheme: ColorScheme.dark(
    primary: Colors.deepPurple,
    secondary: Colors.tealAccent,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.deepPurple,
    foregroundColor: Colors.white,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
    labelLarge: TextStyle(color: Colors.black),
    labelMedium: TextStyle(color: Colors.black87),
  ),
  cardTheme: CardTheme(
    color: Colors.grey.shade900,
    shadowColor: Colors.black54,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
);

