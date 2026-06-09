import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier extends Notifier<Locale> {
  static const _langKey = 'app_language';

  @override
  Locale build() {
    _loadSavedLanguage();
    return const Locale('en');
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString(_langKey);
    if (savedLang != null) {
      if (savedLang == 'zh_TW') {
        state = const Locale('zh', 'TW');
      } else {
        state = const Locale('en');
      }
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (state == locale) return;
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    if (locale.languageCode == 'zh') {
      await prefs.setString(_langKey, 'zh_TW');
    } else {
      await prefs.setString(_langKey, 'en');
    }
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);
