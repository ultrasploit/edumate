import 'package:edumate/components/add_reminder_dialog.dart';
import 'package:edumate/providers/reminder_provider.dart';
import 'package:flutter/material.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  List reminders = [];

  void getReminders() async {
    final pendingReminders = await NotiService().getPendingNotifications();
    setState(() {
      reminders = pendingReminders;
    });
  }

  @override
  void initState() {
    getReminders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.adaptive.arrow_back, color: Colors.white),
        ),
        title: Text(
          'Reminders',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              reminders.isEmpty
                  ? Text('There aren\' any reminders!')
                  : Expanded(
                      child: ListView.builder(
                        itemCount: reminders.length,
                        itemBuilder: (context, index) {
                          final reminder = reminders[index];
                          DateTime? scheduledDate;
                          if (reminder.payload != null &&
                              reminder.payload!.isNotEmpty) {
                            scheduledDate = DateTime.tryParse(
                              reminder.payload!,
                            );
                          }

                          return ListTile(
                            title: Text('${reminder.body}'),
                            subtitle: reminder.payload.isNotEmpty
                                ? Text(
                                    '${scheduledDate!.day}/${scheduledDate.month}/${scheduledDate.year} ${scheduledDate.hour}:${scheduledDate.minute}',
                                  )
                                : Text('Unable to get the notification time!'),
                            leading: Icon(Icons.notifications),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                NotiService().cancelNotification(reminder.id);
                                final pendingReminders = reminders = await NotiService().getPendingNotifications();
                                setState(() {
                                  reminders = pendingReminders;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (context) => AddReminderDialog(),
          );
          final pendingReminders = await NotiService().getPendingNotifications();
          setState(()  {
            reminders = pendingReminders;
          });
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
