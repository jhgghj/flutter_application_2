
import 'word_entry.dart';
/* class WordEntry {
  final String word;
  final List<Translation> translations;
  final List<Phrase> phrases;

  WordEntry({
    required this.word,
    required this.translations,
    required this.phrases,
  });

  factory WordEntry.fromJson(Map<String, dynamic> json) {
    return WordEntry(
      word: json['word'],
      translations: (json['translations'] as List)
          .map((e) => Translation.fromJson(e))
          .toList(),
      phrases: (json['phrases'] as List)
          .map((e) => Phrase.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'word': word,
        'translations': translations.map((t) => t.toJson()).toList(),
        'phrases': phrases.map((p) => p.toJson()).toList(),
      };
}
 */
class WordBook {
  final String name;
  final List<WordEntry> words;

  WordBook({required this.name, required this.words});

  factory WordBook.fromJson(Map<String, dynamic> json) {
    return WordBook(
      name: json['name'],
      words: (json['words'] as List)
          .map((e) => WordEntry.fromJson(e))
          .toList(),
    );
  }
}
