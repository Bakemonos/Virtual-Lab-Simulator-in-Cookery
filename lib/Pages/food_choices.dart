import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/Components/custom_button.dart';
import 'package:virtual_lab/Components/custom_text.dart';
import 'package:virtual_lab/Components/shimmer.dart';
import 'package:virtual_lab/Controllers/notifiers.dart';
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final image in [appetizer, desserts, soups]) {
      precacheImage(AssetImage(image), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<bool> unlocked = [true, false, false];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              height: 340.h,
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
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index != 2 ? 24.w : 0,
                              ),
                              child: foodChoices(
                                onTap: playFunction(index),
                                unlocked: unlocked[index],
                                path: controller.foodType[index],
                                label: controller.label[index],
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        color: lightBrown,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          topRight: Radius.circular(16.r),
                          bottomLeft: Radius.circular(8.r),
                          bottomRight: Radius.circular(8.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: darkBrown,
                            offset: Offset(0, 4),
                            spreadRadius: 0.7,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.w,
                          vertical: 6.h,
                        ),
                        child: const MyText(
                          text: 'CHOICES',
                          color: textLight,
                          fontWeight: FontWeight.w700,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
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
          context.push(Routes.playUI);
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


