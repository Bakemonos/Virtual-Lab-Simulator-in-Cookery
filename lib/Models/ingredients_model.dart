class IngredientsModel {
  final String name;
  final String path;
  final List<ActionsModel> actions;
  final String actionStatus;

  IngredientsModel({
    required this.name,
    required this.path,
    required this.actions,
    required this.actionStatus,
  });
}

class ActionsModel {
  final String action;
  final String status;

  ActionsModel({required this.action, required this.status});
}

List<IngredientsModel> ingredientsample = [
  IngredientsModel(
    name: 'Cheese',
    path:
        'https://res.cloudinary.com/dgvi2di6t/image/upload/v1751198930/cheese_ymjfxq.png',
    actions: [ActionsModel(action: '', status: '')],
    actionStatus: '',
  ),
  IngredientsModel(
    name: 'Cucumber',
    path:
        'https://res.cloudinary.com/dgvi2di6t/image/upload/v1751198930/cucumber_jotcia.png',
    actions: [ActionsModel(action: '', status: '')],
    actionStatus: '',
  ),
  IngredientsModel(
    name: 'Cabbage',
    path:
        'https://res.cloudinary.com/dgvi2di6t/image/upload/v1751198931/cabbage_mr9nus.png',
    actions: [ActionsModel(action: '', status: '')],
    actionStatus: '',
  ),
  IngredientsModel(
    name: 'Bons Bottom',
    path:
        'https://res.cloudinary.com/dgvi2di6t/image/upload/v1751198930/burger_bottom_ejixfk.png',
    actions: [ActionsModel(action: '', status: '')],
    actionStatus: '',
  ),
  IngredientsModel(
    name: 'Bell Pepper',
    path:
        'https://res.cloudinary.com/dgvi2di6t/image/upload/v1751198930/bell_pepper_jbahli.png',
    actions: [ActionsModel(action: '', status: '')],
    actionStatus: '',
  ),
  IngredientsModel(
    name: 'Bons Top',
    path:
        'https://res.cloudinary.com/dgvi2di6t/image/upload/v1751198934/burger_top_npsdtl.png',
    actions: [ActionsModel(action: '', status: '')],
    actionStatus: '',
  ),
  IngredientsModel(
    name: 'Beacon',
    path:
        'https://res.cloudinary.com/dgvi2di6t/image/upload/v1751198940/beacon_moiqjf.png',
    actions: [ActionsModel(action: '', status: '')],
    actionStatus: '',
  ),
  IngredientsModel(
    name: 'Mustard',
    path:
        'https://res.cloudinary.com/dgvi2di6t/image/upload/v1751198934/mustard_gqk7jg.png',
    actions: [ActionsModel(action: '', status: '')],
    actionStatus: '',
  ),
  IngredientsModel(
    name: 'Ketchup',
    path:
        'https://res.cloudinary.com/dgvi2di6t/image/upload/v1751198932/ketchup_ilhobb.png',
    actions: [ActionsModel(action: '', status: '')],
    actionStatus: '',
  ),
  IngredientsModel(
    name: 'Tomato',
    path:
        'https://res.cloudinary.com/dgvi2di6t/image/upload/v1751198939/tomato_jot2yg.png',
    actions: [ActionsModel(action: '', status: '')],
    actionStatus: '',
  ),
  IngredientsModel(
    name: 'Mushrom',
    path:
        'https://res.cloudinary.com/dgvi2di6t/image/upload/v1751198933/mushrom_qmcpfv.png',
    actions: [ActionsModel(action: '', status: '')],
    actionStatus: '',
  ),
  IngredientsModel(
    name: 'Pepperoni',
    path:
        'https://res.cloudinary.com/dgvi2di6t/image/upload/v1751198937/pepperoni_yu12ta.png',
    actions: [ActionsModel(action: '', status: '')],
    actionStatus: '',
  ),
  IngredientsModel(
    name: 'Melt Cheese',
    path:
        'https://res.cloudinary.com/dgvi2di6t/image/upload/v1751198933/melt_cheese_mxizkx.png',
    actions: [ActionsModel(action: '', status: '')],
    actionStatus: '',
  ),
  IngredientsModel(
    name: 'Jalapeño',
    path:
        'https://res.cloudinary.com/dgvi2di6t/image/upload/v1751198932/jalape%C3%B1o_fhprcz.png',
    actions: [ActionsModel(action: '', status: '')],
    actionStatus: '',
  ),
  IngredientsModel(
    name: 'Egg',
    path:
        'https://res.cloudinary.com/dgvi2di6t/image/upload/v1751198931/egg_xvcfe1.png',
    actions: [ActionsModel(action: '', status: '')],
    actionStatus: '',
  ),
  IngredientsModel(
    name: 'Herbs',
    path:
        'https://res.cloudinary.com/dgvi2di6t/image/upload/v1751198931/herbs_pwnj1b.png',
    actions: [ActionsModel(action: '', status: '')],
    actionStatus: '',
  ),
  IngredientsModel(
    name: 'Onion',
    path:
        'https://res.cloudinary.com/dgvi2di6t/image/upload/v1751198936/onion_tbbuc6.png',
    actions: [ActionsModel(action: '', status: '')],
    actionStatus: '',
  ),
  IngredientsModel(
    name: 'Patties',
    path:
        'https://res.cloudinary.com/dgvi2di6t/image/upload/v1751198937/patties_pnyvhq.png',
    actions: [ActionsModel(action: '', status: '')],
    actionStatus: '',
  ),
];
