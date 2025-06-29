//Flutter Package
import 'package:get/get.dart';
import 'package:virtual_lab/Controllers/notifiers.dart';
import 'package:virtual_lab/Utils/helper.dart';

class GeneralBindings extends Bindings {
  @override
  Future dependencies() async {
    Get.lazyPut(() => AppController());
    Get.lazyPut(() => Helper());
  }
}
