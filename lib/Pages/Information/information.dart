import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/Components/customButton.dart';
import 'package:virtual_lab/Components/customHeader.dart';
import 'package:virtual_lab/Components/customText.dart';
import 'package:virtual_lab/Controllers/controller.dart';
import 'package:virtual_lab/Utils/properties.dart';

class MyInformationPage extends StatelessWidget {
  const MyInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppController.instance;

    final user = controller.userData.value;

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
                              top: 30.h,
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
                                      spacing: 8.h,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // controller.repeatedInformation(
                                        //   label: 'User ID',
                                        //   value: user.id.toString(),
                                        // ),
                                        controller.repeatedInformation(
                                          label: 'LRN',
                                          value: user.lrn,
                                        ),
                                        controller.repeatedInformation(
                                          label: 'Email',
                                          value: user.email,
                                        ),
                                        controller.repeatedInformation(
                                          label: 'Fullname',
                                          value:
                                              '${user.firstName} ${user.lastName}',
                                        ),
                                        controller.repeatedInformation(
                                          label: 'Gender',
                                          value: user.gender,
                                        ),
                                        controller.repeatedInformation(
                                          label: 'Grade Level',
                                          value: user.gradeLevel,
                                        ),
                                        SizedBox(height: 8.h),
                                        MyText(text: 'Status'),
                                        MyText(text: 'COC 1'),
                                        SizedBox(
                                          height: 48.h,
                                          child: MyButton(
                                            text: 'COMPLETED',
                                            onTap: () {},
                                          ),
                                        ),
                                        MyText(text: 'COC 2'),
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
                                        MyText(text: 'COC 3'),
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
