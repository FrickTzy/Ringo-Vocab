import 'package:asset_modules/asset_modules.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AppTheme theme = AppTheme();
  final KanjiManager kanjiManager = KanjiManager();
  final MusicPlayer musicPlayer = MusicPlayer();

  @override
  void initState() {
    super.initState();
    musicPlayer.play();
    kanjiManager.loadCsvData(setState);
  }

  @override
  void dispose() {
    super.dispose();
    musicPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeBar(theme: theme).build(context),
      body: KanjiWidgetManager(kanjiManager: kanjiManager),
    );
  }
}

class KanjiWidgetManager extends StatefulWidget {
  const KanjiWidgetManager({super.key, required this.kanjiManager});

  final KanjiManager kanjiManager;

  @override
  State<KanjiWidgetManager> createState() => _KanjiWidgetManagerState();
}

class _KanjiWidgetManagerState extends State<KanjiWidgetManager> {
  late final KanjiInfoWidgetManager kanjiInfoWidgetManager;
  final KanjiMainInfoManager kanjiMainInfoManager = KanjiMainInfoManager();

  @override
  void initState() {
    super.initState();
    kanjiInfoWidgetManager =
        KanjiInfoWidgetManager(kanjiMainInfoManager: kanjiMainInfoManager);
  }

  @override
  Widget build(BuildContext contextBody) {
    return ListView.builder(
        itemCount: widget.kanjiManager.kanjiInfo.length,
        itemBuilder: (context, index) {
          KanjiInfo currentKanjiInfo = widget.kanjiManager.kanjiInfo[index];
          return kanjiInfoWidgetManager.show(context, currentKanjiInfo);
        });
  }
}

class KanjiMainInfoManager {
  static const String _endingCharacter = "(";
  static const int _maxLenPerLine = 14;
  static const int _sizeMinus = 5;
  static const double _maxMeaningSize = 52;
  final KanjiMainInfoWidget _kanjiMainInfoWidget = KanjiMainInfoWidget();
  late double _currentSize;
  double _meaningPadding = 55;

  List<List<String>> _adjustSentence(String sentence) {
    _currentSize = _maxMeaningSize;
    List<List<String>> meaningLineList = [];
    String newSentence = _extractTrimmedSentence(sentence);
    if (newSentence.length < _maxLenPerLine) {
      meaningLineList.add([newSentence]);
    } else {
      for (String string in newSentence.split(RegExp(r'[,;]'))) {
        if (string.length < _maxLenPerLine) {
          meaningLineList.add([string]);
          _decreaseSize(_sizeMinus);
          continue;
        }
        List<String> currentLineList = _splitIntoLines(string);
        _decreaseSize(_sizeMinus * currentLineList.length);
        meaningLineList.add(currentLineList);
      }
    }
    return meaningLineList;
  }

  String _extractTrimmedSentence(String sentence) {
    if (sentence.contains(_endingCharacter)) {
      return sentence.substring(0, sentence.indexOf(_endingCharacter)).trim();
    } else {
      return sentence;
    }
  }

  List<String> _splitIntoLines(String sentence) {
    List<String> wordList = sentence.split(" ");
    List<String> currentLineList = [];
    int currentIndex = 1;
    String currentLine = "";
    for (String word in wordList) {
      if (word == "") {
        continue;
      }
      currentLine += word;
      if (currentIndex != 1) {
        if (currentIndex % 2 == 0) {
          currentLineList.add(currentLine);
          currentLine = "";
        } else if (currentIndex == wordList.length) {
          currentLineList.add(currentLine);
        }
      }
      currentLine += " ";
      currentIndex += 1;
    }
    return currentLineList;
  }

  void _decreaseSize(int decrement) {
    _currentSize -= decrement;
  }

  List<Widget> _getAllMeaningWidgets(KanjiInfo currentKanjiInfo) {
    _meaningPadding = 55;
    List<Widget> meaningLineList = [];

    List<List<String>> adjustedSentences =
        _adjustSentence(currentKanjiInfo.meaning);

    for (List<String> sentence in adjustedSentences) {
      int currentIndex = 0;
      for (String line in sentence) {
        String currentLineText = line;
        if (currentIndex == sentence.length - 1) {
          currentLineText += ";";
        }
        meaningLineList.add(Center(
            child: Text(currentLineText,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: _currentSize,
                    fontStyle: FontStyle.italic))));
        currentIndex += 1;
        _meaningPadding -= 12;
      }
    }
    if (_meaningPadding < 0) {
      _meaningPadding = 0;
    }
    return meaningLineList;
  }

  void show(BuildContext context, KanjiInfo currentKanjiInfo) {
    List<Widget> meaningWidgetList = _getAllMeaningWidgets(currentKanjiInfo);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return _kanjiMainInfoWidget.show(
              context, currentKanjiInfo, meaningWidgetList, _meaningPadding);
        });
  }
}

class KanjiMainInfoWidget {
  static const bool showRomanLetters = true;
  static const double mainInfoHeightRatio = 1.566;
  static const double mainInfoWidthRatio = 1.05;

  Size _getWindowSize(context) {
    return MediaQuery.of(context).size;
  }

  Widget show(BuildContext context, KanjiInfo currentKanjiInfo,
      List<Widget> meaningWidgetList, meaningPadding) {
    Size size = _getWindowSize(context);
    double height = size.height / mainInfoHeightRatio;
    double width = size.width / mainInfoWidthRatio;
    String reading = currentKanjiInfo.reading;
    if (showRomanLetters) {
      reading += " / ${currentKanjiInfo.romajiReading}";
    }

    return SizedBox(
        height: height,
        width: width,
        child: Column(children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(
                  bottom: 15, right: 25, left: 25, top: 25),
              child: Column(
                children: <Widget>[
                  Column(children: <Widget>[
                    Center(
                        child: Text(currentKanjiInfo.kanji,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 50))),
                    Center(
                        child:
                            Text(reading, style: const TextStyle(fontSize: 20)))
                  ])
                ],
              )),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.all(meaningPadding),
                  child: Column(children: meaningWidgetList))),
          Padding(
              padding: const EdgeInsets.only(bottom: 30, right: 10, left: 10),
              child: Column(children: <Widget>[
                Text(currentKanjiInfo.example,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                Text(currentKanjiInfo.exampleMeaning,
                    style: const TextStyle(fontSize: 18))
              ]))
        ]));
  }
}

class KanjiInfoWidgetManager {
  final KanjiMainInfoManager kanjiMainInfoManager;

  KanjiInfoWidgetManager({required this.kanjiMainInfoManager});

  Widget show(BuildContext context, KanjiInfo currentKanjiInfo) {
    return Card(
        child: Row(children: <Widget>[
      Expanded(
          child: ListTile(
              title: Text(currentKanjiInfo.kanji),
              subtitle: Text(currentKanjiInfo.meaning),
              onTap: () =>
                  kanjiMainInfoManager.show(context, currentKanjiInfo))),
      Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: Text(currentKanjiInfo.index.toString()))
    ]));
  }
}
