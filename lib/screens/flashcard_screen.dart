/* // lib/screens/flashcard_screen.dart
import 'package:flutter/material.dart';
import 'package:word_flash/services/word_book_manager.dart';
import 'package:word_flash/models/word_review.dart';

class FlashcardStudyScreen extends StatefulWidget {
  final int planCount;

  const FlashcardStudyScreen({super.key, required this.planCount});

  @override
  _FlashcardStudyScreenState createState() => _FlashcardStudyScreenState();
}

class _FlashcardStudyScreenState extends State<FlashcardStudyScreen> {
  int _currentIndex = 0;
  bool _showDetails = false;
  List<WordReview> _wordReviews = [];

  @override
  void initState() {
    super.initState();
    _initializeReviewList();
  }

  // 初始化复习单词列表
  void _initializeReviewList() {
    final book = WordBookManager.selectedBook;
    if (book != null && book.words.isNotEmpty) {
      _wordReviews = book.words
          .take(widget.planCount)
          .map((word) => WordReview(word: word.word))
          .toList();
    }
  }

  void _nextWord(int quality) {
    setState(() {
      _wordReviews[_currentIndex].update(quality);  // 更新单词的复习信息
      _currentIndex++;
      if (_currentIndex >= _wordReviews.length) {
        _currentIndex = 0;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已完成当前复习任务，重新开始！')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_wordReviews.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('背单词')),
        body: Center(child: Text('没有单词可以复习')),
      );
    }

    final currentWord = _wordReviews[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text('背单词')),
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showDetails = !_showDetails;
          });
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(currentWord.word, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              if (_showDetails) ...[
                SizedBox(height: 20),
                Text('复习次数：${currentWord.reviewCount}', style: TextStyle(fontSize: 18)),
                Text('易度因子：${currentWord.easeFactor.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _nextWord(5);  // 假设用户表示记住了
                },
                child: Text('记住'),
              ),
              ElevatedButton(
                onPressed: () {
                  _nextWord(1);  // 假设用户表示忘记了
                },
                child: Text('忘记'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 */

import 'package:flutter/material.dart';
import '../services/word_book_manager.dart';

class FlashcardStudyScreen extends StatefulWidget {
  final int planCount;

  const FlashcardStudyScreen({super.key, required this.planCount});

  @override
  _FlashcardStudyScreenState createState() => _FlashcardStudyScreenState();
}

class _FlashcardStudyScreenState extends State<FlashcardStudyScreen> {
  int _currentIndex = 0;
  bool _showDetails = false;

  void _nextBatch() {
    setState(() {
      _currentIndex += 4;
      if (_currentIndex >= widget.planCount) {
        _currentIndex = 0;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已到达计划背诵量，重新开始')),
        );
      }
      _showDetails = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final book = WordBookManager.selectedBook;

    if (book == null || book.words.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('背单词')),
        body: Center(child: Text('请先选择词库')),
      );
    }

    final planWords = book.words.take(widget.planCount).toList();
    final words = planWords.skip(_currentIndex).take(4).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('背单词 - ${book.name}'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text('${_currentIndex + 1}-${_currentIndex + words.length}/${widget.planCount}')),
          )
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            if (_showDetails) {
              _nextBatch();
            } else {
              _showDetails = true;
            }
          });
        },
        child: GridView.builder(
          padding: EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.5,
          ),
          itemCount: words.length,
          itemBuilder: (context, index) {
            final word = words[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        word.word,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      if (_showDetails) ...[
                        SizedBox(height: 12),
                        ...word.translations.map(
                          (t) => Text(
                            '${t.type.isNotEmpty ? "${t.type}. " : ""}${t.translation}',
                            style: TextStyle(fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        if (word.phrases.isNotEmpty) ...[
                          SizedBox(height: 8),
                          Text('短语：', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ...word.phrases.map(
                            (p) => Text('${p.phrase}：${p.translation}', style: TextStyle(fontSize: 12)),
                          ),
                        ]
                      ]
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
