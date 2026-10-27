import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/lecture.dart';
import '../../providers/app_provider.dart';
import '../../providers/lectures_provider.dart';
import '../../widgets/glass_card.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  static const _dayNamesAr = ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];
  static const _dayNamesEn = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final lectures = context.watch<LecturesProvider>();
    final isAr = app.isArabic;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Row(
                children: [
                  _circleBtn(Icons.menu_rounded),
                  const Spacer(),
                  Column(
                    children: [
                      Text(
                        isAr ? 'الجدول الدراسي' : 'Timetable',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      Text(
                        isAr ? 'نظم وقتك، حقق أهدافك' : 'Organize your time',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const Spacer(),
                  _circleBtn(Icons.notifications_none_rounded),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                physics: const BouncingScrollPhysics(),
                itemCount: 7,
                itemBuilder: (context, dayIndex) {
                  final dayLectures = lectures.lecturesForDay(dayIndex);
                  return _DayCard(
                    dayName: isAr ? _dayNamesAr[dayIndex] : _dayNamesEn[dayIndex],
                    dayIndex: dayIndex,
                    lectures: dayLectures,
                    isArabic: isAr,
                    onAdd: () => _showAddLecture(context, dayIndex),
                    onDelete: (id) => _confirmDelete(context, id),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton(
          onPressed: () => _showAddLecture(context, DateTime.now().weekday % 7),
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _circleBtn(IconData icon) {
    return Material(
      color: Colors.white.withOpacity(0.7),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => HapticFeedback.lightImpact(),
        child: SizedBox(width: 42, height: 42, child: Icon(icon, size: 22)),
      ),
    );
  }

  void _showAddLecture(BuildContext context, int dayOfWeek) {
    // Simplified add dialog – full form in production
    final subjectCtrl = TextEditingController();
    final roomCtrl = TextEditingController();
    final buildingCtrl = TextEditingController(text: 'مبنى العلوم');
    final doctorCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            left: 20,
            right: 20,
            top: 20,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('إضافة محاضرة', style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextField(controller: subjectCtrl, decoration: const InputDecoration(labelText: 'اسم المادة')),
              const SizedBox(height: 10),
              TextField(controller: doctorCtrl, decoration: const InputDecoration(labelText: 'الدكتور')),
              const SizedBox(height: 10),
              TextField(controller: roomCtrl, decoration: const InputDecoration(labelText: 'رقم القاعة')),
              const SizedBox(height: 10),
              TextField(controller: buildingCtrl, decoration: const InputDecoration(labelText: 'المبنى')),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (subjectCtrl.text.trim().isEmpty) return;
                    final lecture = Lecture(
                      subjectName: subjectCtrl.text.trim(),
                      type: 'lecture',
                      doctorName: doctorCtrl.text.trim(),
                      room: roomCtrl.text.trim().isEmpty ? '—' : roomCtrl.text.trim(),
                      building: buildingCtrl.text.trim(),
                      dayOfWeek: dayOfWeek,
                      startHour: 10,
                      startMinute: 0,
                      endHour: 12,
                      endMinute: 0,
                    );
                    context.read<LecturesProvider>().add(lecture);
                    Navigator.pop(ctx);
                  },
                  child: const Text('حفظ'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذه المحاضرة؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('لا')),
          TextButton(
            onPressed: () {
              context.read<LecturesProvider>().delete(id);
              Navigator.pop(ctx);
            },
            child: const Text('نعم'),
          ),
        ],
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final String dayName;
  final int dayIndex;
  final List<Lecture> lectures;
  final bool isArabic;
  final VoidCallback onAdd;
  final ValueChanged<String> onDelete;

  const _DayCard({
    required this.dayName,
    required this.dayIndex,
    required this.lectures,
    required this.isArabic,
    required this.onAdd,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    dayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const Spacer(),
                if (lectures.isEmpty)
                  Text(
                    isArabic ? 'يوم راحة' : 'Rest day',
                    style: const TextStyle(color: AppColors.textSecondaryLight),
                  ),
              ],
            ),
            if (lectures.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  isArabic ? 'استمتع بوقتك واشحن طاقتك ☀️' : 'Enjoy your free time',
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
                ),
              )
            else
              ...lectures.map((l) => Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${l.timeRange}  •  ${l.subjectName}',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '${l.type == 'section' ? (isArabic ? 'سيكشن' : 'Section') : (isArabic ? 'محاضرة' : 'Lecture')} • ${l.doctorName}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                          onPressed: () => onDelete(l.id),
                        ),
                      ],
                    ),
                  )),
            TextButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 18),
              label: Text(isArabic ? 'إضافة محاضرة' : 'Add lecture'),
            ),
          ],
        ),
      ),
    );
  }
}
