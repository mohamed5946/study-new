part of 'task.dart';

class TaskItemAdapter extends TypeAdapter<TaskItem> {
  @override
  final int typeId = 2;

  @override
  TaskItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskItem(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String?,
      deadline: fields[3] as DateTime?,
      isCompleted: fields[4] as bool,
      subjectId: fields[5] as String?,
      priority: fields[6] as int,
      createdAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TaskItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.deadline)
      ..writeByte(4)
      ..write(obj.isCompleted)
      ..writeByte(5)
      ..write(obj.subjectId)
      ..writeByte(6)
      ..write(obj.priority)
      ..writeByte(7)
      ..write(obj.createdAt);
  }
}
