import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';

class BgmService with WidgetsBindingObserver {
  BgmService._();
  static final BgmService instance = BgmService._();

  final AudioPlayer _player = AudioPlayer();
  bool _started = false;
  bool _muted = false;

  bool get isMuted => _muted;

  Future<void> initAndPlay({
    String assetPath = 'audio/theme.mp3',
    double volume = 0.5,
  }) async {
    if (_started) return;
    _started = true;
    WidgetsBinding.instance.addObserver(this);

    // Cho chắc: audio context phù hợp phát nhạc media
    await _player.setAudioContext(const AudioContext(
      android: AudioContextAndroid(
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.media,
        audioFocus: AndroidAudioFocus.gain,
        stayAwake: false,
        isSpeakerphoneOn: false,
      ),
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.ambient, // không chặn âm khác
        options: [AVAudioSessionOptions.mixWithOthers],
      ),
    ));

    await _player.setReleaseMode(ReleaseMode.loop); // lặp vô hạn
    await _player.setVolume(volume);

    // Cách gọi chắc ăn nhất:
    await _player.play(AssetSource(assetPath)); // tự play luôn
  }

  Future<void> toggleMute() async {
    _muted = !_muted;
    await _player.setVolume(_muted ? 0.0 : 0.5);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Tạm dừng khi background cho đỡ tốn pin (tuỳ bạn)
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _player.pause();
    } else if (state == AppLifecycleState.resumed) {
      if (!_muted) _player.resume();
    }
  }

  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    await _player.stop();
    await _player.dispose();
  }
}
