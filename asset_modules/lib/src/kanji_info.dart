class KanjiInfo {
  final String reading;
  final String kanji;
  final String meaning;
  final String example;
  final String exampleMeaning;
  final String romajiReading;
  final int index;

  KanjiInfo(
      {required this.kanji,
      required this.reading,
      required this.meaning,
      required this.example,
      required this.exampleMeaning,
      required this.romajiReading,
      required this.index});
}
