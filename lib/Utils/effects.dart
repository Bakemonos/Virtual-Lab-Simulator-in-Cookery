import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:virtual_lab/controllers/controller.dart';
import 'package:virtual_lab/utils/properties.dart';


class BackgroundMusic {
  static final AudioPlayer _bgPlayer = AudioPlayer(playerId: 'bgMusic');

  static Future<void> play() async {
    final settings = Get.find<AppController>();
    if (!settings.musicToggle.value) return;

    await _bgPlayer.setAudioContext(AudioContext(
      android: const AudioContextAndroid(
        contentType: AndroidContentType.sonification,
        usageType: AndroidUsageType.game,
        audioFocus: AndroidAudioFocus.gainTransient,
        stayAwake: false,
      ),
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.soloAmbient,
      ),
    ));

    await _bgPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgPlayer.play(AssetSource(background));
  }

  static Future<void> stop() async {
    await _bgPlayer.stop();
  }
}


class SoundEffects {
  static Future<void> playEffect() async {
    final settings = Get.find<AppController>();
    if (!settings.soundToggle.value) return;

    final fxPlayer = AudioPlayer(
      playerId: 'fx_${DateTime.now().millisecondsSinceEpoch}',
    );

    await fxPlayer.setAudioContext(AudioContext(
      android: const AudioContextAndroid(
        contentType: AndroidContentType.sonification,
        usageType: AndroidUsageType.assistanceSonification,
        audioFocus: AndroidAudioFocus.none,
      ),
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.ambient,
      ),
    ));

    await fxPlayer.play(AssetSource(clickEffect1));
  }
}
