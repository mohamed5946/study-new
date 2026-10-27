part of 'subject.dart';

class SubjectAdapter extends TypeAdapter<Subject> {
  @override
  final int typeId = 1;

  @override
  Subject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subject(
      id: fields[0] as String,
      nameAr: fields[1] as String,
      nameEn: fields[2] as String,
      code: fields[3] as String?,
      creditHours: fields[4] as double,
      doctorName: fields[5] as String?,
      colorValue: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Subject obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nameAr)
      ..writeByte(2)
      ..write(obj.nameEn)
      ..writeByte(3)
      ..write(obj.code)
      ..writeByte(4)
      ..write(obj.creditHours)
      ..writeByte(5)
      ..write(obj.doctorName)
      ..writeByte(6)
      ..write(obj.colorValue);
  }
}
