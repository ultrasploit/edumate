import 'package:edumate/components/add_homework_dialog.dart';
import 'package:edumate/models/homework_model.dart';
import 'package:edumate/providers/homework_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeworkScreen extends StatefulWidget {
  const HomeworkScreen({super.key});

  @override
  State<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
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
          'Homework',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Consumer<HomeworkProvider>(
        builder: (context, provider, _) {

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Pending homework (${provider.incompleteHomework.length})',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                provider.incompleteHomework.isEmpty
                    ? SizedBox(height: 50, child: Text('There aren\'t any homework to do.'))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: provider.incompleteHomework.length,
                          itemBuilder: (context, index) {
                            final List<Homework> sortedHomework =
                                provider.incompleteHomeworkSortedByDueDate;
                            final Homework homework = sortedHomework[index];
                            final DateTime dueDate = homework.dueDate;
                            return ListTile(
                              onTap: () {},
                              title: Text(
                                '${homework.title} (${homework.subject})',
                              ),
                              subtitle: Text(
                                '${dueDate.day}/${dueDate.month}/${dueDate.year} ${dueDate.hour}:${dueDate.minute.toString().padLeft(2, '0')}',
                              ),
                              leading: Icon(Icons.book),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () => provider
                                        .markHomeworkCompleted(homework),
                                    icon: Icon(Icons.check),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        provider.deleteHomeworkAt(index),
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                Text(
                  'Completed homework (${provider.completedHomework.length})',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: provider.completedHomework.isEmpty
                      ? Text('There\'s nothing to display.')
                      : ListView.builder(
                          itemCount: provider.completedHomework.length,
                          itemBuilder: (context, index) {
                            final Homework homework =
                                provider.completedHomework[index];
                            return ListTile(
                              onTap: () {},
                              title: Text(homework.title),
                              subtitle: Text(homework.subject),
                              leading: Icon(Icons.book),
                              trailing: IconButton(
                                onPressed: () =>
                                    provider.markHomeworkIncomplete(homework),
                                icon: Icon(Icons.clear),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddHomeworkDialog(),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
