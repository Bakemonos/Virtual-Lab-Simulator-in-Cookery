class FoodTypeModel {
  final String name;
  final String label;
  final String path;
  final String title;
  final List<FoodDesciptionModel> instructions;
  final String description;

  FoodTypeModel({
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

List<FoodTypeModel> foodType = [
  FoodTypeModel(
    title: 'Hot Meal',
    name: 'Soup\'s',
    label: 'Soup, Sauce',
    description: 'Create name for Soup, Main Dish and Sauce',
    path:
        'https://res.cloudinary.com/dgvi2di6t/image/upload/v1751199001/soup_ovutke.png',
    instructions: [
      FoodDesciptionModel(
        name: 'Soup',
        list: ['Thick or Clear Soup appropriate to the main dish'],
      ),
      FoodDesciptionModel(
        name: 'Main Dish',
        list: ['Protein Dish', 'Protein Dish', 'Starch or Cereal Dish'],
      ),
      FoodDesciptionModel(
        name: 'Sauce',
        list: ['Sauce appropriate to the main dish'],
      ),
    ],
  ),
  FoodTypeModel(
    title: 'Cold Meal',
    name: 'Appetizer\'s',
    label: 'Appetizer, Sandwich, salad',
    description:
        'Create name for your Appetizers, Sandwich and Salad & Salad Dressing',
    path:
        'https://res.cloudinary.com/dgvi2di6t/image/upload/v1751199001/appetizer_jhtehu.png',
    instructions: [
      FoodDesciptionModel(
        name: 'Appetizer',
        list: ['appetizers attractively. It should be 4 pieces of 3 kinds.'],
      ),
      FoodDesciptionModel(name: 'Sandwich', list: ['sandwich attractively.']),
      FoodDesciptionModel(
        name: 'Salad and Salad Dress',
        list: ['Salad with dressing'],
      ),
    ],
  ),
  FoodTypeModel(
    title: 'Desserts',
    name: 'Desserts',
    label: 'Desserts',
    description: 'Create name for desserts',
    path:
        'https://res.cloudinary.com/dgvi2di6t/image/upload/v1751199000/dessert_yzcyrl.png',
    instructions: [
      FoodDesciptionModel(
        name: 'Desserts',
        list: ['Hot Dessert', 'Cold Dessert'],
      ),
    ],
  ),
];
