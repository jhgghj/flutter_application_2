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
