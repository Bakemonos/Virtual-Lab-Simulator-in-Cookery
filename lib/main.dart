import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:virtual_lab/Utils/properties.dart';
import 'package:virtual_lab/Utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) {
    runApp(const ProviderScope(child: MyApp()));
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myRoutes = ref.watch(myRoutesProvider);

    return ScreenUtilInit(
      designSize: const Size(360, 800),
      child: SafeArea(
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Poppins',
            // primaryColor: primaryColor,
            scaffoldBackgroundColor: backgroundColor,
            // colorScheme: const ColorScheme.light().copyWith(
            //   primary: textLight,
            //   secondary: textSub,
            //   tertiary: textColor,
            // ),
          ),
          routerConfig: myRoutes,
        ),
      ),
    );
  }
}
