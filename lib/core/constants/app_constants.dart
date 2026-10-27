class AppConstants {
  // App identity
  static const String appName = 'study';
  static const String packageName = 'com.mohamed5946.newstudy';
  static const String defaultUserNameAr = 'محمد';
  static const String defaultUserNameEn = 'Mohamed';

  // Groq
  static const String groqBaseUrl = 'https://api.groq.com/openai/v1';
  static const String groqModel = 'openai/gpt-oss-20b';
  // Key is injected at build time: --dart-define=GROQ_API_KEY=xxxxx
  static const String groqApiKey = String.fromEnvironment('GROQ_API_KEY');

  // Hive boxes
  static const String boxSettings = 'settings';
  static const String boxSubjects = 'subjects';
  static const String boxLectures = 'lectures';
  static const String boxTasks = 'tasks';
  static const String boxNotes = 'notes';
  static const String boxFlashcards = 'flashcards';
  static const String boxAttendance = 'attendance';
  static const String boxExams = 'exams';
  static const String boxPdfs = 'pdfs';
  static const String boxChat = 'chat';
  static const String boxPomodoro = 'pomodoro';
  static const String boxStudySessions = 'study_sessions';

  // Pomodoro defaults (minutes)
  static const int defaultFocusMinutes = 25;
  static const int defaultShortBreakMinutes = 5;
  static const int defaultLongBreakMinutes = 15;
  static const int sessionsBeforeLongBreak = 4;

  // UI
  static const double bottomNavHeight = 72.0;
  static const double bottomNavRadius = 28.0;
  static const double glassBlur = 22.0;
  static const double cardRadius = 24.0;
  static const double pressScale = 0.96;

  // Forbidden word
  static const String forbiddenWord = 'حصص';
}
