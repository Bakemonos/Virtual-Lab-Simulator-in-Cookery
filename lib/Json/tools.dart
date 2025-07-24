//? TOOLS
import 'package:virtual_lab/utils/enum.dart';

//? TOOLS
enum ToolType {
  knife,
  chopper,
  cleaver,
  peeler,
  paringKnife,
  pot,
  kettle,
  saucepan,
  spoon,
  spatula,
  whisk,
  scissors,
  cutter,
  bowl,
  container,
  ziplocBag,
  pan,
  skillet,
  grill,
  griddle,
  tongs,
  mandolineSlicer,
  blender,
  foodProcessor,
  grinder,
  mortarAndPestle,
  mill,
  oven,
  bakingPan,
  tray,
  fryingPan,
  measuringCup,
  pitcher,
  ladle,
  grater,
  zester,
  microwave,
  strainer,
  sink,
  shaker,
  hand,
  steamer,
  bambooSteamer,
  deepFryer,
  fork,
  mixer,
}

List<ToolType> getToolsForAction(ActionType action) {
  switch (action) {
    case ActionType.chop:
      return [ToolType.knife, ToolType.chopper, ToolType.cleaver];
    case ActionType.peel:
      return [ToolType.peeler, ToolType.paringKnife];
    case ActionType.boil:
      return [ToolType.pot, ToolType.kettle, ToolType.saucepan];
    case ActionType.stir:
      return [ToolType.spoon, ToolType.spatula, ToolType.whisk];
    case ActionType.cut:
      return [ToolType.knife, ToolType.scissors, ToolType.cutter];
    case ActionType.marinate:
      return [ToolType.bowl, ToolType.container, ToolType.ziplocBag];
    case ActionType.cook:
      return [ToolType.pan, ToolType.pot, ToolType.skillet];
    case ActionType.grill:
      return [ToolType.grill, ToolType.griddle, ToolType.tongs];
    case ActionType.slice:
      return [ToolType.knife, ToolType.mandolineSlicer];
    case ActionType.blend:
      return [ToolType.blender, ToolType.foodProcessor];
    case ActionType.grind:
      return [ToolType.grinder, ToolType.mortarAndPestle, ToolType.mill];
    case ActionType.bake:
      return [ToolType.oven, ToolType.bakingPan, ToolType.tray];
    case ActionType.pour:
      return [ToolType.measuringCup, ToolType.pitcher, ToolType.ladle];
    case ActionType.grate:
      return [ToolType.grater, ToolType.zester];
    case ActionType.melt:
      return [ToolType.microwave, ToolType.saucepan];
    case ActionType.sprinkle:
      return [ToolType.shaker, ToolType.spoon, ToolType.hand];
    case ActionType.rinse:
      return [ToolType.strainer, ToolType.bowl, ToolType.sink];
    case ActionType.soak:
      return [ToolType.bowl, ToolType.container, ToolType.pot];
    case ActionType.season:
      return [ToolType.shaker, ToolType.bowl, ToolType.spoon];
    case ActionType.steam:
      return [ToolType.steamer, ToolType.pot, ToolType.bambooSteamer];
    case ActionType.fry:
      return [ToolType.fryingPan, ToolType.deepFryer, ToolType.spatula];
    case ActionType.whisk:
      return [ToolType.whisk, ToolType.fork, ToolType.mixer];
  }
}
