//Flutter Package
import 'package:get/get.dart';
import 'package:virtual_lab/Controllers/controller.dart';
import 'package:virtual_lab/services/services.dart';
import 'package:virtual_lab/utils/helper.dart';

class GeneralBindings extends Bindings {
  @override
  Future dependencies() async {
    Get.lazyPut(() => AppController());
    Get.lazyPut(() => Helper());
    Get.lazyPut(() => ApiServices());
  }
}
