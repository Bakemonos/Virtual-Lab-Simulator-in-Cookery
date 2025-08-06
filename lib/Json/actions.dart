import 'package:virtual_lab/utils/enum.dart';

List<ToolType> getToolsForAction(ActionType action) {
  switch (action) {
    case ActionType.chop:
      return [ToolType.knife, ToolType.chopper, ToolType.cleaver];
    case ActionType.peel:
      return [ToolType.peeler, ToolType.paringKnife];
    case ActionType.stir:
      return [ToolType.spoon, ToolType.spatula, ToolType.whisk];
    case ActionType.cut:
      return [ToolType.knife, ToolType.scissors, ToolType.cutter];
    case ActionType.marinate:
      return [ToolType.bowl, ToolType.container, ToolType.ziplocBag]; 
    case ActionType.slice:
      return [ToolType.knife, ToolType.mandolineSlicer]; 
    case ActionType.blend:
      return [ToolType.blender, ToolType.foodProcessor];
    case ActionType.grind:
      return [ToolType.grinder, ToolType.mortarAndPestle, ToolType.mill];
    case ActionType.pour:
      return [ToolType.measuringCup, ToolType.pitcher, ToolType.ladle];
    case ActionType.grate:
      return [ToolType.grater, ToolType.zester];
    case ActionType.sprinkle:
      return [ToolType.shaker, ToolType.spoon, ToolType.hand];
    case ActionType.rinse:
      return [ToolType.strainer, ToolType.bowl, ToolType.sink];
    case ActionType.soak:
      return [ToolType.bowl, ToolType.container];
    case ActionType.season:
      return [ToolType.shaker, ToolType.bowl, ToolType.spoon];
    case ActionType.whisk:
      return [ToolType.whisk, ToolType.fork, ToolType.mixer];
    case ActionType.crack:
      return [ToolType.bowl, ToolType.hand];
    case ActionType.beat:
      return [ToolType.whisk, ToolType.fork, ToolType.spoon, ToolType.bowl];
    case ActionType.scramble:
      return [ToolType.spatula, ToolType.bowl];
    case ActionType.wash:
      return [ToolType.sink, ToolType.bowl, ToolType.hand];
    case ActionType.scoop:
      return [ToolType.spoon, ToolType.cup];
    case ActionType.clean:
      return [ToolType.sink, ToolType.hand];
  }
}
