import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:study_assistant/data/models/app_settings.dart';
import 'package:study_assistant/data/models/attendance.dart';
import 'package:study_assistant/data/models/chat_message.dart';
import 'package:study_assistant/data/models/lecture.dart';
import 'package:study_assistant/data/models/note.dart';
import 'package:study_assistant/data/models/pdf_file.dart';
import 'package:study_assistant/data/models/subject.dart';
import 'package:study_assistant/data/models/task.dart';
import 'package:study_assistant/presentation/providers/app_provider.dart';
import 'package:study_assistant/presentation/providers/lectures_provider.dart';
import 'package:study_assistant/presentation/screens/shell/main_shell.dart';
import 'package:study_assistant/core/theme/app_theme.dart';

void main() {
  testWidgets('boot: MainShell builds without throwing', (tester) async {
    await tester.runAsync(() async {
      final dir = await Directory.systemTemp.createTemp('hive-boot3');
      Hive.init(dir.path);
      Hive.registerAdapter(LectureAdapter());
      Hive.registerAdapter(SubjectAdapter());
      Hive.registerAdapter(TaskItemAdapter());
      Hive.registerAdapter(NoteAdapter());
      Hive.registerAdapter(AttendanceRecordAdapter());
      Hive.registerAdapter(AppSettingsAdapter());
      Hive.registerAdapter(ChatMessageAdapter());
      Hive.registerAdapter(PdfFileAdapter());
      await Hive.openBox<AppSettings>('settings');
      await Hive.openBox<Subject>('subjects');
      await Hive.openBox<Lecture>('lectures');
      await Hive.openBox<TaskItem>('tasks');
      await Hive.openBox<Note>('notes');
      await Hive.openBox<AttendanceRecord>('attendance');
      await Hive.openBox<ChatMessage>('chat');
      await Hive.openBox<PdfFile>('pdfs');
      await Hive.box<AppSettings>('settings').put('main', AppSettings());
    });
    // ignore: avoid_print
    print('BOOT hive-ready');

    Object? caught;
    final prev = FlutterError.onError;
    FlutterError.onError = (d) {
      caught ??= d.exception;
      // ignore: avoid_print
      print('FLUTTER ERROR: ${d.exception}');
      prev?.call(d);
    };

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppProvider()),
          ChangeNotifierProvider(create: (_) => LecturesProvider()),
        ],
        child: MaterialApp(theme: AppTheme.light(), home: const MainShell()),
      ),
    );
    // ignore: avoid_print
    print('BOOT pumped-1');
    await tester.pump();
    // ignore: avoid_print
    print('BOOT pumped-2');
    final err = tester.takeException();
    // ignore: avoid_print
    print('BOOT takeException=$err onError=$caught');
    expect(err, isNull);
    expect(find.textContaining('محمد'), findsAny);
    await tester.runAsync(() => Hive.close());
  }, timeout: const Timeout(Duration(seconds: 90)));
}
