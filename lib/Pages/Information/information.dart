import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/Components/custom_button.dart';
import 'package:virtual_lab/Components/custom_header.dart';
import 'package:virtual_lab/Components/custom_text.dart';
import 'package:virtual_lab/Controllers/notifiers.dart';
import 'package:virtual_lab/Utils/properties.dart';

class MyInformationPage extends StatelessWidget {
  const MyInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppController.instance;

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
                      width: 500.w,
                      margin: EdgeInsets.only(top: 24.h),
                      decoration: BoxDecoration(
                        color: lightBrown,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 16.w,
                          right: 16.w,
                          top: 8.w,
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
                              right: 24.w,
                              top: 24.h,
                              bottom: 16.h,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        controller.repeatedTextInput(
                                          label: 'Email',
                                        ),
                                        SizedBox(height: 12.h),
                                        controller.repeatedTextInput(
                                          label: 'LRN',
                                        ),
                                        SizedBox(height: 16.h),
                                        MyText(text: 'Status'),
                                        SizedBox(height: 16.h),
                                        MyText(text: 'COC 1'),
                                        SizedBox(height: 8.h),
                                        SizedBox(
                                          height: 48.h,
                                          child: MyButton(
                                            text: 'COMPLETED',
                                            onTap: () {},
                                          ),
                                        ),
                                        SizedBox(height: 12.h),
                                        MyText(text: 'COC 2'),
                                        SizedBox(height: 8.h),
                                        SizedBox(
                                          height: 48.h,
                                          child: MyButton(
                                            text: 'NOT UNLOCKED YET',
                                            borderColor: redDark,
                                            gradientColor: [
                                              redLighter,
                                              redLight,
                                            ],
                                            onTap: () {},
                                          ),
                                        ),
                                        SizedBox(height: 12.h),
                                        MyText(text: 'COC 3'),
                                        SizedBox(height: 8.h),
                                        SizedBox(
                                          height: 48.h,
                                          child: MyButton(
                                            text: 'NOT UNLOCKED YET',
                                            borderColor: redDark,
                                            gradientColor: [
                                              redLighter,
                                              redLight,
                                            ],
                                            onTap: () {},
                                          ),
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
                  MyHeader(text: 'PROFILE'),
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
