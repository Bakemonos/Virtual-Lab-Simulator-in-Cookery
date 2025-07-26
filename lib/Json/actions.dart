//? ACTIONS
import 'package:virtual_lab/utils/enum.dart';

//? ACTIONS
List<ActionType> getActionsForIngredient(IngredientType type) {
  switch (type) {
    case IngredientType.vegetable:
      return [
        ActionType.rinse,
        ActionType.peel,
        ActionType.chop,
        ActionType.boil,
        ActionType.stir,
        ActionType.steam,
        ActionType.fry,
        ActionType.season,
      ];
    case IngredientType.meat:
      return [
        ActionType.rinse,
        ActionType.cut,
        ActionType.marinate,
        ActionType.grill,
        ActionType.fry,
        ActionType.season,
      ];
    case IngredientType.fruit:
      return [
        ActionType.rinse,
        ActionType.peel,
        ActionType.slice,
        ActionType.blend,
      ];
    case IngredientType.grain:
      return [
        ActionType.rinse,
        ActionType.soak,
        ActionType.boil,
        ActionType.grind,
        ActionType.bake,
      ];
    case IngredientType.dairy:
      return [
        ActionType.pour,
        ActionType.grate,
        ActionType.melt,
      ];
    case IngredientType.spice:
      return [ActionType.grind, ActionType.sprinkle, ActionType.season];
  }
}

