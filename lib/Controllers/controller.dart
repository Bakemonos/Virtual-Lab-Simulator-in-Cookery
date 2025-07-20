import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:virtual_lab/Components/customDialog.dart';
import 'package:virtual_lab/Components/customDropdown.dart';
import 'package:virtual_lab/Components/customSvg.dart';
import 'package:virtual_lab/Components/customText.dart';
import 'package:virtual_lab/Components/customTextField.dart';
import 'package:virtual_lab/models/foodMenuModel.dart';
import 'package:virtual_lab/Models/ingredientsModel.dart';
import 'package:virtual_lab/Models/userModel.dart';
import 'package:virtual_lab/services/services.dart';
import 'package:virtual_lab/utils/enum.dart';
import 'package:virtual_lab/utils/helper.dart';
import 'package:virtual_lab/utils/properties.dart';
import 'package:virtual_lab/utils/routes.dart';

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
  late List<RxBool> selectedList;
  Timer? _timer;

  //? RX VARIABLE
  final gender = ''.obs;
  final gradeLevel = ''.obs;

  final emailErrorText = ''.obs;
  final changePasswordErrorText = ''.obs;
  final passwordErrorText = ''.obs;
  final genderErrorText = ''.obs;
  final lrnErrorText = ''.obs;
  final lastnameErrorText = ''.obs;
  final firstnameErrorText = ''.obs;
  final gradeLevelErrorText = ''.obs;

  final appName = ''.obs;
  final packageName = ''.obs;
  final version = ''.obs;
  final buildNumber = ''.obs;

  var isSelectedList = <RxBool>[].obs;
  final ingredientLimit = 10.obs;
  var seconds = 60.obs;

  final soundToggle = true.obs;
  final musicToggle = true.obs;
  final loader = false.obs;
  final bagToggle = false.obs;
  final equipmentToggle = false.obs;
  final actionToggle = false.obs;

  //? TEXT CONTROLLER
  final emailController = TextEditingController();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final lrnController = TextEditingController();
  final passwordController = TextEditingController();
  final changePasswordController = TextEditingController();

  //? USER DATA
  Rx<UserModel> userData = UserModel.empty().obs;

  //? USER INVENTORY DATA
  Rx<InventoryModel> typeInventory = InventoryModel.empty().obs;

  //? DRAG & DROP
  Rx<IngredientsModel> ingredientDragDropData = IngredientsModel.empty().obs;
  final currentActions = <ActionType>[].obs;
  final selectedActionIndex = RxnInt();

  //? INGREDIENT SELECTION
  final ingredientsData = <IngredientsModel>[].obs;

  //? TYPE
  FoodMenuModel? typeSelected;

  void exitDialog(BuildContext context) {
    quickAlertDialog(
      context: context,
      type: QuickAlertType.warning,
      title: 'Exit App',
      message: 'Are you sure you want to quit the game?',
      cancelBtnText: 'Cancel',
      confirmBtnText: 'Quit',
      barrierDismissible: true,
      onConfirmBtnTap: () {
        SystemNavigator.pop();
      },
    );
  }

  void logoutDialog(BuildContext context) {
    quickAlertDialog(
      context: context,
      type: QuickAlertType.warning,
      title: 'Logout',
      message: 'Are you sure you want to log out?',
      cancelBtnText: 'Cancel',
      confirmBtnText: 'Logout',
      showCancelBtn: true,
      onConfirmBtnTap: () {
        userData.value = UserModel.empty();
        context.go(Routes.signIn);
      },
    );
  }

  //! METHODS ---------------------------------------------------------------------------------------------------------------

  void discard() {
    actionToggle.value = false;
    currentActions.clear();
    ingredientDragDropData.value = IngredientsModel.empty();
  }

  void updateActionsList(IngredientsModel ingredient) {
    final ingredientType = helper.stringToIngredientType(
      'meat'.toLowerCase(),
      // ingredient.type.toLowerCase(),
    );
    final actions = getActionsForIngredient(ingredientType);

    currentActions.value = actions;
  }

  BoxDecoration designUI({Color? backGround = lightBrown}) {
    return BoxDecoration(
      color: backGround,
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(width: 2.w, color: darkBrown),
    );
  }

  void resetErrorHandler() {
    emailErrorText.value = '';
    changePasswordErrorText.value = '';
    passwordErrorText.value = '';
    genderErrorText.value = '';
    lrnErrorText.value = '';
    lastnameErrorText.value = '';
    firstnameErrorText.value = '';
    gradeLevelErrorText.value = '';
  }

  void errorHandlerSignin() {
    if (emailController.text.isEmpty) {
      emailErrorText.value = 'Email is required';
    } else {
      emailErrorText.value = '';
    }

    if (passwordController.text.isEmpty) {
      passwordErrorText.value = 'Password is required';
    } else {
      passwordErrorText.value = '';
    }
  }

  void errorHandlerSignup() {
    emailErrorText.value =
        emailController.text.isEmpty ? 'Email is required' : '';

    passwordErrorText.value =
        passwordController.text.isEmpty ? 'Password is required' : '';

    changePasswordErrorText.value =
        changePasswordController.text.isEmpty
            ? 'Confirm Password is required'
            : '';

    lrnErrorText.value = lrnController.text.isEmpty ? 'LRN is required' : '';

    firstnameErrorText.value =
        firstnameController.text.isEmpty ? 'First Name is required' : '';

    lastnameErrorText.value =
        lastnameController.text.isEmpty ? 'Last Name is required' : '';

    gradeLevelErrorText.value =
        gradeLevel.value.isEmpty ? 'Grade Level is required' : '';

    genderErrorText.value = gender.value.isEmpty ? 'Gender is required' : '';
  }

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

  void bagOntap() {
    bagToggle.value = !bagToggle.value;
  }

  void actionOnTap(IngredientsModel ingredient) {
    updateActionsList(ingredient);
    actionToggle.value = !actionToggle.value;
  }

  void equipmentOntap() {
    equipmentToggle.value = !equipmentToggle.value;
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

  //! WIDGET ----------------------------------------------------------------------------------------------------------------

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
    required TextEditingController controller,
    required RxString errorText,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 8.w,
          children: [
            Obx(
              () => MyText(
                text: label,
                fontWeight: FontWeight.w600,
                color: errorText.value.isNotEmpty ? redLighter : lightBrown,
              ),
            ),
            Obx(
              () =>
                  errorText.value.isNotEmpty
                      ? Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: MyText(
                          text: '* ${errorText.value}',
                          color: redLighter,
                          fontWeight: FontWeight.w400,
                          size: 14.sp,
                        ),
                      )
                      : SizedBox.shrink(),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Obx(
          () => MyTextfield(
            controller: controller,
            hint: 'Enter $label',
            obscureText: obscureText,
            error: errorText.value.isNotEmpty,
          ),
        ),
      ],
    );
  }

  Widget repeatedDropdown({
    required String label,
    required List<String> items,
    required String hint,
    required RxString errorText,
    required String? selectedValue,
    required void Function(String?) onChanged,
    bool? hasError = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 8.w,
          children: [
            Obx(
              () => MyText(
                text: label,
                fontWeight: FontWeight.w600,
                color: errorText.value.isNotEmpty ? redLighter : lightBrown,
              ),
            ),
            Obx(
              () =>
                  errorText.value.isNotEmpty
                      ? Padding(
                        padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
                        child: MyText(
                          text: errorText.value,
                          fontWeight: FontWeight.w400,
                          color: redLighter,
                          size: 14.sp,
                        ),
                      )
                      : SizedBox.shrink(),
            ),
          ],
        ),
        MyDropDown(
          hasError: hasError!,
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

  //! SERVICES METHOD -------------------------------------------------------------------------------------------------------

  //? SIGN UP
  Future<void> signup(BuildContext context) async {
    loader.value = true;
    try {
      final data = UserModel(
        lrn: lrnController.text,
        firstName: firstnameController.text,
        lastName: lastnameController.text,
        email: emailController.text,
        gender: gender.value,
        password: passwordController.text,
        gradeLevel: gradeLevel.value,
        status: 'pending',
      );

      debugPrint('\nData : ${data.toJson()}\n');

      final response = await db.post('student/create', data.toJson());

      if (response.success!) {
        loader.value = false;
        debugPrint('SUCCESS : ${response.message}');

        if (context.mounted) {
          quickAlertDialog(
            context: context,
            type: QuickAlertType.success,
            title: 'Account Created!',
            message: response.message.toString(),
            onConfirmBtnTap: () {
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
        quickAlertDialog(
          context: context,
          type: QuickAlertType.error,
          title: 'Sign up Failed!',
          message: errorMessage,
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
          quickAlertDialog(
            context: context,
            type: QuickAlertType.success,
            title: 'Login Successful!',
            message: response.message.toString(),
            onConfirmBtnTap: () {
              resetSignin();
              userData.value = UserModel.fromJson(response.data!);
              context.go(Routes.menu);
            },
          );
        }
      }
    } catch (e) {
      loader.value = false;
      final errorMessage = helper.getErrorMessage(e);
      if (context.mounted) {
        quickAlertDialog(
          context: context,
          type: QuickAlertType.error,
          title: 'Login Failed!',
          message: errorMessage,
        );
      }
      debugPrint('Error: $e');
    }
  }

  //? INVENTORY PICKED
  Future<void> ingredientsCreate(
    BuildContext context,
    InventoryModel data,
  ) async {
    loader.value = true;
    try {
      final response = await db.post('inventory/create', data.toJson());

      if (response.success!) {
        loader.value = false;
        debugPrint('SUCCESS : ${response.message}');

        if (context.mounted) {
          quickAlertDialog(
            context: context,
            type: QuickAlertType.success,
            title: 'Success Created!',
            message: response.message.toString(),
            onConfirmBtnTap: () {
              context.go(Routes.playUI);
            },
          );
        }
      } else {
        debugPrint('FAILED : ${response.message}');
      }
    } catch (e) {
      loader.value = false;
      final errorMessage = helper.getErrorMessage(e);
      if (context.mounted) {
        quickAlertDialog(
          context: context,
          type: QuickAlertType.error,
          title: 'Create Failed!',
          message: errorMessage,
        );
      }
      debugPrint('Error: $e');
    }
  }

  //? GET INVENTORY
  Future<void> getInventory(BuildContext context) async {
    loader.value = true;
    try {
      final studentId = userData.value.id;
      final coc = typeSelected!.menu;
      final type = 'take_one';

      final response = await db.get(
        'inventory/read/$studentId/?type=$coc&take=$type',
      );

      if (response.success!) {
        loader.value = false;
        debugPrint('RESPONSE SUCCESS: ${response.success}');
        if (response.data != null && context.mounted) {
          context.go(Routes.playUI);
          try {
            typeInventory.value = InventoryModel.fromJson(response.data!);
          } catch (e) {
            debugPrint('PARSING ERROR: $e');
          }
        } else {
          debugPrint('DATA IS NULL');
          typeInventory.value = InventoryModel.empty();
        }
      } else {
        debugPrint('FAILED : ${response.message}');
      }
    } catch (e, stacktrace) {
      loader.value = false;
      final errorMessage = helper.getErrorMessage(e);
      debugPrint('Error: $errorMessage');
      debugPrint('STACKTRACE: $stacktrace');
    }
  }
}
