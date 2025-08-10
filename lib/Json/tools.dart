import 'package:virtual_lab/utils/enum.dart';

List<ActionType> getActionsForIngredient(IngredientType type) {
  switch (type) {
    case IngredientType.vegetable:
      return [
        ActionType.rinse,
        ActionType.peel,
        ActionType.chop,
        ActionType.stir,
        ActionType.season,
        ActionType.wash,
      ];
    case IngredientType.meat:
      return [
        ActionType.rinse,
        ActionType.cut,
        ActionType.slice,
        ActionType.marinate,
        ActionType.season,
        ActionType.wash,
      ];
    case IngredientType.fruit:
      return [
        ActionType.rinse,
        ActionType.peel,
        ActionType.slice,
        ActionType.blend,
        ActionType.wash,
      ];
    case IngredientType.grain:
      return [
        ActionType.rinse,
        ActionType.soak,
        ActionType.grind,
        ActionType.slice,
      ];
    case IngredientType.dairy:
      return [
        ActionType.pour,
        ActionType.grate,
        ActionType.crack, 
        ActionType.beat,     
      ];
    case IngredientType.spice:
      return [
        ActionType.grind,
        ActionType.sprinkle,
        ActionType.season,
        ActionType.scoop,
      ];
  }
}
