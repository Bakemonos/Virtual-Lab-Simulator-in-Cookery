import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/components/custom_img_picture.dart';
import 'package:virtual_lab/components/custom_text.dart';
import 'package:virtual_lab/controllers/controller.dart';
import 'package:virtual_lab/utils/bindings.dart';
import 'package:virtual_lab/utils/effects.dart';
import 'package:virtual_lab/utils/go_routes.dart';
import 'package:virtual_lab/utils/properties.dart';

late CloudinaryObject cloudinary;

class LoadingProgress extends ChangeNotifier {
  double value = 0;
  String message = '';

  void update(double newValue, String newMessage) {
    value = newValue;
    message = newMessage;
    notifyListeners();
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myRoutes = ref.watch(myRoutesProvider);

    return ScreenUtilInit(
      designSize: const Size(800, 360),
      minTextAdapt: true,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: backgroundColor,
        ),
        routerConfig: myRoutes,
      ),
    );
  }
}

class SplashWrapper extends ConsumerStatefulWidget {
  const SplashWrapper({super.key});

  @override
  ConsumerState<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends ConsumerState<SplashWrapper> {
  final loader = LoadingProgress();

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      if (kReleaseMode) {
        // TODO: Send error to analytics
      }
    };

    loader.update(0.1, 'Initializing dependencies...');
    await GeneralBindings().dependencies();
    await Future.delayed(const Duration(milliseconds: 300));

    loader.update(0.3, 'Loading environment...');
    await dotenv.load(fileName: '.env');
    await Future.delayed(const Duration(milliseconds: 300));

    loader.update(0.5, 'Configuring cloud storage...');
    cloudinary = CloudinaryObject.fromCloudName(cloudName: cloudName.toString());
    await Future.delayed(const Duration(milliseconds: 300));

    loader.update(0.7, 'Configuring screen...');
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    await Future.delayed(const Duration(milliseconds: 300));

    loader.update(0.9, 'Loading assets...');
    await Future.delayed(const Duration(milliseconds: 300));

    loader.update(1.0, 'Done!');
    await Future.delayed(const Duration(milliseconds: 200));

    final controller = Get.find<AppController>();
    await controller.loadSettingsIfNeeded();
    if (controller.musicToggle.value) {
      BackgroundMusic.play();
    }

    if (mounted) {
      context.go('/'); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: loader,
      builder: (context, _) => SplashScreen(
        progress: loader.value,
        message: loader.message,
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  final double progress;
  final String message;

  const SplashScreen({
    super.key,
    required this.progress,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SizedBox(
          width: 500.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 24.w,
                children: [
                  SizedBox(
                    width: 80.w,
                    child: MyImgPicture(path: logo),
                  ),
                  MyText(text: 'Virtual Lab Simulator \nin Cookery', size: 24.sp, fontWeight: FontWeight.w700)
                ],
              ),
              SizedBox(height: 40.h),
              Container(
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: greenDark,
                  borderRadius: BorderRadius.circular(30.r)
                ),
                child: LinearProgressIndicator(
                  value: progress, 
                  color: greenLighter, 
                  backgroundColor: backgroundColor, 
                  minHeight: 18.h,
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
              SizedBox(height: 10.h),
              MyText(text: message, size: 16.sp),
              SizedBox(height: 16.h),
              MyText(text: 'Where Every Mistake Becomes a Masterpiece', size: 16.sp, fontWeight: FontWeight.w700),  
              MyText(text: 'Welcome to the Kitchen of Learning', size: 14.sp, fontWeight: FontWeight.w600)
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
    return Scaffold(
      body: Center(child: Text("Main Home Page")),
    );
  }
}
