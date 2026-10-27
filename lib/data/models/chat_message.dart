import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'chat_message.g.dart';

@HiveType(typeId: 6)
class ChatMessage extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String role; // 'user' or 'assistant'

  @HiveField(2)
  final String content;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final bool isCode;

  ChatMessage({
    String? id,
    required this.role,
    required this.content,
    DateTime? timestamp,
    this.isCode = false,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();
}
