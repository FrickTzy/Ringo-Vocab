import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class SongFileFetcher {
  static const folderPath = "assets/sounds/";
  static const folderRootPath = "assets/";
  final List<String> fileNames = [];
  final Random random = Random();

  String removePrefix(String input) {
    if (input.startsWith(folderRootPath)) {
      return input.substring(folderRootPath.length);
    } else {
      return input;
    }
  }

  String getRandomSong() {
    int randomIndex = random.nextInt(fileNames.length);
    return removePrefix(fileNames[randomIndex]);
  }

  Future<Type> getAllSoundFileNames() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    manifestMap.keys
        .where((String key) => key.startsWith(folderPath))
        .toList()
        .forEach((element) {
      fileNames.add(element);
    });
    return Null;
  }
}
