// theme_state.dart
import 'package:flutter/material.dart';

class ThemeState {
  final ThemeMode mode;
  final ThemeData themeData;

  ThemeState({required this.mode, required this.themeData});

  ThemeState copyWith({ThemeMode? mode, ThemeData? themeData}) =>
      ThemeState(mode: mode ?? this.mode, themeData: themeData ?? this.themeData);
}
