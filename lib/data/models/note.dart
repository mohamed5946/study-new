import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'note.g.dart';

@HiveType(typeId: 3)
class Note extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final String? subjectId;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime updatedAt;

  @HiveField(6)
  final List<String> tags;

  Note({
    String? id,
    required this.title,
    required this.content,
    this.subjectId,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.tags = const [],
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Note copyWith({
    String? title,
    String? content,
    String? subjectId,
    List<String>? tags,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      subjectId: subjectId ?? this.subjectId,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      tags: tags ?? this.tags,
    );
  }
}
