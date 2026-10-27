import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../widgets/glass_bottom_nav.dart';
import '../home/home_screen.dart';
import '../timetable/timetable_screen.dart';
import '../ai_chat/ai_chat_screen.dart';
import '../study/study_screen.dart';
import '../more/more_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(
        onAskAI: () => setState(() => _currentIndex = 2),
        onUploadPdf: () => setState(() => _currentIndex = 3),
        onAddLecture: () {
          // Will open add lecture dialog from timetable later
          setState(() => _currentIndex = 1);
        },
      ),
      const TimetableScreen(),
      const AiChatScreen(),
      const StudyScreen(),
      const MoreScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<AppProvider>().isArabic;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: GlassBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        isArabic: isArabic,
      ),
    );
  }
}
