import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/components/custom_button.dart';
import 'package:virtual_lab/components/custom_header.dart';
import 'package:virtual_lab/components/custom_svg_picture.dart';
import 'package:virtual_lab/components/custom_text.dart';
import 'package:virtual_lab/components/shimmer.dart';
import 'package:virtual_lab/controllers/controller.dart';
import 'package:virtual_lab/json/food_menu.dart';
import 'package:virtual_lab/services/services.dart';
import 'package:virtual_lab/utils/properties.dart';
import 'package:virtual_lab/utils/routes.dart';

class MyFoodChoicesPage extends StatefulWidget {
  const MyFoodChoicesPage({super.key});

  @override
  State<MyFoodChoicesPage> createState() => _MyFoodChoicesPageState();
}

class _MyFoodChoicesPageState extends State<MyFoodChoicesPage> {
  final controller = AppController.instance;
  final db = ApiServices.instance;

  List<String> get buttonStates {
    final progress = controller.progress.value;

    String normalize(String? status) {
      return status?.toLowerCase() ?? "";
    }

    final coc1Status = normalize(progress.coc1);
    final coc2Status = normalize(progress.coc2);
    final coc3Status = normalize(progress.coc3);

    String coc1State = coc1Status == "completed" ? "complete" : "playable";

    String coc2State = coc1Status == "completed"
        ? (coc2Status == "completed" ? "complete" : "playable")
        : "locked";

    String coc3State = coc2Status == "completed"
        ? (coc3Status == "completed" ? "complete" : "playable")
        : "locked";

    return [coc1State, coc2State, coc3State];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: 24.h),
                      height: 340.h,
                      decoration: BoxDecoration(
                        color: lightBrown,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(24.w, 40.h, 24.w, 8.h),
                        child: Obx(() {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(3, (index) {
                              var data = foodMenu[index];

                              return Padding(
                                padding: EdgeInsets.only(
                                  right: index != 2 ? 24.w : 0,
                                ),
                                child: foodChoices(
                                  index: index,
                                  instructionFunction: () =>
                                      controller.instruction(context, data),
                                  onTap: () async {
                                    if (controller.foodLoading[index]) return;

                                    controller.foodLoading[index] = true;
                                    controller.tap = true;

                                    debugPrint('\n SELECTED : ${data.menu}\n');
                                    controller.typeSelected.value = data;

                                    await db.getDish(context,
                                        type: data.menu);
                                    if (context.mounted) {
                                      await db.getInventory(context);
                                    }

                                    controller.tap = false;
                                    controller.foodLoading[index] = false;
                                  },
                                  state: buttonStates[index],
                                  path: data.path,
                                  label: data.label,
                                ),
                              );
                            }),
                          );
                        }),
                      ),
                    ),
                  ),
                  const MyHeader(text: 'CHOICES'),
                ],
              ),
            ),
          ),
          controller.floatingButton(
            context: context,
            onTap: () {
              context.go(Routes.menu);
            },
          ),
          controller.floatingButton(
            context: context,
            icon: setting,
            isLeft: false,
            onTap: () {
              context.push(Routes.settings);
            },
          ),
        ],
      ),
    );
  }

  Widget foodChoices({
    required String path,
    required String label,
    required String state,
    required Function() onTap,
    required Function() instructionFunction,
    required int index,
  }) {
    bool isComplete = state == "complete";
    bool isLocked = state == "locked";

    return SizedBox(
      width: 180.w,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 24.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: foregroundColor,
              ),
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  spacing: 8.h,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: darkBrown,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Center(
                                child: CachedNetworkImage(
                                  imageUrl: path,
                                  placeholder: (context, url) => ShimmerSkeletonLoader(),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.all(8.w),
                              child: SizedBox(
                                width: 24.w,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: IconButton(
                                    onPressed: instructionFunction,
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(backgroundColor),
                                    ),
                                    icon: Center(
                                      child: MySvgPicture(
                                        path: information,
                                        iconColor: darkBrown,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    MyText(
                      text: label,
                      fontWeight: FontWeight.w500,
                      size: 14.sp,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: SizedBox(
                height: 48.h,
                child: Obx(() => MyButton(
                  loading: controller.foodLoading[index],
                  borderColor: isLocked ? redDark : isComplete? darkYellowColor : null,
                  gradientColor: isLocked
                      ? [redLighter, redLighter]
                      : (isComplete ? [lightYellowColor, darkYellowColor] : null),
                  text: isLocked
                      ? 'Locked'
                      : (isComplete ? 'Completed' : 'Play'),
                  onTap: () {
                    if (isLocked) return;
                    if (isComplete) { 
                       controller.showFloatingSnackbar(
                        context: context,
                        message: 'This stage is already finished!',
                      );
                      return;
                    }
                    onTap(); 
                  },
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
