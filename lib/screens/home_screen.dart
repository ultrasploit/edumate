import 'package:edumate/models/homework_model.dart';
import 'package:edumate/models/word_model.dart';
import 'package:edumate/providers/dictionary_provider.dart';
import 'package:edumate/providers/homework_provider.dart';
import 'package:edumate/providers/reminder_provider.dart';
import 'package:edumate/screens/homework_screen.dart';
import 'package:edumate/screens/my_dictionary_screen.dart';
import 'package:edumate/screens/reminders_screen.dart';
import 'package:edumate/screens/settings_screen.dart';
import 'package:edumate/services/auth_service.dart';
import 'package:edumate/widgets/custom_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void checkNoti() async {
    bool hasPerms = await NotiService().hasPermissions();
    if (!hasPerms) {
      hasPerms = await NotiService().requestPermissions();
    }
  }

  @override
  void initState() {
    super.initState();
    checkNoti();
  }

  @override
  Widget build(BuildContext context) {
    final student = authService.value.currentUser!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text('EduMate', style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              });
            },
            icon: Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),

      body: SafeArea(
        child: Consumer2<HomeworkProvider, DictionaryProvider>(
          builder: (context, homeworkProvider, dictionaryProvider, _) {
            final List<Homework> inCompletehomework =
                homeworkProvider.incompleteHomeworkSortedByDueDate;

            final List<Word> wordLearntToday =
                dictionaryProvider.wordsAddedToday;

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Day, ${student.displayName}',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),

                  SizedBox(height: 20),

                  Flexible(
                    fit: FlexFit.loose,
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: [
                        CustomCardWidget(
                          title: 'Homework',
                          subtitle:
                              homeworkProvider.incompleteHomework.isNotEmpty
                              ? '${homeworkProvider.incompleteHomework.length} homework to complete!'
                              : 'There aren\'t any homework to do!',
                          icon: Icons.task,
                          color: Colors.lightBlueAccent,
                          callback: _toHomeworkScreen,
                          context: context,
                        ),
                        CustomCardWidget(
                          title: 'Reminders',
                          subtitle: '',
                          icon: Icons.notifications,
                          color: Colors.deepPurple,
                          callback: _toRemindersScreen,
                          context: context,
                        ),
                        CustomCardWidget(
                          title: 'My Dictionary',
                          subtitle: dictionaryProvider.words.isNotEmpty
                              ? '${dictionaryProvider.words.length} word(s)'
                              : 'Your dictionary is empty!',
                          icon: Icons.book,
                          color: Colors.orangeAccent,
                          callback: _toMyDictionaryScreen,
                          context: context,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  if (inCompletehomework.isNotEmpty)
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeworkScreen(),
                          ),
                        );
                      },
                      title: Text(
                        'Hurry up! Do the ${inCompletehomework[0].subject} homework!',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        '${homeworkProvider.getDaysLeft(inCompletehomework[0])} day(s) left',
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Icon(Icons.book, color: Colors.white, size: 35),
                      tileColor: Colors.red,
                    ),

                  if (wordLearntToday.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: ListTile(
                        title: Text(
                          'Great! You\'ve learnt ${wordLearntToday.length == 1 ? 'a new word' : '${wordLearntToday.length} words'} today!',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        tileColor: Colors.green,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _toHomeworkScreen(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeworkScreen()),
    );
  }

  _toRemindersScreen(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RemindersScreen()),
    );
  }

  _toMyDictionaryScreen(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyDictionaryScreen()),
    );
  }
}
