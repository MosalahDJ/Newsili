import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  scaffoldBackgroundColor: Colors.white,
  useMaterial3: true,
  appBarTheme: const AppBarTheme(centerTitle: true),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.teal,
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: Colors.black,
  useMaterial3: true,
  appBarTheme: const AppBarTheme(centerTitle: true),
);

// Optional: custom colors accessor
extension AppColors on ThemeData {
  Color get cardBg =>
      brightness == Brightness.dark ? Colors.grey[900]! : Colors.white;
  Color get subtleText =>
      brightness == Brightness.dark ? Colors.grey[400]! : Colors.grey[700]!;
}
