import 'dart:convert';

import 'package:get/get.dart';

class Helper extends GetxController {
  static Helper get instance => Get.find();

  String formatSecondsToMMSS(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String getErrorMessage(Object e) {
    try {
      final raw = e.toString();
      final jsonStart = raw.indexOf('{');

      if (jsonStart != -1) {
        final jsonString = raw.substring(jsonStart);
        final jsonMap = jsonDecode(jsonString);
        return jsonMap['message'] ?? 'An unknown error occurred';
      }

      return 'An unexpected error occurred. Please try again.';
    } catch (_) {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}
