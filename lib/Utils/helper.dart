import 'package:get/get.dart';

class Helper extends GetxController {
  static Helper get instance => Get.find();

  String formatSecondsToMMSS(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
