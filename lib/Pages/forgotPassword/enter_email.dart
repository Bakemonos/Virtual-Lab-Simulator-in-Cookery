import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/components/custom_button.dart';
import 'package:virtual_lab/components/custom_header.dart';
import 'package:virtual_lab/controllers/controller.dart';
import 'package:virtual_lab/utils/properties.dart';
import 'package:virtual_lab/utils/routes.dart';

class MyForgotEnterEmailPage extends StatelessWidget {
  const MyForgotEnterEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppController.instance;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SizedBox(
          height: 250.h,
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
                      top: 16.w,
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
                          top: 40.h,
                          bottom: 8.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            controller.repeatedTextInput(
                              errorText: controller.emailErrorText,
                              controller: controller.emailController,
                              label: 'Email',
                            ),
                            SizedBox(height: 24.h),
                            Row(
                              spacing: 16.w,
                              children: [
                                Expanded(
                                  child: MyButton(
                                    text: 'Cancel',
                                    onTap: () {
                                      context.pop();
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: MyButton(
                                    text: 'Submit',
                                    onTap: () {
                                      //TODO SUBMIT EMAIL
                                      context.go(Routes.forgotChangePassword);
                                    },
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
              MyHeader(text: 'ENTER EMAIL'),
            ],
          ),
        ),
      ),
    );
  }
}
