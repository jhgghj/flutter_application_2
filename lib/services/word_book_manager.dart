import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/word_entry.dart'; // 确保引用正确的文件
import '../models/word_book.dart'; 
class WordBookManager {
  static WordBook? selectedBook;
  static final List<WordBook> wordBooks = [];
  static final WordBook myWordBook = WordBook(name: '我的词库', words: []);

  static Future<void> loadWordBooks() async {
    final jsonString = await rootBundle.loadString(
        'assets/words/english-vocabulary-master/json/converted-5-考研-顺序.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    final loadedBook = WordBook.fromJson(jsonData);

    await loadMyWordBook();

    // 先加入“我的词库”到最前面
    wordBooks.add(myWordBook);
    // 再加入其他词库
    wordBooks.add(loadedBook);
  }

  static Future<void> saveMyWordBook() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonWords = myWordBook.words.map((e) => e.toJson()).toList();
    await prefs.setString('myWordBook', json.encode(jsonWords));
  }

  static Future<void> loadMyWordBook() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('myWordBook');
    if (saved != null) {
      final List<dynamic> decoded = json.decode(saved);
      myWordBook.words.clear();
      myWordBook.words
          .addAll(decoded.map((e) => WordEntry.fromJson(e)).toList());
    }
  }

  static Future<void> addWordToMyWordBook(WordEntry word) async {
    if (!myWordBook.words.any((w) => w.word == word.word)) {
      myWordBook.words.add(word);
      await saveMyWordBook();
    }
  }

  static Future<void> addWordsToMyWordBook(List<WordEntry> words) async {
    for (final word in words) {
      if (!myWordBook.words.any((w) => w.word == word.word)) {
        myWordBook.words.add(word);
      }
    }
    await saveMyWordBook();
  }

  // 查找单词方法
  static List<WordEntry> searchWord(String query) {
    final allWords = [
      ...myWordBook.words,
      if (selectedBook != null) ...selectedBook!.words
    ];

    return allWords.where((word) {
      return word.word.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
