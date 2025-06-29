import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import 'package:virtual_lab/Pages/Achievements/achievement_type.dart';
import 'package:virtual_lab/Pages/Achievements/slide_option.dart';
import 'package:virtual_lab/Pages/ChooseIngredients/ingredientsSelector.dart';
import 'package:virtual_lab/Pages/ForgotPassword/change_password.dart';
import 'package:virtual_lab/Pages/ForgotPassword/enter_email.dart';
import 'package:virtual_lab/Pages/Information/information.dart';
import 'package:virtual_lab/Pages/about_game.dart';
import 'package:virtual_lab/Pages/food_choices.dart';
import 'package:virtual_lab/Pages/Setup/login.dart';
import 'package:virtual_lab/Pages/menu.dart';
import 'package:virtual_lab/Pages/play_ui.dart';
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
