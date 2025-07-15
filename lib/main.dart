import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:virtual_lab/Utils/bindings.dart';
import 'package:virtual_lab/Utils/go_routes.dart';
import 'package:virtual_lab/Utils/properties.dart';

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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
