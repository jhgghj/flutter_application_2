import 'package:flutter/material.dart';
import '../services/word_book_manager.dart';
import '../models/word_book.dart';

class SelectWordScreen extends StatefulWidget {
  final WordBook book;

  const SelectWordScreen({super.key, required this.book});

  @override
  State<SelectWordScreen> createState() => _SelectWordScreenState();
}

class _SelectWordScreenState extends State<SelectWordScreen> {
  final Set<int> _selectedIndexes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("选择单词 - ${widget.book.name}"),
        actions: [
          TextButton(
            onPressed: () async {
              final selectedWords = _selectedIndexes.map((i) => widget.book.words[i]).toList();
              await WordBookManager.addWordsToMyWordBook(selectedWords);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('已添加所选单词到“我的词库”')),
              );
              Navigator.pop(context);
            },
            child: Text("添加", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.book.words.length,
        itemBuilder: (context, index) {
          final word = widget.book.words[index];
          final isSelected = _selectedIndexes.contains(index);
          return ListTile(
            leading: Checkbox(
              value: isSelected,
              onChanged: (checked) {
                setState(() {
                  if (checked == true) {
                    _selectedIndexes.add(index);
                  } else {
                    _selectedIndexes.remove(index);
                  }
                });
              },
            ),
            title: Text(word.word, style: TextStyle(fontSize: 18)),
          );
        },
      ),
    );
  }
}
