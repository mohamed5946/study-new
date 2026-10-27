part of 'attendance.dart';

class AttendanceRecordAdapter extends TypeAdapter<AttendanceRecord> {
  @override
  final int typeId = 4;

  @override
  AttendanceRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttendanceRecord(
      id: fields[0] as String,
      lectureId: fields[1] as String,
      date: fields[2] as DateTime,
      isPresent: fields[3] as bool,
      note: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AttendanceRecord obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.lectureId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.isPresent)
      ..writeByte(4)
      ..write(obj.note);
  }
}
