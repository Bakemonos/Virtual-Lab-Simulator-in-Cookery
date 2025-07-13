class ApiResponse {
  final String? message;
  final dynamic data;
  final String? token;
  final bool? success;

  ApiResponse({this.message, this.data, this.token, this.success});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      message: json['message'],
      data: json['data'],
      token: json['token'],
      success: json['success'],
    );
  }
}
