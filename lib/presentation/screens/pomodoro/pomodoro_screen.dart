import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/app_provider.dart';

enum PomodoroPhase { focus, shortBreak, longBreak }

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  Timer? _timer;
  late int _totalSeconds;
  late int _remainingSeconds;
  PomodoroPhase _phase = PomodoroPhase.focus;
  bool _isRunning = false;
  int _completedFocusSessions = 0;
  bool _showTip = true;

  @override
  void initState() {
    super.initState();
    final settings = context.read<AppProvider>().settings;
    _totalSeconds = settings.focusMinutes * 60;
    _remainingSeconds = _totalSeconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    if (_isRunning) return;
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds <= 0) {
        _onPhaseComplete();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  void _pause() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _reset() {
    _timer?.cancel();
    final settings = context.read<AppProvider>().settings;
    setState(() {
      _isRunning = false;
      _phase = PomodoroPhase.focus;
      _totalSeconds = settings.focusMinutes * 60;
      _remainingSeconds = _totalSeconds;
    });
  }

  void _onPhaseComplete() {
    _timer?.cancel();
    HapticFeedback.heavyImpact();
    final settings = context.read<AppProvider>().settings;

    if (_phase == PomodoroPhase.focus) {
      _completedFocusSessions++;
      if (_completedFocusSessions % 4 == 0) {
        _phase = PomodoroPhase.longBreak;
        _totalSeconds = settings.longBreakMinutes * 60;
      } else {
        _phase = PomodoroPhase.shortBreak;
        _totalSeconds = settings.shortBreakMinutes * 60;
      }
    } else {
      _phase = PomodoroPhase.focus;
      _totalSeconds = settings.focusMinutes * 60;
    }
    setState(() {
      _remainingSeconds = _totalSeconds;
      _isRunning = false;
    });
  }

  String get _timeText {
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get _phaseLabel {
    switch (_phase) {
      case PomodoroPhase.focus:
        return 'FOCUS';
      case PomodoroPhase.shortBreak:
        return 'استراحة قصيرة';
      case PomodoroPhase.longBreak:
        return 'استراحة طويلة';
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final isAr = app.isArabic;
    final progress = 1 - (_remainingSeconds / _totalSeconds);

    return Scaffold(
      appBar: AppBar(
        title: Text(isAr ? 'بومودورو' : 'Pomodoro'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Phase badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _phaseLabel,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Ring
              SizedBox(
                width: 240,
                height: 240,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 240,
                      height: 240,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 12,
                        backgroundColor: AppColors.primarySoft,
                        valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _timeText,
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimaryLight,
                          ),
                        ),
                        Text(
                          isAr ? 'جلسة تركيز عميق' : 'Deep Focus Session',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Text(
                '${_completedFocusSessions % 4}/4',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 24),

              // Duration chips
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _DurationChip(
                    label: '${app.settings.focusMinutes} min',
                    sub: isAr ? 'تركيز' : 'Focus',
                    selected: _phase == PomodoroPhase.focus,
                  ),
                  const SizedBox(width: 12),
                  _DurationChip(
                    label: '${app.settings.shortBreakMinutes} min',
                    sub: isAr ? 'استراحة' : 'Break',
                    selected: _phase == PomodoroPhase.shortBreak,
                  ),
                ],
              ),

              const Spacer(),

              // Start button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isRunning ? _pause : _start,
                  icon: Icon(_isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded),
                  label: Text(
                    _isRunning
                        ? (isAr ? 'إيقاف مؤقت' : 'Pause')
                        : (isAr ? 'ابدأ التركيز' : 'Start Focus'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _reset,
                child: Text(isAr ? 'إعادة ضبط' : 'Reset'),
              ),

              if (_showTip) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb_outline, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isAr
                              ? 'الاستراحات القصيرة تحسن الاحتفاظ بالمعلومات.'
                              : 'Short breaks improve retention.',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () => setState(() => _showTip = false),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DurationChip extends StatelessWidget {
  final String label;
  final String sub;
  final bool selected;

  const _DurationChip({
    required this.label,
    required this.sub,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : AppColors.textPrimaryLight,
            ),
          ),
          Text(
            sub,
            style: TextStyle(
              fontSize: 11,
              color: selected ? Colors.white70 : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
