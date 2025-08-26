import 'package:edumate/models/word_model.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class DictionaryProvider with ChangeNotifier {
  static const String boxName = 'dictionary';
  late Box<Word> _box;

  List<Word> get words => _box.values.toList();
  Word getWordAt(int index) => _box.getAt(index)!;

  int get count => _box.length;

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      _box = await Hive.openBox<Word>(boxName);
    } else {
      _box = Hive.box<Word>(boxName);
    }
    notifyListeners();
  }

  Future<void> addWord(Word word) async {
    await _box.add(word);
    notifyListeners();
  }

  Future<void> deleteWordAt(int index) async {
    await _box.deleteAt(index);
    notifyListeners();
  }

  Future<void> updateWordAt(int index, Word updated) async {
    await _box.putAt(index, updated);
    notifyListeners();
  }

  List<Word> get wordsAddedToday {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = DateTime(today.year, today.month, today.day, 23, 59, 59);

    return _box.values.where((word) {
      if (word.dateAdded == null) return false;
      return word.dateAdded!.isAfter(todayStart) &&
          word.dateAdded!.isBefore(todayEnd);
    }).toList();
  }
}
