class Reminder {
  final int id; // unique id for notification
  final String title;
  final String body;
  final DateTime scheduledDate;

  Reminder({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledDate,
  });
}