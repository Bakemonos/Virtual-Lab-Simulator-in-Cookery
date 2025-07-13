import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/Components/customButton.dart';
import 'package:virtual_lab/Components/customHeader.dart';
import 'package:virtual_lab/Components/customText.dart';
import 'package:virtual_lab/Components/shimmer.dart';
import 'package:virtual_lab/Controllers/controller.dart';
import 'package:virtual_lab/Models/foodTypeModel.dart';
import 'package:virtual_lab/Utils/properties.dart';
import 'package:virtual_lab/Utils/routes.dart';

class MyAchievementTypePage extends StatefulWidget {
  const MyAchievementTypePage({super.key});

  @override
  State<MyAchievementTypePage> createState() => _MyAchievementTypePageState();
}

class _MyAchievementTypePageState extends State<MyAchievementTypePage> {
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
                        padding: EdgeInsets.fromLTRB(24.w, 34.h, 24.w, 8.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(3, (index) {
                            var data = foodType[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index != 2 ? 24.w : 0,
                              ),
                              child: foodChoices(
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
                  MyHeader(text: 'ACHIEVEMENT TYPE'),
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
          context.push(Routes.sliderOption);
        };
    }
  }

  Widget foodChoices({
    required String path,
    required String label,
    required bool unlocked,
    required Function() onTap,
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
                  children: [
                    Container(
                      height: 120.h,
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
                                (context, url, error) => Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
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
                child: MyButton(text: 'View', onTap: unlocked ? onTap : () {}),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
