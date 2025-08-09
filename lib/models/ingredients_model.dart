class SubmitedCocModel {
  final String? id;
  final String type;
  final String category;
  final String name;
  final String image;
  final String studentId;
  final List<IngredientsModel> ingredients;
  final List<EquipmentsModel> equipments;

  SubmitedCocModel({
    this.id,
    required this.type,
    required this.category,
    required this.name,
    required this.image,
    required this.studentId,
    required this.ingredients,
    required this.equipments,
  });

  factory SubmitedCocModel.fromJson(Map<String, dynamic> map) {
    return SubmitedCocModel(
      id: map['_id'] ?? '',
      type: map['type'] ?? '',
      category: map['category'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      studentId: map['studentId'] ?? '',
      ingredients: (map['ingredients'] as List).map((item) => IngredientsModel.fromJson(item)).toList(),
      equipments: (map['equipments'] as List).map((item) => EquipmentsModel.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'category': category,
      'name': name,
      'image': image,
      'studentId': studentId,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'equipments': equipments.map((e) => e.toJson()).toList(),
    };
  }

  factory SubmitedCocModel.empty() {
    return SubmitedCocModel(
      id: '',
      type: '',
      category: '',
      name: '',
      image: '',
      studentId: '',
      ingredients: [],
      equipments: [],
    );
  }
}


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
  final EquipmentsModel? used;

  IngredientsModel({
    this.dragKey,
    required this.name,
    required this.path,
    required this.category,
    this.actions = const [],
    this.used,
  });

  factory IngredientsModel.fromJson(Map<String, dynamic> map) {
    return IngredientsModel(
      name: map['name'] ?? '',
      path: map['path'] ?? '',
      category: map['category'] ?? '',
      actions: map['actions'] != null ? (map['actions'] as List).map((item) => ActionsModel.fromJson(item)).toList() : [],
      dragKey: map['dragKey'],
      used: map['used'] != null ? EquipmentsModel.fromJson(map['used']) : null,
    );
  } 

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'category': category,
      'actions': actions.map((item) => item.toJson()).toList(),
      'used': used?.toJson(),
    };
  }

  factory IngredientsModel.empty() {
    return IngredientsModel(
      dragKey: '',
      name: '',
      path: '',
      category: '',
      actions: [],
      used: null,
    );
  }

  IngredientsModel copyWith({
    String? dragKey,
    String? name,
    String? path,
    String? category,
    List<ActionsModel>? actions,
    EquipmentsModel? used,
  }) {
    return IngredientsModel(
      dragKey: dragKey ?? this.dragKey,
      name: name ?? this.name,
      path: path ?? this.path,
      category: category ?? this.category,
      actions: actions != null
          ? actions.map((a) => a.copyWith()).toList()
          : this.actions.map((a) => a.copyWith()).toList(),
      used: used ?? this.used,
    );
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

  ActionsModel copyWith({
    String? status,
    String? action,
    String? tool,
  }) {
    return ActionsModel(
      status: status ?? this.status,
      action: action ?? this.action,
      tool: tool ?? this.tool,
    );
  }
  
}

class EquipmentsModel {
  final String name;
  final String image;

  EquipmentsModel({
    required this.name, 
    required this.image, 
  });

  factory EquipmentsModel.fromJson(Map<String, dynamic> map) {
    return EquipmentsModel(
      name: map['name'] ?? '',
      image: map['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name, 
      'image': image,
    };
  }

  EquipmentsModel copyWith({
    String? name,
    String? image,
  }) {
    return EquipmentsModel(
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }

  factory EquipmentsModel.empty() {
    return EquipmentsModel(
      name: '',
      image: '',
    );
  }
  
}