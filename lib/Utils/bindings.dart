//Flutter Package
import 'package:get/get.dart';
import 'package:virtual_lab/Controllers/notifiers.dart';

class GeneralBindings extends Bindings {
  @override
  Future dependencies() async {
    Get.lazyPut(() => AppController());
  }
}
