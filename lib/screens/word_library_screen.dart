import 'package:flutter/material.dart';
import '../services/word_book_manager.dart';
import 'select_word_screen.dart';

class WordLibraryScreen extends StatefulWidget {
  const WordLibraryScreen({super.key});

  @override
  State<WordLibraryScreen> createState() => _WordLibraryScreenState();
}

class _WordLibraryScreenState extends State<WordLibraryScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    if (WordBookManager.wordBooks.isEmpty) {
      await WordBookManager.loadWordBooks();
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: WordBookManager.wordBooks.length,
      itemBuilder: (context, index) {
        final book = WordBookManager.wordBooks[index];
        final isMyWordBook = book.name == '我的词库';

        return ListTile(
          leading: isMyWordBook
              ? Icon(Icons.star, color: Colors.orange) // High-light "My Word Book"
              : Icon(Icons.book),
          title: Text(
            book.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isMyWordBook ? FontWeight.bold : FontWeight.normal,
              color: isMyWordBook ? Colors.orange : null,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                child: Text("选择单词"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectWordScreen(book: book),
                    ),
                  );
                },
              ),
              TextButton(
                child: Text("选择整本"),
                onPressed: () async {
                  await WordBookManager.addWordsToMyWordBook(book.words);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('已添加整本词库到“我的词库”')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
