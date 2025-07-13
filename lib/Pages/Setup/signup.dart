import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/Components/custom_button.dart';
import 'package:virtual_lab/Components/custom_header.dart';
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
                          spacing: 16.h,
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
                                        spacing: 8.h,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          controller.repeatedTextInput(
                                            controller:
                                                controller.lrnController,
                                            label: 'LRN',
                                          ),
                                          controller.repeatedTextInput(
                                            controller:
                                                controller.firstnameController,
                                            label: 'First Name',
                                          ),
                                          controller.repeatedTextInput(
                                            controller:
                                                controller.lastnameController,
                                            label: 'Last Name',
                                          ),
                                          controller.repeatedTextInput(
                                            controller:
                                                controller.emailController,
                                            label: 'Email',
                                          ),
                                          controller.repeatedTextInput(
                                            controller:
                                                controller.passwordController,
                                            label: 'Password',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              spacing: 16.w,
                              children: [
                                Expanded(
                                  child: MyButton(
                                    text: 'LOGIN',
                                    onTap: () => context.go(Routes.signIn),
                                  ),
                                ),
                                Expanded(
                                  child: MyButton(
                                    text: 'SIGN UP',
                                    onTap: () => controller.signup(context),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              MyHeader(text: 'SIGN UP'),
            ],
          ),
        ),
      ),
    );
  }
}
