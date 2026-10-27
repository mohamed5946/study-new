import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'pdf_file.g.dart';

@HiveType(typeId: 7)
class PdfFile extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String path;

  @HiveField(3)
  final DateTime addedAt;

  @HiveField(4)
  final int pageCount;

  @HiveField(5)
  final String? extractedText;

  @HiveField(6)
  final String? subjectId;

  PdfFile({
    String? id,
    required this.name,
    required this.path,
    DateTime? addedAt,
    this.pageCount = 0,
    this.extractedText,
    this.subjectId,
  })  : id = id ?? const Uuid().v4(),
        addedAt = addedAt ?? DateTime.now();
}
