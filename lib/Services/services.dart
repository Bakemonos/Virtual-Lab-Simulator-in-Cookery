import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_lab/services/api_response.dart';

class ApiServices extends GetxController {
  static ApiServices get instance => Get.find();

  final String apiKey = dotenv.env['API_URL']!;

  //? GET
  Future<ApiResponse> get(String endpoint) async {
    print('\nENDPOINT : $apiKey/$endpoint\n');

    try {
      final response = await http
          .get(Uri.parse('$apiKey/$endpoint'))
          .timeout(Duration(seconds: 15));

          print('\nDATA : ${response.body}\n');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.fromJson(jsonDecode(response.body));
      } else {
        final body = jsonDecode(response.body);
        return ApiResponse(
          success: false,
          message: body['message'] ?? 'GET failed: ${response.statusCode}',
          data: null,
        );
      }
    } on TimeoutException catch (_) {
      throw Exception('Request timeout. Please try again later.');
    } on SocketException catch (_) {
      throw Exception('No Internet Connection.');
    } catch (e) {
      throw Exception('Network error: $e');
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

    print('BODY : ${response.body}\n');


    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('POST failed: ${response.body}');
    }
  }

}
