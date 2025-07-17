import 'word_book.dart'; 

class Translation {
  final String type;
  final String translation;

  Translation({required this.type, required this.translation});

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      type: json['type'] ?? '',
      translation: json['translation'],
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'translation': translation,
      };
}

class Phrase {
  final String phrase;
  final String translation;

  Phrase({required this.phrase, required this.translation});

  factory Phrase.fromJson(Map<String, dynamic> json) {
    return Phrase(
      phrase: json['phrase'],
      translation: json['translation'],
    );
  }

  Map<String, dynamic> toJson() => {
        'phrase': phrase,
        'translation': translation,
      };
}

class WordEntry {
  final String word;
  final List<Translation> translations;
  final List<Phrase> phrases;

  WordEntry({required this.word, required this.translations, required this.phrases});

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

