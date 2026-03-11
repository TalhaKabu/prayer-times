class SurahModel {
  final int id;
  final String name;
  final String transliteration;
  final String translation;
  final String type;
  final int totalVerses;
  final List<VerseModel> verses;

  SurahModel({
    required this.id,
    required this.name,
    required this.transliteration,
    required this.translation,
    required this.type,
    required this.totalVerses,
    required this.verses,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      id: json['id'],
      name: json['name'],
      transliteration: json['transliteration'],
      translation: json['translation'],
      type: json['type'],
      totalVerses: json['total_verses'],
      verses: (json['verses'] as List)
          .map((v) => VerseModel.fromJson(v))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'transliteration': transliteration,
      'translation': translation,
      'type': type,
      'total_verses': totalVerses,
      'verses': verses.map((v) => v.toJson()).toList(),
    };
  }
}

class VerseModel {
  final int id;
  final String text;
  final String translation;

  VerseModel({required this.id, required this.text, required this.translation});

  factory VerseModel.fromJson(Map<String, dynamic> json) {
    return VerseModel(
      id: json['id'],
      text: json['text'],
      translation: json['translation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text, 'translation': translation};
  }
}
