import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:virtual_lab/Pages/login.dart';
import 'package:virtual_lab/Pages/signup.dart';

final appRoutes = [
  GetPage(name: '/', page: () => MyLoginPage()),
  GetPage(name: '/details', page: () => MySignUpPage()),
];
