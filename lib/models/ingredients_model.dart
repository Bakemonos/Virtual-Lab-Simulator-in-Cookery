class InventoryModel {
  final String? id;
  final String type;
  final String studentId;
  final String take;
  final List<IngredientsModel> ingredients;

  InventoryModel({
    this.id,
    required this.type,
    required this.studentId,
    required this.take,
    required this.ingredients,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> map) {
    return InventoryModel(
      id: map['_id'] ?? '',
      type: map['type'] ?? '',
      studentId: map['studentId'] ?? '',
      take: map['take'] ?? '',
      ingredients: (map['ingredients'] as List).map((item) => IngredientsModel.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'studentId': studentId,
      'take': take,
      'ingredients': ingredients.map((item) => item.toJson()).toList(),
    };
  }

  factory InventoryModel.empty() {
    return InventoryModel(studentId: '', take: '', type: '', ingredients: []);
  }
}

class IngredientsModel {
  final String? dragKey;
  final String name;
  final String path;
  final String category;
  final List<ActionsModel> actions;

  IngredientsModel({
    this.dragKey,
    required this.name,
    required this.path,
    required this.category,
    this.actions = const [],
  });

  factory IngredientsModel.fromJson(Map<String, dynamic> map) {
    return IngredientsModel(
      name: map['name'] ?? '',
      path: map['path'] ?? '',
      category: map['category'] ?? '',
      actions: map['actions'] != null ? (map['actions'] as List).map((item) => ActionsModel.fromJson(item)).toList(): [],
      dragKey: map['dragKey'], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'category': category,
      'actions': actions.map((item) => item.toJson()).toList(),
      'dragKey': dragKey,
    };
  }

  factory IngredientsModel.empty() {
    return IngredientsModel(dragKey: '', name: '', path: '', category: '', actions: []);
  }
}

class ActionsModel {
  final String action;
  final String status;
  final String tool;

  ActionsModel({required this.action, required this.status, required this.tool});

  factory ActionsModel.fromJson(Map<String, dynamic> map) {
    return ActionsModel(
      action: map['action'] ?? '',
      status: map['status'] ?? '',
      tool: map['tool'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'action': action, 
      'status': status,
      'tool': tool,
    };
  }
  
}
