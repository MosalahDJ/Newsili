// theme_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsily/helper/themes.dart';
import 'package:newsily/logic/cubit/theme/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const _prefKey = 'app_theme_mode';

  ThemeCubit()
    : super(ThemeState(mode: ThemeMode.light, themeData: lightTheme)) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_prefKey);
    if (stored == 'dark') {
      emit(ThemeState(mode: ThemeMode.dark, themeData: darkTheme));
    } else if (stored == 'system') {
      emit(ThemeState(mode: ThemeMode.system, themeData: ThemeData.fallback()));
    } else {
      emit(ThemeState(mode: ThemeMode.light, themeData: lightTheme));
    }
  }

  Future<void> setLight() async => _set(ThemeMode.light, lightTheme, 'light');
  Future<void> setDark() async => _set(ThemeMode.dark, darkTheme, 'dark');
  Future<void> setSystem() async =>
      _set(ThemeMode.system, ThemeData.fallback(), 'system');

  Future<void> toggle() async {
    if (state.mode == ThemeMode.dark) {
      await setLight();
    } else {
      await setDark();
    }
  }

  Future<void> _set(ThemeMode mode, ThemeData data, String prefValue) async {
    emit(ThemeState(mode: mode, themeData: data));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, prefValue);
  }
}
