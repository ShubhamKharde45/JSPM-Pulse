import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jspm_pulse/core/Theme/theme_data.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>(
  (ref) => ThemeNotifier(),
);

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(lighMode);

  void toggle() {
    state = state.brightness == Brightness.light ? darkMode : lighMode;
  }

  bool get isDark => state.brightness == Brightness.dark;
}
