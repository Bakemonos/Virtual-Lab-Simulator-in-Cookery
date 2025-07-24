class FoodMenuModel {
  final String? menu;
  final String name;
  final String label;
  final String path;
  final String title;
  final List<FoodDesciptionModel> instructions;
  final String description;

  FoodMenuModel({
    this.menu,
    required this.name,
    required this.label,
    required this.path,
    required this.title,
    required this.instructions,
    required this.description,
  });
}

class FoodDesciptionModel {
  final String name;
  final List<String> list;

  FoodDesciptionModel({required this.name, required this.list});
}
