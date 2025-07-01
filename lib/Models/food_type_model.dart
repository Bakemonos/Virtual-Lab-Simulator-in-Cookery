class FoodTypeModel {
  final String name;
  final String path;

  FoodTypeModel({required this.name, required this.path});
}

List<FoodTypeModel> foodType = [
  FoodTypeModel(
    name: 'Soup, Sauce',
    path:
        'https://res.cloudinary.com/dgvi2di6t/image/upload/v1751199001/soup_ovutke.png',
  ),
  FoodTypeModel(
    name: 'Appetizer, Sandwich, salad',
    path:
        'https://res.cloudinary.com/dgvi2di6t/image/upload/v1751199001/appetizer_jhtehu.png',
  ),
  FoodTypeModel(
    name: 'Desserts',
    path:
        'https://res.cloudinary.com/dgvi2di6t/image/upload/v1751199000/dessert_yzcyrl.png',
  ),
];
