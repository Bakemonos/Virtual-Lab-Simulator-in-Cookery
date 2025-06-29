import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/Components/custom_button.dart';
import 'package:virtual_lab/Components/custom_text.dart';
import 'package:virtual_lab/Controllers/notifiers.dart';
import 'package:virtual_lab/Utils/properties.dart';
import 'package:virtual_lab/Utils/routes.dart';

class MySignUpPage extends StatelessWidget {
  const MySignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppController.instance;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SizedBox(
          height: 320.h,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
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
                      height: 270.h,
                      decoration: BoxDecoration(
                        color: foregroundColor,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 24.w,
                          right: 14.w,
                          top: 36.h,
                          bottom: 8.h,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 160.h,
                              child: ScrollbarTheme(
                                data: ScrollbarThemeData(
                                  thumbColor: WidgetStateProperty.all(
                                    darkBrown,
                                  ),
                                ),
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  thickness: 4.w,
                                  radius: Radius.circular(10.r),
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10.w),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          controller.repeatedTextInput(
                                            label: 'Email',
                                          ),
                                          SizedBox(height: 8.h),
                                          controller.repeatedTextInput(
                                            label: 'First Name',
                                          ),
                                          SizedBox(height: 8.h),
                                          controller.repeatedTextInput(
                                            label: 'Last Name',
                                          ),
                                          SizedBox(height: 8.h),
                                          controller.repeatedTextInput(
                                            label: 'LRN',
                                          ),
                                          SizedBox(height: 8.h),
                                          controller.repeatedTextInput(
                                            label: 'Password',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 16.h),
                            Row(
                              spacing: 16.w,
                              children: [
                                MyButton(
                                  text: 'LOGIN',
                                  onTap: () => context.push(Routes.signIn),
                                ),
                                MyButton(text: 'SIGN UP', onTap: () {}),
                              ],
                            ),
                          ],
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
                      text: 'SIGN UP',
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
}
