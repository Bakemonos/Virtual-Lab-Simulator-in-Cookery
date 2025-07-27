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
import 'package:virtual_lab/utils/properties.dart';
import 'package:virtual_lab/utils/routes.dart';

class MyFoodChoicesPage extends StatefulWidget {
  const MyFoodChoicesPage({super.key});

  @override
  State<MyFoodChoicesPage> createState() => _MyFoodChoicesPageState();
}

class _MyFoodChoicesPageState extends State<MyFoodChoicesPage> {
  final controller = AppController.instance;

  @override
  Widget build(BuildContext context) {
    final List<bool> unlocked = [true, false, false];

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
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(3, (index) {
                            var data = foodMenu[index];

                            return Padding(
                              padding: EdgeInsets.only(
                                right: index != 2 ? 24.w : 0,
                              ),
                              child: foodChoices(
                                index: index,
                                instructionFunction: () => controller.instruction(context, data),
                                onTap: () async {
                                  if (controller.foodLoading[index]) return;

                                  controller.foodLoading[index] = true;

                                  controller.tap = true;
                                  debugPrint('\n SELECTED : ${data.menu}\n');
                                  controller.typeSelected = data;

                                  await controller.getInventory(context);

                                  controller.tap = false;
                                  controller.foodLoading[index] = false;
                                },
                                unlocked: unlocked[index],
                                path: data.path,
                                label: data.label,
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                  MyHeader(text: 'CHOICES'),
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
    required bool unlocked,
    required Function() onTap,
    required Function() instructionFunction,
    required int index,
  }) {
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
                                  placeholder:
                                      (context, url) => ShimmerSkeletonLoader(),
                                  errorWidget:
                                      (context, url, error) =>
                                          Icon(Icons.error),
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
                                      backgroundColor: WidgetStatePropertyAll(
                                        backgroundColor,
                                      ),
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
                child: Obx(()=> MyButton(
                  loading: controller.foodLoading[index],
                  borderColor: unlocked ? null : redDark,
                  gradientColor: unlocked ? null : [redLighter, redLighter],
                  text: unlocked ? 'Play' : 'Locked',
                  onTap: unlocked ? onTap : () {},
                ))
              ),
            ),
          ),
        ],
      ),
    );
  }
}
