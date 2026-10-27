// GENERATED CODE - DO NOT MODIFY BY HAND (manual for offline build)
part of 'lecture.dart';

class LectureAdapter extends TypeAdapter<Lecture> {
  @override
  final int typeId = 0;

  @override
  Lecture read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Lecture(
      id: fields[0] as String,
      subjectName: fields[1] as String,
      type: fields[2] as String,
      doctorName: fields[3] as String,
      room: fields[4] as String,
      building: fields[5] as String,
      dayOfWeek: fields[6] as int,
      startHour: fields[7] as int,
      startMinute: fields[8] as int,
      endHour: fields[9] as int,
      endMinute: fields[10] as int,
      subjectId: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Lecture obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.subjectName)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.doctorName)
      ..writeByte(4)
      ..write(obj.room)
      ..writeByte(5)
      ..write(obj.building)
      ..writeByte(6)
      ..write(obj.dayOfWeek)
      ..writeByte(7)
      ..write(obj.startHour)
      ..writeByte(8)
      ..write(obj.startMinute)
      ..writeByte(9)
      ..write(obj.endHour)
      ..writeByte(10)
      ..write(obj.endMinute)
      ..writeByte(11)
      ..write(obj.subjectId);
  }
}
