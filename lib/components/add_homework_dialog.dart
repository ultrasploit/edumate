import 'package:edumate/models/homework_model.dart';
import 'package:edumate/providers/homework_provider.dart';
import 'package:edumate/providers/reminder_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddHomeworkDialog extends StatefulWidget {
  const AddHomeworkDialog({super.key});

  @override
  State<AddHomeworkDialog> createState() => _AddHomeworkDialogState();
}

class _AddHomeworkDialogState extends State<AddHomeworkDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  DateTime? selectedDate;

  @override
  void dispose() {
    titleController.dispose();
    subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add homework'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              label: Text('Title'),
            ),
          ),
          TextField(
            controller: subjectController,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              label: Text('Subject'),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Due: ${selectedDate == null ? 'No date & time chosen' : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} ${selectedDate!.hour}:${selectedDate!.minute.toString().padLeft(2, '0')}'}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate == null || !context.mounted) return;

                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime == null || !context.mounted) return;

                  final dt = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );

                  setState(() => selectedDate = dt);
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (titleController.text.isEmpty ||
                subjectController.text.isEmpty ||
                selectedDate == null) {
              return;
            }

          final scaffoldMessenger = ScaffoldMessenger.of(context);
            Navigator.pop(context);

            final homework = Homework(
              title: titleController.text,
              subject: subjectController.text,
              dueDate: selectedDate!,
              createdAt: DateTime.now(),
            );

            final homeworkProvider = Provider.of<HomeworkProvider>(
              context,
              listen: false,
            );
            final scheduledDate = DateTime(
              selectedDate!.year,
              selectedDate!.month,
              selectedDate!.day - 1,
              8, // 8 AM
              30,
            );

            final id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
            final noti = await NotiService().scheduleNotification(
              id: id,
              title: 'Don\'t forget your homework!',
              body: 'Complete your ${homework.subject} homework!',
              scheduledDate: scheduledDate,
            );

            if(!mounted || noti.isEmpty) return;

            if (noti == 'Success') {
              homework.notificationId = id;
              scaffoldMessenger.showSnackBar(SnackBar(content: Text('A reminder scheduled successfully!')));
            }

            homeworkProvider.addHomework(homework);
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
