import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<bool> {
  final SharedPreferences preferences;
  static const String _isDarkThemeKey = 'is_dark_theme';

  ThemeCubit(this.preferences) : super(_loadTheme(preferences));

  static bool _loadTheme(SharedPreferences preferences) {
    return preferences.getBool(_isDarkThemeKey) ?? true;
  }

  void toggleTheme() {
    final newValue = !state;
    preferences.setBool(_isDarkThemeKey, newValue);
    emit(newValue);
  }
} 