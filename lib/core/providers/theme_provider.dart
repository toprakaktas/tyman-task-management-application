import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themePrefsKey = 'theme_mode';

final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final savedTheme = prefs.getString(_themePrefsKey);

    if (savedTheme == 'dark') return ThemeMode.dark;
    if (savedTheme == 'light') return ThemeMode.light;

    return ThemeMode.system;
  }

  void toggleTheme() {
    if (state == ThemeMode.dark) {
      setTheme(ThemeMode.light);
    } else {
      setTheme(ThemeMode.dark);
    }
  }

  void setTheme(ThemeMode mode) {
    state = mode;

    final prefs = ref.read(sharedPreferencesProvider);
    if (mode == ThemeMode.dark) {
      prefs.setString(_themePrefsKey, 'dark');
    } else if (mode == ThemeMode.light) {
      prefs.setString(_themePrefsKey, 'light');
    } else {
      prefs.remove(_themePrefsKey);
    }
  }
}

final themeNotifierProvider =
    NotifierProvider<ThemeNotifier, ThemeMode>(() => ThemeNotifier());
