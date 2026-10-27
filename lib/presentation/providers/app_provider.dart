import 'package:flutter/material.dart';
import '../../data/models/app_settings.dart';
import '../../data/services/hive_service.dart';

class AppProvider extends ChangeNotifier {
  late AppSettings _settings;

  AppProvider() {
    _settings = HiveService.settings;
  }

  AppSettings get settings => _settings;
  bool get isArabic => _settings.isArabic;
  String get userName => isArabic ? _settings.userNameAr : _settings.userNameEn;
  ThemeMode get themeMode {
    switch (_settings.themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> updateSettings(AppSettings newSettings) async {
    _settings = newSettings;
    await HiveService.saveSettings(newSettings);
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    _settings.languageCode = code;
    await HiveService.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> setThemeMode(String mode) async {
    _settings.themeMode = mode;
    await HiveService.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> setReduceAnimations(bool value) async {
    _settings.reduceAnimations = value;
    await HiveService.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> setPomodoroDurations({
    int? focus,
    int? shortBreak,
    int? longBreak,
  }) async {
    if (focus != null) _settings.focusMinutes = focus;
    if (shortBreak != null) _settings.shortBreakMinutes = shortBreak;
    if (longBreak != null) _settings.longBreakMinutes = longBreak;
    await HiveService.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> updateStreak() async {
    final today = DateTime.now();
    final last = _settings.lastStudyDate;
    if (last == null) {
      _settings.studyStreak = 1;
    } else {
      final diff = today.difference(DateTime(last.year, last.month, last.day)).inDays;
      if (diff == 1) {
        _settings.studyStreak += 1;
      } else if (diff > 1) {
        _settings.studyStreak = 1;
      }
    }
    _settings.lastStudyDate = today;
    await HiveService.saveSettings(_settings);
    notifyListeners();
  }
}
