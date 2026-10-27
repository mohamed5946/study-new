part of 'pdf_file.dart';

class PdfFileAdapter extends TypeAdapter<PdfFile> {
  @override
  final int typeId = 7;

  @override
  PdfFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PdfFile(
      id: fields[0] as String,
      name: fields[1] as String,
      path: fields[2] as String,
      addedAt: fields[3] as DateTime,
      pageCount: fields[4] as int,
      extractedText: fields[5] as String?,
      subjectId: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PdfFile obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.path)
      ..writeByte(3)
      ..write(obj.addedAt)
      ..writeByte(4)
      ..write(obj.pageCount)
      ..writeByte(5)
      ..write(obj.extractedText)
      ..writeByte(6)
      ..write(obj.subjectId);
  }
}
