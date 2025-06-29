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

  final soundToggle = true.obs;
  final musicToggle = true.obs;

  var seconds = 60.obs;
  Timer? _timer;

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

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  var isSelectedList = <RxBool>[].obs;
  late List<RxBool> selectedList;

  void initializeSelection(int itemCount) {
    isSelectedList.value = List.generate(itemCount, (_) => false.obs);
  }

  void toggleSelection(int index) {
    isSelectedList[index].value = !isSelectedList[index].value;
  }

  final List<String> foodType = [
    'https://res.cloudinary.com/dhceioavi/image/upload/v1749359823/appetizer_mgjyom.png',
    'https://res.cloudinary.com/dhceioavi/image/upload/v1749359824/dessert_jlfn7h.png',
    'https://res.cloudinary.com/dhceioavi/image/upload/v1749359823/soup_mbvceo.png',
  ];

  final List<String> label = [
    'Appetizer, Sandwich, salad',
    'Desserts',
    'Soup, Sauce',
  ];

  //?Methods

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
  // void getStoresStream() {
  //   try {
  //     isLoadingStores.value = true;
  //     hasErrorStores.value = false;

  //     stores.bindStream(
  //       firestore.collection('stores').snapshots().map((query) {
  //         final results =
  //             query.docs.map((doc) {
  //               final data = doc.data();
  //               data['id'] = doc.id;
  //               return MdlStores.fromMap(data);
  //             }).toList();

  //         isLoadingStores.value = false;
  //         return results;
  //       }),
  //     );
  //   } catch (e) {
  //     debugPrint('\nSTORE ERROR : $e\n');
  //     hasErrorStores.value = true;
  //     isLoadingStores.value = false;
  //   }
  // }
}
