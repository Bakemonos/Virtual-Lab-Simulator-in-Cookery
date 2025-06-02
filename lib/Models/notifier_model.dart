class AppState {
  final String name;

  AppState({required this.name});

  AppState copyWith({String? name}) {
    return AppState(name: name ?? this.name);
  }
}
