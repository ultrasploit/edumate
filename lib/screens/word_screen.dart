import 'package:edumate/models/word_model.dart';
import 'package:edumate/providers/dictionary_provider.dart';
import 'package:edumate/screens/add_edit_word_sccreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WordScreen extends StatelessWidget {
  final int index;

  const WordScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<DictionaryProvider>(
      builder: (context, provider, _) {
        final Word word = provider.getWordAt(index);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlueAccent,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.adaptive.arrow_back, color: Colors.white),
            ),
            title: Text(
              word.word,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            actions: [
              IconButton(
                icon: Icon(Icons.edit_document, color: Colors.white),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddEditWordSccreen(existingWord: word),
                  ),
                ),
              ),
            ],
          ),

          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ListTile(
                    title: Text('Definition:', style: TextStyle(fontSize: 20, color: Colors.grey[600])),
                    subtitle: Text(
                      word.definition!.trim() != '' ? word.definition! : 'Null',
                      style: TextStyle(fontSize: 18, color: Colors.grey[900]),
                    ),
                  ),
                  ListTile(
                    title: Text('Example:', style: TextStyle(fontSize: 20, color: Colors.grey[600])),
                    subtitle: Text(
                      word.example!.trim() != '' ? word.example! : 'Null',
                      style: TextStyle(fontSize: 18, color: Colors.grey[900]),
                    ),
                  ),
                  ListTile(
                    title: Text('Synonyms:', style: TextStyle(fontSize: 20, color: Colors.grey[600])),
                    subtitle: Text(
                      word.synonyms != null ? word.synonyms!.join(', ') : 'Null',  
                      style: TextStyle(fontSize: 18, color: Colors.grey[900]),
                    ),
                  ),
                  ListTile(
                    title: Text('Antonyms:', style: TextStyle(fontSize: 20, color: Colors.grey[600])),
                    subtitle: Text(
                      word.antonyms != null ? word.antonyms!.join(', ') : 'Null',  
                      style: TextStyle(fontSize: 18, color: Colors.grey[900]),
                    ),
                  ),
                  ListTile(
                    title: Text('Part of Speech:', style: TextStyle(fontSize: 20, color: Colors.grey[600])),
                    subtitle: Text(
                      word.partOfSpeech!.trim() != '' ? word.partOfSpeech! : 'Null',  
                      style: TextStyle(fontSize: 18, color: Colors.grey[900]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
