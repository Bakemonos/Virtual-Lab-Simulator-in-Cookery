import 'package:audioplayers/audioplayers.dart';
import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:virtual_lab/controllers/controller.dart';
import 'package:virtual_lab/utils/bindings.dart';
import 'package:virtual_lab/utils/go_routes.dart';
import 'package:virtual_lab/utils/properties.dart';

late CloudinaryObject cloudinary;

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    if (kReleaseMode) {}
  };

  WidgetsFlutterBinding.ensureInitialized();

  await GeneralBindings().dependencies();

  await dotenv.load(fileName: '.env');

  cloudinary = CloudinaryObject.fromCloudName(cloudName: cloudName.toString());

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  @override
  void initState() {
    super.initState();
    final controller = Get.find<AppController>();
    Future.microtask(() async {
      await controller.loadSettingsIfNeeded(); 
      if (controller.musicToggle.value) {
        BackgroundMusic.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final myRoutes = ref.watch(myRoutesProvider);

    return ScreenUtilInit(
      designSize: const Size(800, 360),
      minTextAdapt: true,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Poppins',
            scaffoldBackgroundColor: backgroundColor,
          ),
          routerConfig: myRoutes,
        ),
      ),
    );
  }
}


class BackgroundMusic {
  static final AudioPlayer _bgPlayer = AudioPlayer(
    playerId: 'bgMusic',
  );

  static Future<void> play() async {
    final settings = Get.find<AppController>();
    if (!settings.musicToggle.value) return;

    await _bgPlayer.setAudioContext(AudioContext(
      android: const AudioContextAndroid(
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.media,
        audioFocus: AndroidAudioFocus.gain,
        stayAwake: true,
      ),
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.ambient, 
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
