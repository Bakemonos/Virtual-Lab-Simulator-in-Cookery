import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:virtual_lab/Components/custom_button.dart';
import 'package:virtual_lab/Components/custom_svg_picture.dart';
import 'package:virtual_lab/Components/custom_text.dart';
import 'package:virtual_lab/Utils/properties.dart';

class MyFoodChoicesPage extends StatelessWidget {
  const MyFoodChoicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<bool> unlocked = List.generate(3, (index) => false);
    List<String> path = [appetizer, desserts, soups];
    List<String> label = [
      'Appetizer, Sandwich, salad',
      'Desserts',
      'Soup, Sauce',
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
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
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      top: 8.w,
                      bottom: 8.sp,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 24.w,
                        right: 14.w,
                        top: 34.h,
                        bottom: 8.h,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: Row(
                          spacing: 24.w,
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(3, (index) {
                            unlocked[0] = true;
                            return foodChoices(
                              unlocked: unlocked[index],
                              path: path[index],
                              label: label[index],
                            );
                          }),
                        ),
                      ),
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
                    child: MyText(
                      text: 'CHOICES',
                      color: textLight,
                      fontWeight: FontWeight.w700,
                      size: 28.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget foodChoices({
    required String path,
    required String label,
    required bool unlocked,
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
                          child: MySvgPicture(
                            path: path,
                            iconSize: double.infinity,
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
                  onTap: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
