class ApiResponse {
  final String? message;
  final dynamic data;
  final String? token;
  final bool? success;

  ApiResponse({this.message, this.data, this.token, this.success});

  factory ApiResponse.fromJson(Map<String, dynamic> map) {
    return ApiResponse(
      message: map['message'],
      data: map['data'], 
      token: map['token'],
      success: map['success'],
    );
  }
}
