import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'subject.g.dart';

@HiveType(typeId: 1)
class Subject extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String nameAr;

  @HiveField(2)
  final String nameEn;

  @HiveField(3)
  final String? code;

  @HiveField(4)
  final double creditHours;

  @HiveField(5)
  final String? doctorName;

  @HiveField(6)
  final int colorValue;

  Subject({
    String? id,
    required this.nameAr,
    required this.nameEn,
    this.code,
    this.creditHours = 3.0,
    this.doctorName,
    this.colorValue = 0xFF4DA6FF,
  }) : id = id ?? const Uuid().v4();

  String displayName(bool isArabic) => isArabic ? nameAr : nameEn;
}
