import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/Components/customSvg.dart';
import 'package:virtual_lab/Components/customText.dart';
import 'package:virtual_lab/Components/customTextField.dart';
import 'package:virtual_lab/Models/userModel.dart';
import 'package:virtual_lab/Services/services.dart';
import 'package:virtual_lab/Utils/properties.dart';
import 'package:virtual_lab/Utils/routes.dart';

class AppController extends GetxController {
  static AppController get instance => Get.find();
  static ApiServices get db => Get.find();

  //?Initialize
  final player = AudioPlayer();

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  //? VARIABLE

  //? RX VARIABLE
  var isSelectedList = <RxBool>[].obs;
  late List<RxBool> selectedList;
  final soundToggle = true.obs;
  final musicToggle = true.obs;
  final loader = false.obs;
  var seconds = 60.obs;
  Timer? _timer;

  final ingredientLimit = 10.obs;
  final bagToggle = false.obs;

  //? USER DATA
  Rx<UserModel> userData =
      UserModel(
        id: '',
        lrn: '',
        firstName: '',
        lastName: '',
        email: '',
        gender: '',
        password: '',
        gradeLevel: '',
        status: '',
      ).obs;

  //? TEXT CONTROLLER
  final emailController = TextEditingController();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final lrnController = TextEditingController();
  final genderController = TextEditingController();
  final gradeLevelController = TextEditingController();
  final passwordController = TextEditingController();

  void resetSignup() {
    lrnController.clear();
    firstnameController.clear();
    lastnameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  void resetSignin() {
    emailController.clear();
    passwordController.clear();
  }

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

  //? SERVICES
  Future<void> signup(BuildContext context) async {
    try {
      final data = {
        'lrn': lastnameController.text,
        'firstName': firstnameController.text,
        'lastName': lastnameController.text,
        'email': emailController.text,
        'gender': genderController.text,
        'gradeLevel': gradeLevelController.text,
        'password': passwordController.text,
        'status': 'pending',
      };

      final response = await db.post('student/create', data);

      if (response.success!) {
        debugPrint('SUCCESS : ${response.message}');
        userData.value = UserModel.fromJson(response.data);
        if (context.mounted) context.go(Routes.signIn);
        resetSignup();
      } else {
        debugPrint('FAILED : ${response.message}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  //? SERVICES
  Future<void> signin(BuildContext context) async {
    try {
      final data = {
        'email': emailController.text,
        'password': passwordController.text,
      };

      final response = await db.post('auth/loginStudent', data);

      if (response.success!) {
        debugPrint('SUCCESS : ${response.message}');
        userData.value = UserModel.fromJson(response.data);
        if (context.mounted) context.go(Routes.menu);
        resetSignin();
      } else {
        debugPrint('FAILED : ${response.message}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void logout(BuildContext context) {
    userData.value = UserModel.empty();
    context.go(Routes.signIn);
  }
}
