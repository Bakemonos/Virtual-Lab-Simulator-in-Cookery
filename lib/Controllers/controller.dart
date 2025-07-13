import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/Components/customDialog.dart';
import 'package:virtual_lab/Components/customDropdown.dart';
import 'package:virtual_lab/Components/customSvg.dart';
import 'package:virtual_lab/Components/customText.dart';
import 'package:virtual_lab/Components/customTextField.dart';
import 'package:virtual_lab/Models/userModel.dart';
import 'package:virtual_lab/Services/services.dart';
import 'package:virtual_lab/Utils/helper.dart';
import 'package:virtual_lab/Utils/properties.dart';
import 'package:virtual_lab/Utils/routes.dart';

class AppController extends GetxController {
  static AppController get instance => Get.find();
  static ApiServices get db => Get.find();
  static Helper get helper => Get.find();

  //?Initialize
  final player = AudioPlayer();

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  //? VARIABLE
  final gender = ''.obs;
  final gradeLevel = ''.obs;

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

  final appName = ''.obs;
  final packageName = ''.obs;
  final version = ''.obs;
  final buildNumber = ''.obs;

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
  final passwordController = TextEditingController();

  void resetSignup() {
    lrnController.clear();
    firstnameController.clear();
    lastnameController.clear();
    emailController.clear();
    gender.value = '';
    gradeLevel.value = '';
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
    bool? obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4.h,
      children: [
        MyText(text: label, fontWeight: FontWeight.w600),
        MyTextfield(
          obscureText: obscureText,
          controller: controller,
          hint: 'Enter $label',
        ),
      ],
    );
  }

  Widget repeatedDropdown({
    required String label,
    required List<String> items,
    required String hint,
    String? selectedValue,
    void Function(String?)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4.h,
      children: [
        MyText(text: label, fontWeight: FontWeight.w600),
        MyDropDown(
          items: items,
          hintText: hint,
          value: selectedValue,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget repeatedInformation({required String label, required String value}) {
    return Row(
      spacing: 4.h,
      children: [
        MyText(text: '$label :', fontWeight: FontWeight.w600),
        MyText(text: value, fontWeight: FontWeight.w400),
      ],
    );
  }

  //? SERVICES

  //? SIGN UP
  Future<void> signup(BuildContext context) async {
    loader.value = true;
    try {
      final data = {
        'lrn': lrnController.text,
        'firstName': firstnameController.text,
        'lastName': lastnameController.text,
        'email': emailController.text,
        'gender': gender.value,
        'gradeLevel': gradeLevel.value,
        'password': passwordController.text,
        'status': 'pending',
      };

      debugPrint('\nData : $data\n');

      final response = await db.post('student/create', data);

      if (response.success!) {
        loader.value = false;
        debugPrint('SUCCESS : ${response.message}');

        if (context.mounted) {
          showSuccessDialog(
            context: context,
            title: 'Account Created!',
            message: 'Your account has been successfully created.',
            onConfirm: () {
              context.go(Routes.signIn);
            },
          );
        }

        resetSignup();
      } else {
        debugPrint('FAILED : ${response.message}');
      }
    } catch (e) {
      loader.value = false;
      final errorMessage = helper.getErrorMessage(e);
      if (context.mounted) {
        showSuccessDialog(
          context: context,
          title: 'Sign up Failed!',
          message: errorMessage,
          onConfirm: () {
            context.pop();
          },
        );
      }
      debugPrint('Error: $e');
    }
  }

  //? SIGN IN
  Future<void> signin(BuildContext context) async {
    loader.value = true;
    try {
      final data = {
        'email': emailController.text,
        'password': passwordController.text,
      };

      final response = await db.post('auth/loginStudent', data);

      if (response.success!) {
        loader.value = false;
        debugPrint('SUCCESS : ${response.message}');

        if (context.mounted) {
          showSuccessDialog(
            context: context,
            title: 'Login Successful!',
            message: response.message.toString(),
            onConfirm: () {
              userData.value = UserModel.fromJson(response.data);
              context.go(Routes.menu);
            },
          );
        }

        resetSignin();
      }
    } catch (e) {
      loader.value = false;
      final errorMessage = helper.getErrorMessage(e);
      if (context.mounted) {
        showSuccessDialog(
          context: context,
          title: 'Login Failed!',
          message: errorMessage,
          onConfirm: () {
            context.pop();
          },
        );
      }
      debugPrint('Error: $e');
    }
  }

  void logout(BuildContext context) {
    userData.value = UserModel.empty();
    context.go(Routes.signIn);
  }
}
