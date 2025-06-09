import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:virtual_lab/Components/custom_svg.dart';
import 'package:virtual_lab/Utils/properties.dart';

class AppController extends GetxController {
  static AppController get instance => Get.find();

  //?Initialize
  final player = AudioPlayer();

  final soundToggle = true.obs;
  final musicToggle = true.obs;

  // //? STORES
  // final stores = <MdlStores>[].obs;
  // final isLoadingStores = false.obs;
  // final hasErrorStores = false.obs;

  //? COLLECTION

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
