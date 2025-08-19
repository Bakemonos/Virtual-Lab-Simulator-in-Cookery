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

  String toCamelCase(String input) {
    final words = input
        .toLowerCase()
        .split(RegExp(r'[\s_-]+'))
        .where((word) => word.isNotEmpty)
        .toList();

    if (words.isEmpty) return '';

    return words.first + words.skip(1).map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join();
  }

  String formatLine(String label, List<String> items) {
    final text = items.join(', ');
    final suffix = items.length > 1 ? 's' : '';
    return '• $label$suffix: $text';
  }

  bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.isScheme("http") || uri.isScheme("https"));
    } catch (_) {
      return false;
    }
  }

}
