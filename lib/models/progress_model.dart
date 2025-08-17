class ProgressModel {
  final String studentId;
  final String coc1;
  final String coc2;
  final String coc3;

  ProgressModel({
    required this.studentId,
    required this.coc1,
    required this.coc2,
    required this.coc3,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> map) {
    return ProgressModel(
      studentId: map['studentId'] ?? '',
      coc1: map['coc1'] ?? '',
      coc2: map['coc2'] ?? '',
      coc3: map['coc3'] ?? '',
    );
  }

  factory ProgressModel.empty() {
    return ProgressModel(
      studentId: '',
      coc1: '',
      coc2: '',
      coc3: '',
    );
  }
}
