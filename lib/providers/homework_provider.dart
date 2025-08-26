import 'package:edumate/models/homework_model.dart';
import 'package:edumate/providers/reminder_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class HomeworkProvider with ChangeNotifier {
  static const String boxName = 'HomeWork';
  late Box<Homework> _box;

  List<Homework> get homework => _box.values.toList();

  int get count => _box.length;
  List<Homework> get completedHomework =>
      _box.values.where((hw) => hw.isCompleted == true).toList();
  List<Homework> get incompleteHomework =>
      _box.values.where((hw) => hw.isCompleted == false).toList();
  List<Homework> get incompleteHomeworkSortedByDueDate {
    final incomplete = _box.values
        .where((hw) => hw.isCompleted == false)
        .toList();
    incomplete.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return incomplete;
  }

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      _box = await Hive.openBox(boxName);
    } else {
      _box = Hive.box<Homework>(boxName);
    }

    notifyListeners();
  }

  Future<void> addHomework(Homework homework) async {
    await _box.add(homework);
    notifyListeners();
  }

  Future<void> markHomeworkCompleted(Homework homework) async {
    // Make sure the homework exists in the box
    final key = _box.keyAt(_box.values.toList().indexOf(homework));
    final id = homework.notificationId;
    if (id != null) {
      NotiService().cancelNotification(id);
    }
    
    if (key != null) {
      homework.isCompleted = true;
      await _box.put(key, homework);
      notifyListeners();
    }
  }

  Future<void> markHomeworkIncomplete(Homework homework) async {
    // Make sure the homework exists in the box
    final key = _box.keyAt(_box.values.toList().indexOf(homework));
    if (key != null) {
      homework.isCompleted = false;
      await _box.put(key, homework);
      notifyListeners();
    }
  }

  Future<void> updateHomeworkAt(int index, Homework homework) async {
    await _box.putAt(index, homework);
    notifyListeners();
  }

  Future<void> deleteHomeworkAt(int index) async {
    final hw = _box.getAt(index);

    if (hw != null) {
      final id = hw.notificationId;
      if (id != null) {
        NotiService().cancelNotification(id);
      }
    }
    await _box.deleteAt(index);
    notifyListeners();
  }

  int getDaysLeft(Homework homework) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final dueDate = homework.dueDate;
    final date = DateTime(dueDate.year, dueDate.month, dueDate.day);

    return date.difference(today).inDays;
  }
}
