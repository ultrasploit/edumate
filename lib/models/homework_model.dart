import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart'; 

part 'homework_model.g.dart';

@HiveType(typeId: 0)
class Homework extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String subject;

  @HiveField(2)
  DateTime dueDate;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  bool? isCompleted;

  @HiveField(5)
  DateTime? completedAt;

  @HiveField(6)
  int? notificationId;

  Homework({
    required this.title,
    required this.subject,
    required this.dueDate,
    required this.createdAt,
    this.isCompleted = false,
    this.completedAt,
    this.notificationId = 0
  });
}