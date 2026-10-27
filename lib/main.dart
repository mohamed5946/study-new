import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'data/services/hive_service.dart';
import 'presentation/providers/app_provider.dart';
import 'presentation/providers/lectures_provider.dart';
import 'presentation/screens/shell/main_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Status bar style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  await HiveService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => LecturesProvider()),
      ],
      child: const StudyAssistantApp(),
    ),
  );
}

class StudyAssistantApp extends StatelessWidget {
  const StudyAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    return MaterialApp(
      title: 'study',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: app.themeMode,
      locale: Locale(app.settings.languageCode),
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const MainShell(),
    );
  }
}
