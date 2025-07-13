import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_lab/Services/api_response.dart';

class ApiServices extends GetxController {
  static ApiServices get instance => Get.find();

  final String apiKey = dotenv.env['API_URL']!;

  //? GET
  Future<ApiResponse> get(String endpoint) async {
    print('\nENDPOINT : $apiKey/$endpoint\n');
    final response = await http.get(Uri.parse('$apiKey$endpoint'));

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('GET failed: ${response.body}');
    }
  }

  //? POST
  Future<ApiResponse> post(String endpoint, Map<String, dynamic> data) async {
    print('\nENDPOINT : $apiKey/$endpoint\n');

    final response = await http.post(
      Uri.parse('$apiKey/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('POST failed: ${response.body}');
    }
  }
}
