import 'package:virtual_lab/models/ingredients_model.dart';

final List<Map<String, dynamic>> dishCombinations = [
  {
    'name': 'fish soup',
    'type': 'soup',
    'contains': ['fish', 'water', 'ginger'],
    'image': 'https://res.cloudinary.com/dgvi2di6t/image/upload/v1753802663/fish_soup_eqlcfh.png',
  },
  {
    'name': 'chicken soup',
    'type': 'soup',
    'contains': ['chicken', 'water', 'carrot', 'onion'],
    'image': 'https://res.cloudinary.com/dgvi2di6t/image/upload/v1753802663/chicken_soup_pm4xzq.png',
  },
  {
    'name': 'tofu soup',
    'type': 'soup',
    'contains': ['tofu', 'water', 'mushroom', 'ginger'],
    'image': 'https://res.cloudinary.com/dgvi2di6t/image/upload/v1753802662/tofu_soup_z1r3cb.png',
  },
  {
    'name': 'vegetable soup',
    'type': 'soup',
    'contains': ['cabbage', 'carrot', 'onion', 'water'],
    'image': 'https://res.cloudinary.com/dgvi2di6t/image/upload/v1753802663/vegetable_soup_gcqvot.png',
  },
  {
    'name': 'beef soup',
    'type': 'soup',
    'contains': ['beef', 'water', 'onion', 'potato'],
    'image': 'https://res.cloudinary.com/dgvi2di6t/image/upload/v1753802663/beef_soup_ihgwhv.png',
  },
  {
    'name': 'egg drop soup',
    'type': 'soup',
    'contains': ['egg', 'water', 'cornstarch', 'salt'],
    'image': 'https://res.cloudinary.com/dgvi2di6t/image/upload/v1753802663/egg_drop_soup_g0t7rf.png',
  },


  {
    'name': 'fried rice',
    'type': 'mainDish',
    'contains': ['rice', 'egg', 'soy sauce', 'onion'],
    'image': 'https://res.cloudinary.com/dgvi2di6t/image/upload/v1753804253/fried_rice_xufyck.png',
  },
  {
    'name': 'sweet and sour pork',
    'type': 'mainDish',
    'contains': ['pork', 'vinegar', 'sugar', 'tomato paste', 'bell pepper'],
    'image': 'https://res.cloudinary.com/dgvi2di6t/image/upload/v1753804253/sweet_and_sour_pork_vpyp3c.png',
  },
  {
    'name': 'chicken adobo',
    'type': 'mainDish',
    'contains': ['chicken', 'soy sauce', 'vinegar', 'garlic', 'onion'],
    'image': 'https://res.cloudinary.com/dgvi2di6t/image/upload/v1753804253/chicken_adobo_thpfhn.png',
  },
  {
    'name': 'beef stew',
    'type': 'mainDish',
    'contains': ['beef', 'potato', 'carrot', 'onion'],
    'image': 'https://res.cloudinary.com/dgvi2di6t/image/upload/v1753804254/beef_stew_f93kye.png',
  },
  {
    'name': 'tofu stir fry',
    'type': 'mainDish',
    'contains': ['tofu', 'soy sauce', 'garlic', 'bell pepper', 'onion'],
    'image': 'https://res.cloudinary.com/dgvi2di6t/image/upload/v1753804253/tofu_stir_fry_sdfgak.png',
  },
  {
    'name': 'egg noodles',
    'type': 'mainDish',
    'contains': ['noodles', 'egg', 'butter', 'onion', 'soy sauce'],
    'image': 'https://res.cloudinary.com/dgvi2di6t/image/upload/v1753804252/egg_noodles_ltyrfo.png',
  },
  {
    'name': 'mushroom rice',
    'type': 'mainDish',
    'contains': ['rice', 'mushroom', 'onion', 'butter'],
    'image': 'https://res.cloudinary.com/dgvi2di6t/image/upload/v1753804253/mushroom_rice_anxlez.png',
  },

  {
    'name': 'sweet and sour sauce',
    'type': 'sauce',
    'contains': ['vinegar', 'sugar', 'tomato paste'],
    'image': 'https://res.cloudinary.com/dhceioavi/image/upload/v1753927779/sauce_n4syhg.png',
  },
  {
    'name': 'soy garlic sauce',
    'type': 'sauce',
    'contains': ['soy sauce', 'garlic', 'sugar'],
    'image': 'https://res.cloudinary.com/dhceioavi/image/upload/v1753927779/sauce_n4syhg.png',
  },
  {
    'name': 'spicy chili sauce',
    'type': 'sauce',
    'contains': ['chili flakes', 'garlic', 'vinegar'],
    'image': 'https://res.cloudinary.com/dhceioavi/image/upload/v1753927779/sauce_n4syhg.png',
  },
  {
    'name': 'butter sauce',
    'type': 'sauce',
    'contains': ['butter', 'garlic', 'onion'],
    'image': 'https://res.cloudinary.com/dhceioavi/image/upload/v1753927779/sauce_n4syhg.png',
  },
  {
    'name': 'tomato-based sauce',
    'type': 'sauce',
    'contains': ['tomato paste', 'garlic', 'onion', 'sugar'],
    'image': 'https://res.cloudinary.com/dhceioavi/image/upload/v1753927779/sauce_n4syhg.png',
  },
];
Map<String, dynamic>? getBestMatchedDish(List<IngredientsModel> selected, String type) {
  final selectedNames = selected.map((i) => i.name.toLowerCase().trim()).toSet();
  int highestScore = 0;
  Map<String, dynamic>? bestMatch;

  for (final dish in dishCombinations.where((d) => d['type'].toString().toLowerCase().trim() == type.toLowerCase().trim())) {
    final required = List<String>.from((dish['contains'] as List).map((e) => e.toLowerCase().trim()));
    final score = required.where((item) => selectedNames.contains(item)).length;

    if (score > highestScore) {
      highestScore = score;
      bestMatch = dish;
    }
  }

  if (bestMatch == null || highestScore == 0) {
    bestMatch = dishCombinations.firstWhere(
      (d) => d['type'].toString().toLowerCase().trim() == type.toLowerCase().trim(),
      orElse: () => {},
    );
  }

  return bestMatch;
}



