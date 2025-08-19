import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_lab/Json/tools.dart';
import 'package:virtual_lab/components/custom_dropdown.dart';
import 'package:virtual_lab/components/custom_svg.dart';
import 'package:virtual_lab/components/custom_text.dart';
import 'package:virtual_lab/components/custom_textfield.dart';
import 'package:virtual_lab/components/custom_dalog.dart';
import 'package:virtual_lab/components/shimmer.dart';
import 'package:virtual_lab/json/equipments.dart';
import 'package:virtual_lab/json/food_menu.dart';
import 'package:virtual_lab/models/food_menu_model.dart';
import 'package:virtual_lab/models/grade_model.dart';
import 'package:virtual_lab/models/ingredients_model.dart';
import 'package:virtual_lab/models/progress_model.dart';
import 'package:virtual_lab/models/user_model.dart';
import 'package:virtual_lab/services/services.dart';
import 'package:virtual_lab/utils/effects.dart';
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
    _loadSettings();
    super.onClose();
  }

  //? VARIABLE
  late Animation<double> animation;
  late List<RxBool> selectedList;
  Timer? _timer;

  final platingImageUrl = ''.obs;

  //? RX VARIABLE
  final category = ''.obs;
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

  final typeErrorText = ''.obs;
  final dishNameErrorText = ''.obs;

  final appName = ''.obs;
  final packageName = ''.obs;
  final version = ''.obs;
  final buildNumber = ''.obs;

  var isSelectedList = <RxBool>[].obs;
  final ingredientLimit = 15.obs;
  var seconds = 30.obs;

  final loader = false.obs;
  final bagToggle = false.obs;
  final equipmentToggle = false.obs;
  final actionListToggle = false.obs;
  final actionToggle = false.obs;
  final toolListToggle = false.obs;
  final changeToolToggle = false.obs;
  final platingOptionToggle = false.obs;
  final removeToggle = false.obs;
  final hiderToggle = false.obs;
  bool tap = false;
  
  RxList<bool> foodLoading = List.generate(foodMenu.length, (_) => false).obs;

  //? TEXT CONTROLLER
  // final emailController = TextEditingController();
  // final passwordController = TextEditingController();
    final emailController = TextEditingController(text: 'ricojay@gmail.com');
  final passwordController = TextEditingController(text: 'password');
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final lrnController = TextEditingController();
  final changePasswordController = TextEditingController();
  final nameDishController = TextEditingController();

  //? SUBMITTED COC DATA
  RxList<SubmitedCocModel> submittedCocList = <SubmitedCocModel>[].obs;

  //? USER DATA
  Rx<UserModel> userData = UserModel.empty().obs;
 
  //? USER INVENTORY DATA
  Rx<InventoryModel> typeInventory = InventoryModel.empty().obs;

  //? DISH
  Rx<SubmitedCocModel> selectedDish = SubmitedCocModel.empty().obs;

  //? GRADE
  Rx<GradeModel> grade = GradeModel.empty().obs;

  //? PROGRESS
  Rx<ProgressModel> progress = ProgressModel.empty().obs;

  //? DRAG & DROP
  Rx<IngredientsModel> ingredientDragDropData = IngredientsModel.empty().obs;
  final currentActions = <ActionType>[].obs;

  //? DRAG & DROP
  final selectedTools = <ToolType>[].obs;

  //? INGREDIENT SELECTION
  final ingredientsData = <IngredientsModel>[].obs;

  //? TYPE
  // FoodMenuModel? typeSelected;
  final typeSelected = Rxn<FoodMenuModel>(); 

  //? HOLD INGREDIENTS INFORMATION 
  Rx<IngredientsModel> ingredientActionData = IngredientsModel.empty().obs;
  RxList<ActionsModel> actionHistory = <ActionsModel>[].obs;
  RxList<ActionsModel> selectedActions = <ActionsModel>[].obs;

  //? HOLD PRERARED INFORMATION
  Rx<InventoryModel> preparedData = InventoryModel.empty().obs;
  RxList<IngredientsModel> preparedIngredients = <IngredientsModel>[].obs;

  //? HOLD ACTIONS / TOOLS
  final Rxn<ActionType> pendingAction = Rxn();  
  final Rxn<ToolType> pendingTool = Rxn();  
  
  //? EQUIPMENTS 
  RxList<EquipmentsModel> equipmentData = <EquipmentsModel>[].obs;
  Rx<EquipmentsModel> cookingToolData = cookingEquipment[0].obs;

  late FoodMenuModel selectedMenu;

  var selectedOption = 'plates'.obs;

  var soundEffectsEnabled = true.obs;

  void toggleSoundEffects() {
    soundEffectsEnabled.value = !soundEffectsEnabled.value;
  } 

  final soundToggle = true.obs;
  final musicToggle = true.obs;

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    soundToggle.value = prefs.getBool('soundToggle') ?? true;
    musicToggle.value = prefs.getBool('musicToggle') ?? true;
  }

  Future<void> setSoundToggle(bool value) async {
    soundToggle.value = value;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('soundToggle', value);
  }

  Future<void> setMusicToggle(bool value) async {
    musicToggle.value = value;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('musicToggle', value);
  }
  
  Future<void> loadSettingsIfNeeded() async {
    if (!_settingsLoaded) {
      final prefs = await SharedPreferences.getInstance();
      soundToggle.value = prefs.getBool('soundToggle') ?? true;
      musicToggle.value = prefs.getBool('musicToggle') ?? true;
      _settingsLoaded = true;
    }
  }

  bool _settingsLoaded = false;

  
  //! METHODS ---------------------------------------------------------------------------------------------------------------

  //? ADD INGREDIENTS ACTIONS 
  void actionPerform(BuildContext context) {
    final status = handleTap(context).name;

    final newAction = ActionsModel(
      status: status,
      action: pendingAction.value!.name,
      tool: pendingTool.value!.name,
    );

    final alreadyExists = selectedActions.any((action) =>
      action.status == newAction.status &&
      action.action == newAction.action &&
      action.tool == newAction.tool
    );

    if (!alreadyExists) {
      selectedActions.add(newAction);
    }

    final ingredient = ingredientDragDropData.value;

    final updatedIngredient = IngredientsModel(
      name: ingredient.name,
      image: ingredient.image,
      category: ingredient.category,
      actions: selectedActions.toList(),
    );

    ingredientActionData.value = updatedIngredient;

    debugPrint('\nACTIONS (${updatedIngredient.name}): ${updatedIngredient.actions.length}\n');

    pendingAction.value = null;
    actionToggle.value = false;
  }

  //? ACCEPT INGREDIENTS 
  void acceptIngredient({
    required String type,
    required String studentId,
    required String take,
  }) {

    final currentIngredient = ingredientActionData.value.copyWith(used: cookingToolData.value);
    
    if (currentIngredient.name.isEmpty) return;

    preparedIngredients.removeWhere((i) =>
      i.name == currentIngredient.name && i.image == currentIngredient.image);

    preparedIngredients.add(currentIngredient.copyWith());

    final newData = InventoryModel(
      type: type,
      studentId: studentId,
      take: take,
      ingredients: preparedIngredients.toList(),
    );

    preparedData.value = newData;

    debugPrint('\nACCEPTED INGREDIENT: ${currentIngredient.name} with ${currentIngredient.actions.length} actions');
    debugPrint('Total accepted ingredients: ${preparedData.value.ingredients.length}\n');
    
    ingredientDragDropData.value = IngredientsModel.empty();
    ingredientActionData.value = IngredientsModel.empty();
    selectedActions.clear();
  }

  ActionStatus handleTap(BuildContext context) {
    actionToggle.value = false;
    final barHeight = context.size?.height ?? 100.h;
    final greenZoneHeight = 16.h;

    final centerStart = (barHeight / 2) - (greenZoneHeight / 2);
    final centerEnd = (barHeight / 2) + (greenZoneHeight / 2);

    final cursorY = animation.value * barHeight;

    if (cursorY >= centerStart && cursorY <= centerEnd) {
      return ActionStatus.perfect;
    } else if ((cursorY - centerStart).abs() < 10.h || (cursorY - centerEnd).abs() < 10.h) {
      return ActionStatus.good;
    } else {
      return ActionStatus.bad;
    }
  }
  
  void resetLoading() {
    for (int i = 0; i < foodLoading.length; i++) {
      foodLoading[i] = false;
    }
  }

  void discard() {
    actionToggle.value  = false; //? HIDE ACTION
    actionListToggle.value = false; //? HIDE ACTION LIST
    toolListToggle.value = false; //? HIDE TOOL LIST

    //? EQUIPMENT
    equipmentData.clear();
    equipmentToggle.value = false; 

    //? COOKING TOOLS
    changeToolToggle.value = false;

    currentActions.clear();
    ingredientActionData.value = IngredientsModel.empty();
    ingredientDragDropData.value = IngredientsModel.empty();
  }

  void updateActionsList(IngredientsModel ingredient) {
    final ingredientType = helper.stringToIngredientType(ingredient.category.toLowerCase());

    final actions = getActionsForIngredient(ingredientType);
    
    currentActions.value = actions;
  }

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
        loader.value = false;
        userData.value = UserModel.empty();
        context.go(Routes.signIn);
      },
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
    dishNameErrorText.value = '';
    typeErrorText.value = '';
  }

  void submitResetErrorHandler(){
    category.value = '';
    nameDishController.clear();
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

  void errorHandlerSSubmitDish() {
    if (category.value.isEmpty) {
      typeErrorText.value = 'Type is required';
    } else {
      typeErrorText.value = '';
    }

    if (nameDishController.text.isEmpty) {
      dishNameErrorText.value = 'Dish name is required';
    } else {
      dishNameErrorText.value = '';
    }
  }

  void errorHandlerSignup() {
    emailErrorText.value = emailController.text.isEmpty ? 'Email is required' : '';
    passwordErrorText.value = passwordController.text.isEmpty ? 'Password is required' : '';
    changePasswordErrorText.value = changePasswordController.text.isEmpty ? 'Confirm Password is required' : '';
    lrnErrorText.value = lrnController.text.isEmpty ? 'LRN is required' : '';
    firstnameErrorText.value = firstnameController.text.isEmpty ? 'First Name is required' : '';
    lastnameErrorText.value = lastnameController.text.isEmpty ? 'Last Name is required' : '';
    gradeLevelErrorText.value = gradeLevel.value.isEmpty ? 'Grade Level is required' : '';
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
    actionListToggle.value = !actionListToggle.value;
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

  void resetTimer([int startFrom = 30]) {
    seconds.value = startFrom;
    stopTimer();
  }

  void initializeSelection(int itemCount) {
    isSelectedList.value = List.generate(itemCount, (_) => false.obs);
  }

  void changeToolToggler() {
    changeToolToggle.value = !changeToolToggle.value;
  }

  void platingOptionToggler() {
    platingOptionToggle.value = !platingOptionToggle.value;
  }

  void removeToggler() {
    removeToggle.value = !removeToggle.value;
  }

  void hiderToggler() {
    hiderToggle.value = !hiderToggle.value;
  }

  void toggleSelection(int index) {
    isSelectedList[index].value = !isSelectedList[index].value;
  }

  // void playClickSound() async {
  //   await player.play(AssetSource(clickEffect1));
  // }

  //! WIDGET ----------------------------------------------------------------------------------------------------------------

  void showFloatingSnackbar({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: textLight,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        content: MyText(text: message, fontWeight: FontWeight.w400),
        margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  BoxDecoration designUI({Color? backGround = lightBrown}) {
    return BoxDecoration(
      color: backGround,
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(width: 2.w, color: darkBrown),
    );
  }

  Widget actionButton({
    required String text,
    required void Function() onPressed,
  }) {
    return SizedBox(
      height: 32.h,
      child: TextButton(
        style: TextButton.styleFrom(backgroundColor: backgroundColor),
        onPressed: onPressed,
        child: MyText(text: text, size: 14.sp),
      ),
    );
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
          SoundEffects.playEffect();
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
    RxString? errorText,
    TextEditingController? controller,
    bool obscureText = false,
    Color? defaultBorderColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (errorText != null) Obx(() {
              final hasError = errorText.value.isNotEmpty;
              return MyText(
                text: label,
                fontWeight: FontWeight.w600,
                color: hasError ? redLighter : lightBrown,
              );
            })
            else MyText(
              text: label,
              fontWeight: FontWeight.w600,
              color: lightBrown,
            ),
            if (errorText != null) Obx(() {
              final hasError = errorText.value.isNotEmpty;
              return hasError ? Padding(
                  padding: EdgeInsets.only(top: 4.h, left: 8.w),
                  child: MyText(
                    text: '* ${errorText.value}',
                    color: redLighter,
                    fontWeight: FontWeight.w400,
                    size: 14.sp,
                  ),
                )
              : SizedBox.shrink();
            }),
          ],
        ),
        SizedBox(height: 4.h),
        if (errorText != null) Obx(() {
          final hasError = errorText.value.isNotEmpty;
          return MyTextfield(
            controller: controller,
            hint: 'Enter $label',
            obscureText: obscureText,
            error: hasError,
            defaultBorderColor: defaultBorderColor,
          );
        }) else MyTextfield(
          controller: controller,
          hint: 'Enter $label',
          obscureText: obscureText,
          error: false,
          defaultBorderColor: defaultBorderColor,
        ),
      ],
    );
  }

  Widget repeatedDropdown({
    required String label,
    required List<String> items,
    required String hint,
    RxString? errorText,
    String? selectedValue,
    required void Function(String?) onChanged,
    bool hasError = false,
    Color? defaultBorderColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (errorText != null)
              Obx(() {
                final isError = errorText.value.isNotEmpty;
                return MyText(
                  text: label,
                  fontWeight: FontWeight.w600,
                  color: isError ? redLighter : lightBrown,
                );
              })
            else
              MyText(
                text: label,
                fontWeight: FontWeight.w600,
                color: lightBrown,
              ),
            if (errorText != null)
              Obx(() {
                final isError = errorText.value.isNotEmpty;
                return isError
                  ? Padding(
                      padding: EdgeInsets.only(top: 4.h, bottom: 4.h, left: 8.w),
                      child: MyText(
                        text: errorText.value,
                        fontWeight: FontWeight.w400,
                        color: redLighter,
                        size: 14.sp,
                      ),
                    )
                  : SizedBox.shrink();
              }),
          ],
        ),
        SizedBox(height: 4.h),
        MyDropDown(
          hasError: hasError,
          items: items,
          hintText: hint,
          value: selectedValue,
          onChanged: onChanged,
          defaultBorderColor: defaultBorderColor,
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

  void instruction(BuildContext context, FoodMenuModel data) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: 360.w,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.h,
                children: [
                  Row(
                    spacing: 14.w,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(logo, width: 32.w),
                      MyText(text: 'Instruction'),
                      const Spacer(),
                      IconButton(
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll(
                            BeveledRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(4.r),
                            ),
                          ),
                        ),
                        onPressed: () => context.pop(),
                        icon: Container(
                          width: 32.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            color: lightButtonBackground.withValues(alpha: 0.3),
                          ),
                          child: Center(
                            child: MySvgPicture(
                              path: close,
                              iconColor: darkBrown,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        spacing: 12.h,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 12.w,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100.w,
                                child: CachedNetworkImage(
                                  imageUrl: data.path,
                                  placeholder: (context, url) => ShimmerSkeletonLoader(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: MyText(
                                  text: 'Prepare, Present ${data.title}',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 12.h,
                            children: [
                              ...data.instructions.map(
                                (ins) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyText(
                                      text: ins.name,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    ...ins.list.asMap().entries.map(
                                      (entry) => Padding(
                                        padding: EdgeInsets.only(left: 12.w),
                                        child: MyText(
                                          text: '${entry.key + 1}. ${entry.value}',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              MyText(
                                text: data.description,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  MyText(text: 'Have Fun!', fontWeight: FontWeight.w500),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget repeatedIconButton({required String label, required String path, required Function() onPressed}) {
    return Column(
      children: [
        SizedBox(
          height: 60.h,
          child: AspectRatio(
            aspectRatio: 1,
            child: IconButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(WidgetState.pressed)) {
                    return Colors.brown.withValues(alpha: 0.2);
                  }
                  return backgroundColor.withValues(alpha: 0.8); 
                }),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    side: BorderSide(color: darkBrown, width: 2.w),
                  ),
                ),
                padding: WidgetStateProperty.all(EdgeInsets.zero),
                overlayColor: WidgetStateProperty.all(Colors.brown.withValues(alpha: 0.1)),
              ),
              icon: Padding(
                padding: EdgeInsets.all(8.w),
                child: helper.isValidUrl(path)? CachedNetworkImage(
                  imageUrl: path,
                  placeholder: (context, url) => ShimmerSkeletonLoader(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.contain,
                ) : MySvgPicture(path: path),
              ),
              onPressed: onPressed,
            ),
          ),
        ),
        MyText(text: label, color: textLight, size: 14.sp )
      ],
    );
  }
  
  //! SERVICES METHOD -------------------------------------------------------------------------------------------------------

  
} 
