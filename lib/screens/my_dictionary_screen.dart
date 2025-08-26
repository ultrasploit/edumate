import 'package:edumate/providers/dictionary_provider.dart';
import 'package:edumate/screens/add_edit_word_sccreen.dart';
import 'package:edumate/screens/word_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDictionaryScreen extends StatelessWidget {
  const MyDictionaryScreen({super.key});

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
          'MyDictionary',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Consumer<DictionaryProvider>(
            builder: (context, provider, _) {
              return Column(
                children: [
                  provider.words.isEmpty
                      ? Flexible(child: Center(child: Text('Add your first word!')))
                      : Expanded(
                          child: ListView.builder(
                            itemCount: provider.words.length,
                            itemBuilder: (context, index) {
                              final word = provider.words[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6.0,
                                ),
                                child: ListTile(
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WordScreen(index: index,))),
                                  tileColor: Colors.grey[600],
                                  title: Text(
                                    word.word,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () => provider.deleteWordAt(index),
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ],
              );
            },
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddEditWordSccreen()),
        ),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
