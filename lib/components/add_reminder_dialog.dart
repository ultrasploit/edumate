import 'package:edumate/providers/reminder_provider.dart';
import 'package:flutter/material.dart';

class AddReminderDialog extends StatefulWidget {
  const AddReminderDialog({super.key});

  @override
  State<AddReminderDialog> createState() => _AddReminderDialogState();
}

class _AddReminderDialogState extends State<AddReminderDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  DateTime? selectedDate;

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add a reminder'),
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
            controller: bodyController,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              label: Text('Body'),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  selectedDate == null
                      ? 'No date & time chosen'
                      : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} ${selectedDate!.hour}:${selectedDate!.minute.toString().padLeft(2, '0')}',
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
          child: Text('Add'),
          onPressed: () async {
            if (titleController.text.isEmpty ||
                bodyController.text.isEmpty ||
                selectedDate == null) {
              return;
            }

            final scaffoldMessenger = ScaffoldMessenger.of(context);
            Navigator.pop(context);

            final id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
            final notification = await NotiService().scheduleNotification(
              id: id,
              title: titleController.text,
              body: bodyController.text,
              scheduledDate: selectedDate!,
            );

            if (!mounted) return;

            if (notification == 'Success') {
              scaffoldMessenger.showSnackBar(SnackBar(content: Text('Reminder scheduled successfully!')));
            }
          },
        ),
      ],
    );
  }
}
