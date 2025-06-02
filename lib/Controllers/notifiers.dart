import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtual_lab/Models/notifier_model.dart';

class AppController extends StateNotifier<AppState> {
  AppController() : super(AppState(name: ''));

  void setName(String newName) {
    state = state.copyWith(name: newName);
  }
}

final appProvider = StateNotifierProvider<AppController, AppState>((ref) {
  return AppController();
});
