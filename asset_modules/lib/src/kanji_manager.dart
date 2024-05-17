import 'kanji_info.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:kana_kit/kana_kit.dart';

class KanjiManager {
  static const String csvPath = 'assets/n5.csv';
  static const kanaKit = KanaKit();
  static const csvListConverter = CsvToListConverter();
  List<KanjiInfo> kanjiInfo = [];

  Future<void> loadCsvData(Function setState) async {
    bool csvHeaderPassed = false;
    int currentIndex = 1;
    kanjiInfo.clear();
    final String rawCsv = await rootBundle.loadString(csvPath);
    List<List<dynamic>> csvTable = csvListConverter.convert(rawCsv);
    for (List list in csvTable) {
      if (!csvHeaderPassed) {
        csvHeaderPassed = true;
        continue;
      }
      kanjiInfo.add(KanjiInfo(
          kanji: list[0],
          reading: list[1],
          meaning: list[2],
          example: list[3],
          exampleMeaning: list[4],
          romajiReading: kanaKit.toRomaji(list[1]),
          index: currentIndex));
      currentIndex += 1;
    }
    setState(() {});
  }
}
