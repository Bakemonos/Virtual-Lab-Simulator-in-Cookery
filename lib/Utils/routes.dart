import 'package:go_router/go_router.dart';
import 'package:riverpod/riverpod.dart';
import 'package:virtual_lab/Pages/login.dart';

final myRoutesProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const MyLoginPage()),
      // GoRoute(
      //   path: Routes.createCharacter,
      //   builder: (context, state) => const CreateCharacter(),
      // ),
    ],
  );
});
