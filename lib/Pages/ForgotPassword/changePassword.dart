import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/components/customButton.dart';
import 'package:virtual_lab/components/customHeader.dart';
import 'package:virtual_lab/controllers/controller.dart';
import 'package:virtual_lab/utils/properties.dart';
import 'package:virtual_lab/utils/routes.dart';

class MyForgotChangePasswordPage extends StatelessWidget {
  const MyForgotChangePasswordPage({super.key});

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
                      decoration: BoxDecoration(
                        color: foregroundColor,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 24.w,
                          right: 24.w,
                          top: 24.h,
                          bottom: 8.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            controller.repeatedTextInput(
                              controller: controller.passwordController,
                              errorText: controller.passwordErrorText,
                              label: 'Password',
                            ),
                            SizedBox(height: 12.h),
                            controller.repeatedTextInput(
                              errorText: controller.changePasswordErrorText,
                              controller: controller.changePasswordController,
                              label: 'Change Password',
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              spacing: 16.w,
                              children: [
                                MyButton(
                                  text: 'Cancel',
                                  onTap: () {
                                    context.go(Routes.signIn);
                                  },
                                ),
                                MyButton(
                                  text: 'Submit',
                                  onTap: () {
                                    //TODO CHANGE PASSWORD
                                  },
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
              MyHeader(text: 'CHANGE PASSWORD'),
            ],
          ),
        ),
      ),
    );
  }
}
