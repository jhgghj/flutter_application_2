import 'package:flutter/material.dart';
import '../services/word_book_manager.dart';
import '../models/word_entry.dart'; // 假设你有一个 WordEntry 类

class WordSearchScreen extends StatefulWidget {
  const WordSearchScreen({super.key});

  @override
  _WordSearchScreenState createState() => _WordSearchScreenState();
}

class _WordSearchScreenState extends State<WordSearchScreen> {
  TextEditingController _controller = TextEditingController();
  List<WordEntry> _searchResults = [];

  void _searchWords() {
    setState(() {
      _searchResults = WordBookManager.searchWord(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('查找单词')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 输入框
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: '请输入单词',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _searchWords(),
            ),
            const SizedBox(height: 16),
            // 显示搜索结果
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final word = _searchResults[index];
                  return ListTile(
                    title: Text(word.word),
                    subtitle: Text(word.translations.join(', ')),
                    onTap: () {
                      // 点击单词时可以跳转到详细页面
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
