import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import 'package:virtual_lab/Pages/Achievements/achievementType.dart';
import 'package:virtual_lab/Pages/Achievements/slideOption.dart';
import 'package:virtual_lab/Pages/Achievements/viewAchievement.dart';
import 'package:virtual_lab/Pages/ChooseIngredients/ingredientsSelector.dart';
import 'package:virtual_lab/Pages/ForgotPassword/changePassword.dart';
import 'package:virtual_lab/Pages/ForgotPassword/enterEmail.dart';
import 'package:virtual_lab/Pages/Information/information.dart';
import 'package:virtual_lab/Pages/aboutGame.dart';
import 'package:virtual_lab/Pages/foodChoices.dart';
import 'package:virtual_lab/Pages/Setup/login.dart';
import 'package:virtual_lab/Pages/menu.dart';
import 'package:virtual_lab/Pages/PlayUI/playUI.dart';
import 'package:virtual_lab/Pages/settings.dart';
import 'package:virtual_lab/Pages/Setup/signup.dart';
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

      //? FORGOT PASSWORD
      GoRoute(
        path: Routes.forgotEnterEmail,
        builder: (context, state) => const MyForgotEnterEmailPage(),
      ),
      GoRoute(
        path: Routes.forgotChangePassword,
        builder: (context, state) => const MyForgotChangePasswordPage(),
      ),

      //? ACHIEVEMENT OPTION
      GoRoute(
        path: Routes.achievementOption,
        builder: (context, state) => const MyAchievementTypePage(),
      ),
      GoRoute(
        path: Routes.sliderOption,
        builder: (context, state) => const MySliderOptionPage(),
      ),
      GoRoute(
        path: Routes.viewAchievement,
        builder: (context, state) => const MyViewAchievementPage(),
      ),

      //? MAIN MENU
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
        builder: (context, state) {
          final page = state.extra as Widget? ?? const MyFoodChoicesPage();
          return page;
        },
      ),
      GoRoute(
        path: Routes.aboutGame,
        builder: (context, state) => const MyAboutGamePage(),
      ),
      GoRoute(
        path: Routes.playUI,
        builder: (context, state) => const MyPlayUIPage(),
      ),

      GoRoute(
        path: Routes.ingredientsSelection,
        builder: (context, state) => const MyIngredientsSelectionPage(),
      ),

      GoRoute(
        path: Routes.information,
        builder: (context, state) => const MyInformationPage(),
      ),
    ],
  );
});
