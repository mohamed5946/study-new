import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

@HiveType(typeId: 2)
class TaskItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final DateTime? deadline;

  @HiveField(4)
  final bool isCompleted;

  @HiveField(5)
  final String? subjectId;

  @HiveField(6)
  final int priority; // 0 low, 1 medium, 2 high

  @HiveField(7)
  final DateTime createdAt;

  TaskItem({
    String? id,
    required this.title,
    this.description,
    this.deadline,
    this.isCompleted = false,
    this.subjectId,
    this.priority = 1,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  TaskItem copyWith({
    String? title,
    String? description,
    DateTime? deadline,
    bool? isCompleted,
    String? subjectId,
    int? priority,
  }) {
    return TaskItem(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
      subjectId: subjectId ?? this.subjectId,
      priority: priority ?? this.priority,
      createdAt: createdAt,
    );
  }
}
