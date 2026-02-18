import 'package:just_audio/just_audio.dart';

class AudioService {
  static AudioService? _instance;
  late AudioPlayer _player;

  AudioService._() {
    _player = AudioPlayer();
  }

  static AudioService get instance {
    _instance ??= AudioService._();
    return _instance!;
  }

  Future<void> playUrl(String url) async {
    await _player.setUrl(url);
    await _player.play();
  }

  Future<void> playAsset(String assetPath) async {
    await _player.setAsset(assetPath);
    await _player.play();
  }

  Future<void> playLocalFile(String filePath) async {
    await _player.setFilePath(filePath);
    await _player.play();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
  }

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
  }

  Stream<Duration> get positionStream => _player.positionStream;

  Stream<Duration?> get durationStream => _player.durationStream;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Stream<bool> get playingStream => _player.playingStream;

  Duration? get duration => _player.duration;

  Duration get position => _player.position;

  bool get isPlaying => _player.playing;

  Future<void> dispose() async {
    await _player.dispose();
  }
}
