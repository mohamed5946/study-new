part of 'app_settings.dart';

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 5;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      userNameAr: fields[0] as String,
      userNameEn: fields[1] as String,
      languageCode: fields[2] as String,
      themeMode: fields[3] as String,
      reduceAnimations: fields[4] as bool,
      focusMinutes: fields[5] as int,
      shortBreakMinutes: fields[6] as int,
      longBreakMinutes: fields[7] as int,
      studyStreak: fields[8] as int,
      lastStudyDate: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.userNameAr)
      ..writeByte(1)
      ..write(obj.userNameEn)
      ..writeByte(2)
      ..write(obj.languageCode)
      ..writeByte(3)
      ..write(obj.themeMode)
      ..writeByte(4)
      ..write(obj.reduceAnimations)
      ..writeByte(5)
      ..write(obj.focusMinutes)
      ..writeByte(6)
      ..write(obj.shortBreakMinutes)
      ..writeByte(7)
      ..write(obj.longBreakMinutes)
      ..writeByte(8)
      ..write(obj.studyStreak)
      ..writeByte(9)
      ..write(obj.lastStudyDate);
  }
}
