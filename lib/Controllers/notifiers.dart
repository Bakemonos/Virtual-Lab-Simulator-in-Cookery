import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:virtual_lab/Utils/properties.dart';

class AppController extends GetxController {
  static AppController get instance => Get.find();

  //?Initialize

  final player = AudioPlayer();

  void playClickSound() async {
    await player.play(AssetSource(clickEffect1));
  }

  final soundToggle = true.obs;
  final musicToggle = true.obs;

  // //? STORES
  // final stores = <MdlStores>[].obs;
  // final isLoadingStores = false.obs;
  // final hasErrorStores = false.obs;

  //?Methods
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
