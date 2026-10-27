import 'package:flutter/material.dart';
import '../../data/models/lecture.dart';
import '../../data/services/hive_service.dart';

class LecturesProvider extends ChangeNotifier {
  List<Lecture> get all => HiveService.lecturesBox.values.toList();

  List<Lecture> lecturesForDay(int dayOfWeek) {
    return all.where((l) => l.dayOfWeek == dayOfWeek).toList()
      ..sort((a, b) {
        final aMin = a.startHour * 60 + a.startMinute;
        final bMin = b.startHour * 60 + b.startMinute;
        return aMin.compareTo(bMin);
      });
  }

  List<Lecture> get todayLectures {
    // DateTime.weekday: Mon=1 ... Sun=7 → we use Sun=0
    final today = DateTime.now().weekday % 7;
    return lecturesForDay(today);
  }

  Lecture? get nextLectureToday {
    final now = DateTime.now();
    final today = todayLectures;
    for (final l in today) {
      final start = DateTime(now.year, now.month, now.day, l.startHour, l.startMinute);
      if (start.isAfter(now) || l.isNow) return l;
    }
    return null;
  }

  Future<void> add(Lecture lecture) async {
    await HiveService.lecturesBox.put(lecture.id, lecture);
    notifyListeners();
  }

  Future<void> update(Lecture lecture) async {
    await HiveService.lecturesBox.put(lecture.id, lecture);
    notifyListeners();
  }

  Future<void> delete(String id) async {
    await HiveService.lecturesBox.delete(id);
    notifyListeners();
  }
}
