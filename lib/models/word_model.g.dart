// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordAdapter extends TypeAdapter<Word> {
  @override
  final int typeId = 1;

  @override
  Word read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Word(
      word: fields[0] as String,
      definition: fields[1] as String?,
      synonyms: (fields[2] as List?)?.cast<String>(),
      antonyms: (fields[3] as List?)?.cast<String>(),
      example: fields[4] as String?,
      pronunciation: fields[5] as String?,
      origin: fields[6] as String?,
      partOfSpeech: fields[7] as String?,
      tags: (fields[8] as List?)?.cast<String>(),
      notes: fields[9] as String?,
      dateAdded: fields[10] as DateTime?,
      isFavorite: fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Word obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.word)
      ..writeByte(1)
      ..write(obj.definition)
      ..writeByte(2)
      ..write(obj.synonyms)
      ..writeByte(3)
      ..write(obj.antonyms)
      ..writeByte(4)
      ..write(obj.example)
      ..writeByte(5)
      ..write(obj.pronunciation)
      ..writeByte(6)
      ..write(obj.origin)
      ..writeByte(7)
      ..write(obj.partOfSpeech)
      ..writeByte(8)
      ..write(obj.tags)
      ..writeByte(9)
      ..write(obj.notes)
      ..writeByte(10)
      ..write(obj.dateAdded)
      ..writeByte(11)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
