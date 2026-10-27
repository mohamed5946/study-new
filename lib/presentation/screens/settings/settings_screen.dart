import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/services/ai_service.dart';
import '../../../data/services/hive_service.dart';
import '../../providers/app_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _aiTestResult;
  bool _testing = false;

  Future<void> _testAI() async {
    setState(() {
      _testing = true;
      _aiTestResult = null;
    });
    final result = await AIService.testConnection();
    setState(() {
      _testing = false;
      _aiTestResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final isAr = app.isArabic;
    final s = app.settings;

    return Scaffold(
      appBar: AppBar(
        title: Text(isAr ? 'الإعدادات' : 'Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          // Language
          _sectionTitle(isAr ? 'اللغة' : 'Language'),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                RadioListTile<String>(
                  value: 'en',
                  groupValue: s.languageCode,
                  onChanged: (v) => app.setLanguage(v!),
                  title: const Row(
                    children: [
                      Text('🇺🇸  English'),
                    ],
                  ),
                  activeColor: AppColors.primary,
                ),
                RadioListTile<String>(
                  value: 'ar',
                  groupValue: s.languageCode,
                  onChanged: (v) => app.setLanguage(v!),
                  title: const Row(
                    children: [
                      Text('🇸🇦  العربية'),
                    ],
                  ),
                  activeColor: AppColors.primary,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          _sectionTitle(isAr ? 'المظهر' : 'Theme'),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                _themeChip(
                  label: isAr ? 'فاتح' : 'Light',
                  icon: Icons.light_mode,
                  selected: s.themeMode == 'light',
                  onTap: () => app.setThemeMode('light'),
                ),
                _themeChip(
                  label: isAr ? 'داكن' : 'Dark',
                  icon: Icons.dark_mode,
                  selected: s.themeMode == 'dark',
                  onTap: () => app.setThemeMode('dark'),
                ),
                _themeChip(
                  label: 'System',
                  icon: Icons.brightness_auto,
                  selected: s.themeMode == 'system',
                  onTap: () => app.setThemeMode('system'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          _sectionTitle(isAr ? 'مدد البومودورو' : 'Pomodoro Durations'),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(isAr ? 'مدة التركيز' : 'Focus Duration'),
                  trailing: Text('${s.focusMinutes} min'),
                  onTap: () => _editMinutes(context, s.focusMinutes, (v) {
                    app.setPomodoroDurations(focus: v);
                  }),
                ),
                ListTile(
                  title: Text(isAr ? 'استراحة قصيرة' : 'Short Break'),
                  trailing: Text('${s.shortBreakMinutes} min'),
                  onTap: () => _editMinutes(context, s.shortBreakMinutes, (v) {
                    app.setPomodoroDurations(shortBreak: v);
                  }),
                ),
                ListTile(
                  title: Text(isAr ? 'استراحة طويلة' : 'Long Break'),
                  trailing: Text('${s.longBreakMinutes} min'),
                  onTap: () => _editMinutes(context, s.longBreakMinutes, (v) {
                    app.setPomodoroDurations(longBreak: v);
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          _sectionTitle(isAr ? 'اختبار الذكاء الاصطناعي' : 'AI Connection Test'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: _testing ? null : _testAI,
                  child: _testing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(isAr ? 'اختبار الاتصال' : 'Test Connection'),
                ),
                if (_aiTestResult != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _aiTestResult!,
                    style: TextStyle(
                      fontSize: 12,
                      color: _aiTestResult == 'OK' ? AppColors.success : AppColors.error,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),
          SwitchListTile(
            title: Text(isAr ? 'تقليل الحركات' : 'Reduce Animations'),
            value: s.reduceAnimations,
            onChanged: (v) => app.setReduceAnimations(v),
            activeColor: AppColors.primary,
          ),

          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: AppColors.error),
            title: Text(isAr ? 'مسح كل البيانات' : 'Clear All Data'),
            onTap: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(isAr ? 'تأكيد' : 'Confirm'),
                  content: Text(isAr
                      ? 'هل أنت متأكد؟ سيتم حذف كل البيانات نهائيًا.'
                      : 'Are you sure? All data will be permanently deleted.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(isAr ? 'لا' : 'No')),
                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(isAr ? 'نعم' : 'Yes')),
                  ],
                ),
              );
              if (ok == true) {
                await HiveService.lecturesBox.clear();
                await HiveService.tasksBox.clear();
                await HiveService.notesBox.clear();
                await HiveService.chatBox.clear();
                await HiveService.pdfsBox.clear();
                await HiveService.attendanceBox.clear();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isAr ? 'تم المسح' : 'Cleared')),
                  );
                }
              }
            },
          ),

          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(isAr ? 'حول البرنامج' : 'About study'),
            subtitle: const Text('v1.0.0 • Local-first • Offline'),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: AppColors.textSecondaryLight,
        ),
      ),
    );
  }

  Widget _themeChip({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Material(
          color: selected ? AppColors.primary : AppColors.primarySoft,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  Icon(icon, color: selected ? Colors.white : AppColors.primary, size: 22),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _editMinutes(BuildContext context, int current, ValueChanged<int> onSave) {
    final ctrl = TextEditingController(text: current.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تعديل المدة (دقائق)'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'دقائق'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              final v = int.tryParse(ctrl.text);
              if (v != null && v > 0 && v <= 120) {
                onSave(v);
                Navigator.pop(ctx);
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}
