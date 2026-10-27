import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'lecture.g.dart';

@HiveType(typeId: 0)
class Lecture extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String subjectName;

  @HiveField(2)
  final String type; // 'lecture' or 'section'

  @HiveField(3)
  final String doctorName;

  @HiveField(4)
  final String room;

  @HiveField(5)
  final String building;

  @HiveField(6)
  final int dayOfWeek; // 0 = Sunday ... 6 = Saturday

  @HiveField(7)
  final int startHour;

  @HiveField(8)
  final int startMinute;

  @HiveField(9)
  final int endHour;

  @HiveField(10)
  final int endMinute;

  @HiveField(11)
  final String? subjectId;

  Lecture({
    String? id,
    required this.subjectName,
    required this.type,
    required this.doctorName,
    required this.room,
    required this.building,
    required this.dayOfWeek,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    this.subjectId,
  }) : id = id ?? const Uuid().v4();

  String get timeRange {
    final start = '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')}';
    final end = '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}';
    return '$start - $end';
  }

  String get location => 'قاعة $room، $building';

  bool get isNow {
    final now = DateTime.now();
    if (now.weekday % 7 != dayOfWeek) return false;
    final start = DateTime(now.year, now.month, now.day, startHour, startMinute);
    final end = DateTime(now.year, now.month, now.day, endHour, endMinute);
    return now.isAfter(start) && now.isBefore(end);
  }

  bool get isUpcomingToday {
    final now = DateTime.now();
    if (now.weekday % 7 != dayOfWeek) return false;
    final start = DateTime(now.year, now.month, now.day, startHour, startMinute);
    return start.isAfter(now);
  }

  Duration? get timeUntilStart {
    final now = DateTime.now();
    if (now.weekday % 7 != dayOfWeek) return null;
    final start = DateTime(now.year, now.month, now.day, startHour, startMinute);
    if (start.isBefore(now)) return null;
    return start.difference(now);
  }

  Lecture copyWith({
    String? subjectName,
    String? type,
    String? doctorName,
    String? room,
    String? building,
    int? dayOfWeek,
    int? startHour,
    int? startMinute,
    int? endHour,
    int? endMinute,
    String? subjectId,
  }) {
    return Lecture(
      id: id,
      subjectName: subjectName ?? this.subjectName,
      type: type ?? this.type,
      doctorName: doctorName ?? this.doctorName,
      room: room ?? this.room,
      building: building ?? this.building,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startHour: startHour ?? this.startHour,
      startMinute: startMinute ?? this.startMinute,
      endHour: endHour ?? this.endHour,
      endMinute: endMinute ?? this.endMinute,
      subjectId: subjectId ?? this.subjectId,
    );
  }
}
