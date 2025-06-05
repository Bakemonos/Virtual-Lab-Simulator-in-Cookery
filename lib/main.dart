import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:virtual_lab/Utils/bindings.dart';
import 'package:virtual_lab/Utils/go_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GeneralBindings().dependencies();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(800, 360),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Virtual Lab',
          theme: ThemeData(
            fontFamily: 'Poppins',
            scaffoldBackgroundColor: Colors.white,
            // colorScheme: ColorScheme.fromSwatch().copyWith(
            //   primary: Colors.blue,
            //   secondary: Colors.deepPurple,
            // ),
          ),
          initialRoute: '/',
          getPages: appRoutes,
        ),
      ),
    );
  }
}
