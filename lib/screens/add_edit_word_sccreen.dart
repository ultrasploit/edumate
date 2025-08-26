import 'package:edumate/models/word_model.dart';
import 'package:edumate/providers/dictionary_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEditWordSccreen extends StatefulWidget {
  final Word? existingWord;

  const AddEditWordSccreen({super.key, this.existingWord});

  @override
  State<AddEditWordSccreen> createState() => _AddEditWordSccreenState();
}

class _AddEditWordSccreenState extends State<AddEditWordSccreen> {
  bool get isEditMode => widget.existingWord != null;

  final _formKey = GlobalKey<FormState>();

  final _wordController = TextEditingController();
  final _definitionController = TextEditingController();
  final _synonymsController = TextEditingController();
  final _antonymsController = TextEditingController();
  final _exampleController = TextEditingController();
  final _partOfSpeechController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (isEditMode) {
      final word = widget.existingWord!;
      _wordController.text = word.word;
      _definitionController.text = word.definition ?? '';
      _synonymsController.text = word.synonyms?.join(', ') ?? '';
      _antonymsController.text = word.antonyms?.join(', ') ?? '';
      _exampleController.text = word.example ?? '';
      _partOfSpeechController.text = word.partOfSpeech ?? '';
    }
  }

  @override
  void dispose() {
    _wordController.dispose();
    _definitionController.dispose();
    _synonymsController.dispose();
    _antonymsController.dispose();
    _exampleController.dispose();
    _partOfSpeechController.dispose();
    super.dispose();
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
          isEditMode ? 'Update Word' : 'Add a new word',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Word
                TextFormField(
                  controller: _wordController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    label: Text('Word'),
                  ),
                  
                  validator: (value) => value == null || value.trim().isEmpty ? 'Word is required!' : null,
                  
                ),
                // Definition
                TextFormField(
                  controller: _definitionController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    label: Text('Definition'),
                  ),
                ),
                // Synonyms (comma-separated)
                TextFormField(
                  controller: _synonymsController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    label: Text('Synonyms (comma-separated)'),
                  ),
                ),
                // Antonyms (comma-separated)
                TextFormField(
                  controller: _antonymsController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    label: Text('Antonyms (comma-separated)'),
                  ),
                ),
                // Example
                TextFormField(
                  controller: _exampleController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    label: Text('Example'),
                  ),
                ),
                // Part of Speech
                TextFormField(
                  controller: _partOfSpeechController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    label: Text('Part of Speech'),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _saveWord,
                  icon: Icon(isEditMode ? Icons.edit : Icons.save),
                  label: Text(isEditMode ? 'Update Word' : 'Save Word'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveWord() {
    if (_formKey.currentState!.validate()) {
      final updatedWord = Word(
        word: _wordController.text.trim(),
        definition: _definitionController.text.trim(),
        synonyms: _parseList(_synonymsController.text),
        antonyms: _parseList(_antonymsController.text),
        example: _exampleController.text.trim(),
        partOfSpeech: _partOfSpeechController.text.trim(),
        dateAdded: isEditMode ? widget.existingWord!.dateAdded : DateTime.now(),
      );

      final provider = Provider.of<DictionaryProvider>(context, listen: false);

      if (isEditMode) {
        final index = provider.words.indexOf(widget.existingWord!);
        provider.updateWordAt(index, updatedWord);
      } else {
        provider.addWord(updatedWord);
      }

      Navigator.pop(context);
    }
  }

  List<String>? _parseList(String input) {
    final list = input
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    return list.isEmpty ? null : list;
  }
}
