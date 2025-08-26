import 'package:hive/hive.dart';

part 'word_model.g.dart';

@HiveType(typeId: 1)
class Word extends HiveObject {
  @HiveField(0)
  String word;

  @HiveField(1)
  String? definition;

  @HiveField(2)
  List<String>? synonyms;

  @HiveField(3)
  List<String>? antonyms;

  @HiveField(4)
  String? example;

  @HiveField(5)
  String? pronunciation;

  @HiveField(6)
  String? origin;

  @HiveField(7)
  String? partOfSpeech;

  @HiveField(8)
  List<String>? tags;

  @HiveField(9)
  String? notes;

  @HiveField(10)
  DateTime? dateAdded;

  @HiveField(11)
  bool isFavorite;

  Word({
    required this.word,
    this.definition,
    this.synonyms,
    this.antonyms,
    this.example,
    this.pronunciation,
    this.origin,
    this.partOfSpeech,
    this.tags,
    this.notes,
    this.dateAdded,
    this.isFavorite = false,
  });
}
