import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('SharedPreferences must be overridden'),
);

class AppPreferences {
  const AppPreferences({required this.themeMode, required this.locale});

  final ThemeMode themeMode;
  final Locale locale;

  AppPreferences copyWith({ThemeMode? themeMode, Locale? locale}) =>
      AppPreferences(
        themeMode: themeMode ?? this.themeMode,
        locale: locale ?? this.locale,
      );
}

class PreferencesController extends Notifier<AppPreferences> {
  static const _themeKey = 'pref_theme_mode';
  static const _localeKey = 'pref_locale';

  @override
  AppPreferences build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final theme = switch (prefs.getString(_themeKey)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    final locale = Locale(prefs.getString(_localeKey) ?? 'en');
    return AppPreferences(themeMode: theme, locale: locale);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await ref.read(sharedPreferencesProvider).setString(_themeKey, mode.name);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setLocale(Locale locale) async {
    await ref
        .read(sharedPreferencesProvider)
        .setString(_localeKey, locale.languageCode);
    state = state.copyWith(locale: locale);
  }
}

final preferencesProvider =
    NotifierProvider<PreferencesController, AppPreferences>(
      PreferencesController.new,
    );
