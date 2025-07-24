class UserModel {
  final String? id;
  final String lrn;
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final String password;
  final String gradeLevel;
  final String status;

  UserModel({
    this.id,
    required this.lrn,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.password,
    required this.gradeLevel,
    required this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'],
      lrn: map['lrn'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      gender: map['gender'],
      password: map['password'],
      gradeLevel: map['gradeLevel'],
      status: map['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'lrn': lrn,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'gender': gender,
      'password': password,
      'gradeLevel': gradeLevel,
      'status': status,
    };
  }

  factory UserModel.empty() {
    return UserModel(
      id: '',
      lrn: '',
      firstName: '',
      lastName: '',
      email: '',
      gender: '',
      password: '',
      gradeLevel: '',
      status: '',
    );
  }
}
