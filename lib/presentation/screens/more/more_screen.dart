import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/app_provider.dart';
import '../pomodoro/pomodoro_screen.dart';
import '../settings/settings_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = context.watch<AppProvider>().isArabic;

    final items = [
      _MoreItem(Icons.timer_outlined, isAr ? 'بومودورو' : 'Pomodoro', () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const PomodoroScreen()));
      }),
      _MoreItem(Icons.book_outlined, isAr ? 'المواد' : 'Subjects', () {}),
      _MoreItem(Icons.task_alt_outlined, isAr ? 'المهام' : 'Tasks', () {}),
      _MoreItem(Icons.quiz_outlined, isAr ? 'الامتحانات' : 'Exams', () {}),
      _MoreItem(Icons.style_outlined, isAr ? 'فلاش كاردز' : 'Flashcards', () {}),
      _MoreItem(Icons.note_alt_outlined, isAr ? 'ملاحظات' : 'Notes', () {}),
      _MoreItem(Icons.calendar_view_week_outlined, isAr ? 'مخطط المذاكرة' : 'Planner', () {}),
      _MoreItem(Icons.school_outlined, isAr ? 'GPA' : 'GPA', () {}),
      _MoreItem(Icons.fact_check_outlined, isAr ? 'الحضور' : 'Attendance', () {}),
      _MoreItem(Icons.person_outline, isAr ? 'الملف الشخصي' : 'Profile', () {}),
      _MoreItem(Icons.settings_outlined, isAr ? 'الإعدادات' : 'Settings', () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
      }),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Text(
                isAr ? 'المزيد' : 'More',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.95,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: item.onTap,
                      borderRadius: BorderRadius.circular(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.primarySoft,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(item.icon, color: AppColors.primary),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.label,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MoreItem(this.icon, this.label, this.onTap);
}
