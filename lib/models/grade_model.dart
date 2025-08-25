class GradeModel {
  final String studentId;
  final String type;
  final int useTools;
  final int procedure;
  final int safety;
  final int product;
  final int timeManagement;
  final int properBalance;
  final int useOfColor;
  final int shape;
  final int useOfGarnish;
  final int overallPresentation;
  final String comments;
  final num averageScore;
  final int starRating;

  GradeModel({
    required this.studentId,
    required this.type,
    required this.useTools,
    required this.procedure,
    required this.safety,
    required this.product,
    required this.timeManagement,
    required this.properBalance,
    required this.useOfColor,
    required this.shape,
    required this.useOfGarnish,
    required this.overallPresentation,
    required this.comments,
    required this.averageScore,
    required this.starRating,
  });

  factory GradeModel.fromJson(Map<String, dynamic> map) {
    return GradeModel(
      studentId: map['studentId'] ?? '',
      type: map['type'] ?? '',
      useTools: map['useTools'] ?? 0,
      procedure: map['procedure'] ?? 0,
      safety: map['safety'] ?? 0,
      product: map['product'] ?? 0,
      timeManagement: map['timeManagement'] ?? 0,
      properBalance: map['properBalance'] ?? 0,
      useOfColor: map['useOfColor'] ?? 0,
      shape: map['shape'] ?? 0,
      useOfGarnish: map['useOfGarnish'] ?? 0,
      overallPresentation: map['overallPresentation'] ?? 0,
      comments: map['comments'] ?? '',
      averageScore: map['averageScore'] ?? 0.0,
      starRating: map['starRating'] ?? 0,
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     '_id': id,
  //     'studentId': studentId,
  //     'type': type,
  //     'useTools': useTools,
  //     'procedure': procedure,
  //     'safety': safety,
  //     'product': product,
  //     'timeManagement': timeManagement,
  //     'properBalance': properBalance,
  //     'useOfColor': useOfColor,
  //     'shape': shape,
  //     'useOfGarnish': useOfGarnish,
  //     'overallPresentation': overallPresentation,
  //     'comments': comments,
  //     'averageScore': averageScore,
  //     'starRating': starRating,
  //   };
  // }

  factory GradeModel.empty() {
    return GradeModel(
      studentId: '',
      type: '',
      useTools: 0,
      procedure: 0,
      safety: 0,
      product: 0,
      timeManagement: 0,
      properBalance: 0,
      useOfColor: 0,
      shape: 0,
      useOfGarnish: 0,
      overallPresentation: 0,
      comments: '',
      averageScore: 0,
      starRating: 0,
    );
  }

  GradeModel copyWith({
    String? id,
    String? studentId,
    String? type,
    int? useTools,
    int? procedure,
    int? safety,
    int? product,
    int? timeManagement,
    int? properBalance,
    int? useOfColor,
    int? shape,
    int? useOfGarnish,
    int? overallPresentation,
    String? comments,
    num? averageScore,
    int? starRating,
    int? v,
  }) {
    return GradeModel(
      studentId: studentId ?? this.studentId,
      type: type ?? this.type,
      useTools: useTools ?? this.useTools,
      procedure: procedure ?? this.procedure,
      safety: safety ?? this.safety,
      product: product ?? this.product,
      timeManagement: timeManagement ?? this.timeManagement,
      properBalance: properBalance ?? this.properBalance,
      useOfColor: useOfColor ?? this.useOfColor,
      shape: shape ?? this.shape,
      useOfGarnish: useOfGarnish ?? this.useOfGarnish,
      overallPresentation: overallPresentation ?? this.overallPresentation,
      comments: comments ?? this.comments,
      averageScore: averageScore ?? this.averageScore,
      starRating: starRating ?? this.starRating,
    );
  }
}
