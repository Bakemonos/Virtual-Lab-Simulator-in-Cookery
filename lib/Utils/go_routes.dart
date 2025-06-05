import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import 'package:virtual_lab/Pages/food_choices.dart';
import 'package:virtual_lab/Pages/login.dart';
import 'package:virtual_lab/Pages/menu.dart';
import 'package:virtual_lab/Pages/settings.dart';
import 'package:virtual_lab/Pages/signup.dart';
import 'package:virtual_lab/Utils/routes.dart';

final myRoutesProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const MyLoginPage()),
      GoRoute(
        path: Routes.signIn,
        builder: (context, state) => const MyLoginPage(),
      ),
      GoRoute(
        path: Routes.signUp,
        builder: (context, state) => const MySignUpPage(),
      ),
      GoRoute(
        path: Routes.menu,
        builder: (context, state) => const MyMenuPage(),
      ),

      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const MySettingsPage(),
      ),
      GoRoute(
        path: Routes.foodChoices,
        builder: (context, state) => const MyFoodChoicesPage(),
      ),
    ],
  );
});
