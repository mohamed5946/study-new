import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'attendance.g.dart';

@HiveType(typeId: 4)
class AttendanceRecord extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String lectureId;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final bool isPresent; // true = حاضر, false = غائب

  @HiveField(4)
  final String? note;

  AttendanceRecord({
    String? id,
    required this.lectureId,
    required this.date,
    required this.isPresent,
    this.note,
  }) : id = id ?? const Uuid().v4();
}
