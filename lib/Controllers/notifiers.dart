import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:virtual_lab/Components/custom_svg.dart';
import 'package:virtual_lab/Components/custom_text.dart';
import 'package:virtual_lab/Components/custom_text_field.dart';
import 'package:virtual_lab/Utils/properties.dart';

class AppController extends GetxController {
  static AppController get instance => Get.find();

  //?Initialize
  final player = AudioPlayer();

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  //? RX VARIABLE
  var isSelectedList = <RxBool>[].obs;
  late List<RxBool> selectedList;
  final soundToggle = true.obs;
  final musicToggle = true.obs;
  var seconds = 60.obs;
  Timer? _timer;

  final ingredientLimit = 10.obs;
  final bagToggle = false.obs;

  //? METHODS

  void bagOntap() {
    bagToggle.value = !bagToggle.value;
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        seconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void resetTimer([int startFrom = 60]) {
    seconds.value = startFrom;
    stopTimer();
  }

  void initializeSelection(int itemCount) {
    isSelectedList.value = List.generate(itemCount, (_) => false.obs);
  }

  void toggleSelection(int index) {
    isSelectedList[index].value = !isSelectedList[index].value;
  }

  void playClickSound() async {
    await player.play(AssetSource(clickEffect1));
  }

  Widget floatingButton({
    required BuildContext context,
    required Function() onTap,
    String? icon,
    bool? isLeft = true,
  }) {
    return Positioned(
      top: 14.h,
      left: isLeft! ? 14.w : null,
      right: isLeft ? null : 14.w,
      child: GestureDetector(
        onTap: () {
          playClickSound();
          onTap();
        },
        child: SizedBox(
          height: 48.h,
          child: AspectRatio(
            aspectRatio: 1,
            child: MySvgPicture(path: icon ?? menu),
          ),
        ),
      ),
    );
  }

  Widget repeatedTextInput({
    required String label,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4.h,
      children: [
        MyText(text: label, fontWeight: FontWeight.w600),
        MyTextfield(controller: controller, hint: 'Enter $label'),
      ],
    );
  }
}
