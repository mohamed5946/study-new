import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/lecture.dart';
import '../../providers/app_provider.dart';
import '../../providers/lectures_provider.dart';
import '../../widgets/glass_card.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onAskAI;
  final VoidCallback? onUploadPdf;
  final VoidCallback? onAddLecture;

  const HomeScreen({
    super.key,
    this.onAskAI,
    this.onUploadPdf,
    this.onAddLecture,
  });

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final lectures = context.watch<LecturesProvider>();
    final isAr = app.isArabic;
    final now = DateTime.now();
    final hour = now.hour;

    String greeting;
    if (hour < 12) {
      greeting = isAr ? 'صباح الخير' : 'Good morning';
    } else if (hour < 17) {
      greeting = isAr ? 'مساء الخير' : 'Good afternoon';
    } else {
      greeting = isAr ? 'مساء الخير' : 'Good evening';
    }

    final next = lectures.nextLectureToday;
    final todayList = lectures.todayLectures;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            OnlineSliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        _circleButton(Icons.menu_rounded, () {}),
                        const Spacer(),
                        _circleButton(Icons.person_outline_rounded, () {}),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '$greeting، ${app.userName} 👋',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isAr
                          ? 'جهز ليومك الدراسي بتركيز وتنظيم ✨'
                          : 'Prepare your study day with focus ✨',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondaryLight,
                          ),
                    ),
                    const SizedBox(height: 20),
                    if (next != null)
                      _NextLectureCard(lecture: next, isArabic: isAr)
                    else
                      GlassCard(
                        child: Center(
                          child: Text(
                            isAr ? 'مفيش محاضرات النهاردة 🎉' : 'No lectures today 🎉',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _QuickAction(
                            icon: Icons.auto_awesome,
                            label: isAr ? 'اسأل AI' : 'Ask AI',
                            onTap: onAskAI,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _QuickAction(
                            icon: Icons.picture_as_pdf_outlined,
                            label: isAr ? 'رفع PDF' : 'Upload PDF',
                            onTap: onUploadPdf,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _QuickAction(
                            icon: Icons.add_circle_outline,
                            label: isAr ? 'إضافة محاضرة' : 'Add Lecture',
                            onTap: onAddLecture,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          isAr ? 'محاضرات اليوم' : 'Today\'s Lectures',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            if (todayList.isEmpty)
              OnlineSliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassCard(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(isAr ? 'يوم راحة ☀️' : 'Rest day ☀️'),
                      ),
                    ),
                  ),
                ),
              )
            else
              OnlineSliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: OnlineSliverList(
                  delegate: OnlineSliverChildBuilderDelegate(
                    (context, index) {
                      final l = todayList[index];
                      return _TimelineItem(
                        lecture: l,
                        isLast: index == todayList.length - 1,
                      );
                    },
                    childCount: todayList.length,
                  ),
                ),
              ),
            const OnlineSliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white.withOpacity(0.7),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, size: 22, color: AppColors.textPrimaryLight),
        ),
      ),
    );
  }
}

// Aliases to keep code clean
class OnlineSliverToBoxAdapter extends SliverToBoxAdapter {
  const OnlineSliverToBoxAdapter({super.key, super.child});
}
class OnlineSliverPadding extends SliverPadding {
  const OnlineSliverPadding({super.key, required super.padding, super.sliver});
}
class OnlineSliverList extends SliverList {
  const OnlineSliverList({super.key, required super.delegate});
}
class OnlineSliverChildBuilderDelegate extends OnlineSliverChildBuilderDelegateBase {
  OnlineSliverChildBuilderDelegate(NullableIndexedWidgetBuilder builder, {int? childCount})
      : super(builder, childCount: childCount);
}
class OnlineSliverChildBuilderDelegateBase extends SliverChildBuilderDelegate {
  OnlineSliverChildBuilderDelegateBase(super.builder, {super.childCount});
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap?.call();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withOpacity(0.15)),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 22),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryLight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NextLectureCard extends StatelessWidget {
  final Lecture lecture;
  final bool isArabic;

  const _NextLectureCard({required this.lecture, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final until = lecture.timeUntilStart;
    String statusText;
    if (lecture.isNow) {
      statusText = isArabic ? 'الآن' : 'Now';
    } else if (until != null) {
      final mins = until.inMinutes;
      statusText = isArabic ? 'بعد $mins دقيقة' : 'In $mins min';
    } else {
      statusText = isArabic ? 'قادمة' : 'Upcoming';
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.nextLectureGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isArabic ? 'المحاضرة القادمة' : 'Next Lecture',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.access_time_rounded, color: Colors.white70, size: 22),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            lecture.subjectName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.schedule, color: Colors.white70, size: 16),
              const SizedBox(width: 6),
              Text(
                lecture.timeRange,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: Colors.white70, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  lecture.location,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final Lecture lecture;
  final bool isLast;

  const _TimelineItem({
    required this.lecture,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 56,
            child: Column(
              children: [
                Text(
                  '${lecture.startHour.toString().padLeft(2, '0')}:${lecture.startMinute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  '${lecture.endHour.toString().padLeft(2, '0')}:${lecture.endMinute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: AppColors.timelineLine,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withOpacity(0.08)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lecture.subjectName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lecture.location,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      lecture.room,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
