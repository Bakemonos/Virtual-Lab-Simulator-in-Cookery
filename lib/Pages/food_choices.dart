import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/Components/custom_button.dart';
import 'package:virtual_lab/Components/custom_header.dart';
import 'package:virtual_lab/Components/custom_svg_picture.dart';
import 'package:virtual_lab/Components/custom_text.dart';
import 'package:virtual_lab/Components/shimmer.dart';
import 'package:virtual_lab/Controllers/notifiers.dart';
import 'package:virtual_lab/Models/food_type_model.dart';
import 'package:virtual_lab/Utils/properties.dart';
import 'package:virtual_lab/Utils/routes.dart';

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
                            var data = foodType[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index != 2 ? 24.w : 0,
                              ),
                              child: foodChoices(
                                instructionFunction: () => instruction(data),
                                onTap: playFunction(index),
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

  playFunction(int index) {
    switch (index) {
      case 1:
        return () {};
      case 2:
        return () {};
      default:
        return () {
          context.push(Routes.ingredientsSelection);
        };
    }
  }

  void instruction(FoodTypeModel data) {
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
                                  placeholder:
                                      (context, url) => ShimmerSkeletonLoader(),
                                  errorWidget:
                                      (context, url, error) =>
                                          Icon(Icons.error),
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
                                          text:
                                              '${entry.key + 1}. ${entry.value}',
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

  Widget foodChoices({
    required String path,
    required String label,
    required bool unlocked,
    required Function() onTap,
    required Function() instructionFunction,
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
                child: MyButton(
                  borderColor: unlocked ? null : redDark,
                  gradientColor: unlocked ? null : [redLighter, redLighter],
                  text: unlocked ? 'Play' : 'Locked',
                  onTap: unlocked ? onTap : () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
