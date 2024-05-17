import 'song_file_fetcher.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicPlayer {
  final AudioPlayer audioPlayer = AudioPlayer();
  final SongFileFetcher songFileFetcher = SongFileFetcher();
  bool _isPlaying = false;

  void dispose() {
    audioPlayer.dispose();
  }

  Future<void> stop() async {
    await audioPlayer.stop();
    _isPlaying = false;
  }

  Future<void> play() async {
    if (_isPlaying) {
      await stop();
    }
    _isPlaying = true;

    await songFileFetcher.getAllSoundFileNames();
    await _playSong();

    audioPlayer.onPlayerComplete.listen((event) => _playSong());
  }

  Future<void> _playSong() async {
    if (!_isPlaying) return;
    String song = songFileFetcher.getRandomSong();
    await audioPlayer.play(AssetSource(song));
  }
}
