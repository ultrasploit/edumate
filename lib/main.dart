import 'package:edumate/firebase_options.dart';
import 'package:edumate/models/homework_model.dart';
import 'package:edumate/models/word_model.dart';
import 'package:edumate/providers/dictionary_provider.dart';
import 'package:edumate/providers/homework_provider.dart';
import 'package:edumate/providers/reminder_provider.dart';
import 'package:edumate/services/auth_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications
  NotiService().initNotification();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize providers
  final homeworkProvider = HomeworkProvider();
  final dictionaryProvider = DictionaryProvider();

  Hive.registerAdapter(HomeworkAdapter());
  Hive.registerAdapter(WordAdapter());
  
  await homeworkProvider.init();
  await dictionaryProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: homeworkProvider),
        ChangeNotifierProvider.value(value: dictionaryProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
      ),
      home: AuthLayout(),
    );
  }
}