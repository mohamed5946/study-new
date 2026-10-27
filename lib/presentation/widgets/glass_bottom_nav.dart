import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';

class GlassBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isArabic;

  const GlassBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final items = [
      _NavItem(Icons.home_rounded, isArabic ? 'الرئيسية' : 'Home'),
      _NavItem(Icons.calendar_month_rounded, isArabic ? 'الجدول' : 'Timetable'),
      _NavItem(Icons.smart_toy_rounded, isArabic ? 'AI' : 'AI Chat'),
      _NavItem(Icons.menu_book_rounded, isArabic ? 'المذاكرة' : 'Study'),
      _NavItem(Icons.more_horiz_rounded, isArabic ? 'المزيد' : 'More'),
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.bottomNavRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: AppConstants.glassBlur,
              sigmaY: AppConstants.glassBlur,
            ),
            child: Container(
              height: AppConstants.bottomNavHeight,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.glassDark
                    : AppColors.glassLight,
                borderRadius: BorderRadius.circular(AppConstants.bottomNavRadius),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.white.withOpacity(0.6),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(items.length, (index) {
                  final selected = currentIndex == index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        onTap(index);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                        decoration: selected
                            ? BoxDecoration(
                                gradient: AppColors.selectedTabGradient,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.35),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              )
                            : null,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              items[index].icon,
                              size: 24,
                              color: selected
                                  ? Colors.white
                                  : (isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              items[index].label,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                                color: selected
                                    ? Colors.white
                                    : (isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}
