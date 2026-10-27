import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../models/lecture.dart';
import '../models/subject.dart';
import '../models/task.dart';
import '../models/note.dart';
import '../models/attendance.dart';
import '../models/app_settings.dart';
import '../models/chat_message.dart';
import '../models/pdf_file.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(LectureAdapter());
    Hive.registerAdapter(SubjectAdapter());
    Hive.registerAdapter(TaskItemAdapter());
    Hive.registerAdapter(NoteAdapter());
    Hive.registerAdapter(AttendanceRecordAdapter());
    Hive.registerAdapter(AppSettingsAdapter());
    Hive.registerAdapter(ChatMessageAdapter());
    Hive.registerAdapter(PdfFileAdapter());

    // Open boxes
    await Hive.openBox<AppSettings>(AppConstants.boxSettings);
    await Hive.openBox<Subject>(AppConstants.boxSubjects);
    await Hive.openBox<Lecture>(AppConstants.boxLectures);
    await Hive.openBox<TaskItem>(AppConstants.boxTasks);
    await Hive.openBox<Note>(AppConstants.boxNotes);
    await Hive.openBox<AttendanceRecord>(AppConstants.boxAttendance);
    await Hive.openBox<ChatMessage>(AppConstants.boxChat);
    await Hive.openBox<PdfFile>(AppConstants.boxPdfs);

    // Ensure default settings exist
    final settingsBox = Hive.box<AppSettings>(AppConstants.boxSettings);
    if (settingsBox.isEmpty) {
      await settingsBox.put('main', AppSettings());
    }
  }

  static Box<AppSettings> get settingsBox =>
      Hive.box<AppSettings>(AppConstants.boxSettings);

  static Box<Subject> get subjectsBox =>
      Hive.box<Subject>(AppConstants.boxSubjects);

  static Box<Lecture> get lecturesBox =>
      Hive.box<Lecture>(AppConstants.boxLectures);

  static Box<TaskItem> get tasksBox =>
      Hive.box<TaskItem>(AppConstants.boxTasks);

  static Box<Note> get notesBox => Hive.box<Note>(AppConstants.boxNotes);

  static Box<AttendanceRecord> get attendanceBox =>
      Hive.box<AttendanceRecord>(AppConstants.boxAttendance);

  static Box<ChatMessage> get chatBox =>
      Hive.box<ChatMessage>(AppConstants.boxChat);

  static Box<PdfFile> get pdfsBox => Hive.box<PdfFile>(AppConstants.boxPdfs);

  static AppSettings get settings {
    return settingsBox.get('main') ?? AppSettings();
  }

  static Future<void> saveSettings(AppSettings s) async {
    await settingsBox.put('main', s);
  }
}
