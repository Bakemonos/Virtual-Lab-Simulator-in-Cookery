enum IngredientType { vegetable, meat, fruit, grain, dairy, spice }

enum ActionType {
  chop,
  peel,
  boil,
  stir,
  cut,
  marinate,
  cook,
  grill,
  slice,
  blend,
  grind,
  bake,
  pour,
  grate,
  melt,
  sprinkle,
  rinse,
  soak,
  season,
  steam,
  fry,
  whisk,
  serve,
}

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
        ActionType.serve,
      ];
    case IngredientType.meat:
      return [
        ActionType.rinse,
        ActionType.cut,
        ActionType.marinate,
        ActionType.grill,
        ActionType.cook,
        ActionType.fry,
        ActionType.season,
        ActionType.serve,
      ];
    case IngredientType.fruit:
      return [
        ActionType.rinse,
        ActionType.peel,
        ActionType.slice,
        ActionType.blend,
        ActionType.serve,
      ];
    case IngredientType.grain:
      return [
        ActionType.rinse,
        ActionType.soak,
        ActionType.boil,
        ActionType.grind,
        ActionType.bake,
        ActionType.serve,
      ];
    case IngredientType.dairy:
      return [
        ActionType.pour,
        ActionType.grate,
        ActionType.melt,
        ActionType.serve,
      ];
    case IngredientType.spice:
      return [ActionType.grind, ActionType.sprinkle, ActionType.season];
  }
}
