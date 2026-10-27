import 'package:flutter/material.dart';

/// Baby-blue only palette. No purple, pink, or lavender allowed.
class AppColors {
  // Primary baby blue
  static const Color primary = Color(0xFF4DA6FF);
  static const Color primaryLight = Color(0xFF7EC8FF);
  static const Color primaryDark = Color(0xFF2B8AE0);
  static const Color primarySoft = Color(0xFFE8F4FF);

  // Gradient for next lecture card
  static const Color gradientStart = Color(0xFF5BB0FF);
  static const Color gradientEnd = Color(0xFF3A8FE0);

  // Backgrounds
  static const Color backgroundLight = Color(0xFFF5F9FF);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E293B);

  // Text
  static const Color textPrimaryLight = Color(0xFF1E293B);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Glass
  static const Color glassLight = Color(0xCCFFFFFF);
  static const Color glassDark = Color(0xCC1E293B);

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Timeline dots
  static const Color timelineDot = primary;
  static const Color timelineLine = Color(0xFFBFDBFE);

  // Bottom nav selected pill
  static const LinearGradient selectedTabGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Next lecture card gradient
  static const LinearGradient nextLectureGradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
