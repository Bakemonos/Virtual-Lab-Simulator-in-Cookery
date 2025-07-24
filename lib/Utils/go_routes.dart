import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import 'package:virtual_lab/pages/Information/information.dart';
import 'package:virtual_lab/pages/about_game.dart';
import 'package:virtual_lab/pages/achievements/achievement_type.dart';
import 'package:virtual_lab/pages/achievements/slide_option.dart';
import 'package:virtual_lab/pages/achievements/view_achievement.dart';
import 'package:virtual_lab/pages/chooseIngredients/ingredients_selector.dart';
import 'package:virtual_lab/pages/food_choices.dart';
import 'package:virtual_lab/pages/Setup/login.dart';
import 'package:virtual_lab/pages/forgotPassword/change_password.dart';
import 'package:virtual_lab/pages/forgotPassword/enter_email.dart';
import 'package:virtual_lab/pages/menu.dart';
import 'package:virtual_lab/pages/playUI/play_ui.dart';
import 'package:virtual_lab/pages/settings.dart';
import 'package:virtual_lab/pages/Setup/signup.dart';
import 'package:virtual_lab/utils/routes.dart';

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
