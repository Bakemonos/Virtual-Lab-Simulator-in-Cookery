import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:virtual_lab/utils/enum.dart';

class Helper extends GetxController {
  static Helper get instance => Get.find();

  String formatSecondsToMMSS(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String getErrorMessage(Object e) {
    try {
      if (e is SocketException) {
        return 'No Internet Connection.';
      } else if (e is TimeoutException) {
        return 'Request timed out. Please try again.';
      }

      final raw = e.toString();
      final jsonStart = raw.indexOf('{');

      if (jsonStart != -1) {
        final jsonString = raw.substring(jsonStart);
        final jsonMap = jsonDecode(jsonString);
        return jsonMap['message'] ?? 'An unknown error occurred';
      }

      return raw;
    } catch (_) {
      return e.toString();
    }
  }

  IngredientType stringToIngredientType(String type) {
    switch (type.toLowerCase()) {
      case 'vegetable':
        return IngredientType.vegetable;
      case 'meat':
        return IngredientType.meat;
      case 'fruit':
        return IngredientType.fruit;
      case 'grain':
        return IngredientType.grain;
      case 'dairy':
        return IngredientType.dairy;
      case 'spice':
        return IngredientType.spice;
      default:
        throw Exception('Unknown IngredientType: $type');
    }
  }
}
