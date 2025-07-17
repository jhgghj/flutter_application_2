import 'package:flutter/material.dart';
import '../models/word_entry.dart';

class WordDetailScreen extends StatefulWidget {
  final WordEntry word;

  const WordDetailScreen({super.key, required this.word});

  @override
  State<WordDetailScreen> createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends State<WordDetailScreen> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final phrases = widget.word.phrases;
    final displayedPhrases = _expanded ? phrases : phrases.take(3).toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.word.word)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('释义：', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...widget.word.translations.map((t) => Text('${t.type}. ${t.translation}')),
            if (phrases.isNotEmpty) ...[
              SizedBox(height: 16),
              Text('短语：', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ...displayedPhrases.map((p) => Text('${p.phrase}：${p.translation}')),
              if (phrases.length > 3)
                TextButton(
                  onPressed: () => setState(() => _expanded = !_expanded),
                  child: Text(_expanded ? '收起' : '展开更多短语'),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
