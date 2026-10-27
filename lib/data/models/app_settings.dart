import 'package:hive/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 5)
class AppSettings extends HiveObject {
  @HiveField(0)
  String userNameAr;

  @HiveField(1)
  String userNameEn;

  @HiveField(2)
  String languageCode; // 'ar' or 'en'

  @HiveField(3)
  String themeMode; // 'light', 'dark', 'system'

  @HiveField(4)
  bool reduceAnimations;

  @HiveField(5)
  int focusMinutes;

  @HiveField(6)
  int shortBreakMinutes;

  @HiveField(7)
  int longBreakMinutes;

  @HiveField(8)
  int studyStreak;

  @HiveField(9)
  DateTime? lastStudyDate;

  AppSettings({
    this.userNameAr = 'محمد',
    this.userNameEn = 'Mohamed',
    this.languageCode = 'ar',
    this.themeMode = 'system',
    this.reduceAnimations = false,
    this.focusMinutes = 25,
    this.shortBreakMinutes = 5,
    this.longBreakMinutes = 15,
    this.studyStreak = 0,
    this.lastStudyDate,
  });

  bool get isArabic => languageCode == 'ar';
}
