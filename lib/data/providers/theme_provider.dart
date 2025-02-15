

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<ThemeMode> {
  static const String _themeBox = "themeBox";
  static const String _themeKey = "isDarkMode";

  ThemeNotifier() : super(ThemeMode.system) {
    loadTheme();
  }

  Future<void> loadTheme() async {
    var box = await Hive.openBox(_themeBox);
    final isDarkMode = box.get(_themeKey, defaultValue: false);
    state = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    var box = await Hive.openBox(_themeBox);
    final isDarkMode = state == ThemeMode.dark;
    final newTheme = isDarkMode ? ThemeMode.light : ThemeMode.dark;

    state = newTheme;
    await box.put(_themeKey, newTheme == ThemeMode.dark);
  }
}