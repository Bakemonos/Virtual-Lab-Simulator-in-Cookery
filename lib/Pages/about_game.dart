import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/Components/custom_text.dart';
import 'package:virtual_lab/Controllers/notifiers.dart';
import 'package:virtual_lab/Utils/properties.dart';

class MyAboutGamePage extends StatelessWidget {
  const MyAboutGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppController.instance;

    return Scaffold(
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
                      width: 500.w,
                      decoration: BoxDecoration(
                        color: lightBrown,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 16.w,
                          right: 16.w,
                          top: 12.w,
                          bottom: 20.sp,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: foregroundColor,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 24.w,
                              right: 14.w,
                              top: 34.h,
                              bottom: 8.h,
                            ),
                            child: ScrollbarTheme(
                              data: ScrollbarThemeData(
                                thumbColor: WidgetStateProperty.all(darkBrown),
                              ),
                              child: Scrollbar(
                                thumbVisibility: true,
                                thickness: 4.w,
                                radius: Radius.circular(10.r),
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.w),
                                    child: Column(
                                      spacing: 8.h,
                                      children: [
                                        MyText(
                                          text: 'Welcome to Cooking Master!',
                                          fontWeight: FontWeight.w600,
                                          size: 24.sp,
                                        ),
                                        MyText(
                                          text:
                                              'In this fun and educational game, you\'ll learn how to prepare delicious meals from around the world. Follow recipe s, manage ingredients, and become the ultimate kitchen pro!',
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.w500,
                                          size: 18.sp,
                                        ),
                                        MyText(
                                          text:
                                              'Version: 1.0.0\nLast Updated: May 2025\nBuild: 2025-05-25\nDevelopers: Rico Jay & Carlo\nSupport: support@cookingmaster.com',
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.w500,
                                          textHeight: 2,
                                          size: 18.sp,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
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
                          text: 'ABOUT GAME',
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
          controller.floatingButton(
            context: context,
            onTap: () {
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
