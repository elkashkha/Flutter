import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeState {
  final ThemeMode themeMode;

  ThemeState(this.themeMode);
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(ThemeMode.light));

  Future<void> changeTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTheme', themeMode.name);
    emit(ThemeState(themeMode));
  }

  Future<void> loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeName = prefs.getString('selectedTheme') ?? 'light';

    ThemeMode savedTheme = ThemeMode.light;
    if (savedThemeName == 'dark') {
      savedTheme = ThemeMode.dark;
    } else if (savedThemeName == 'system') {
      savedTheme = ThemeMode.system;
    }

    if (savedTheme != state.themeMode) {
      emit(ThemeState(savedTheme));
    }
  }
}
