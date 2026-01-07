import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/dependency_injection.dart';

/// Notifier pour gérer le thème de l'application
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences prefs;
  static const String _key = 'theme_mode';

  ThemeModeNotifier(this.prefs) : super(ThemeMode.dark) {
    _loadTheme();
  }

  /// Charge le thème sauvegardé
  void _loadTheme() {
    final savedTheme = prefs.getString(_key);
    if (savedTheme != null) {
      state = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedTheme,
        orElse: () => ThemeMode.dark,
      );
    }
  }

  /// Change le thème et le sauvegarde
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await prefs.setString(_key, mode.toString());
  }
}

/// Provider pour le mode thème
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final prefs = getIt<SharedPreferences>();
  return ThemeModeNotifier(prefs);
});
