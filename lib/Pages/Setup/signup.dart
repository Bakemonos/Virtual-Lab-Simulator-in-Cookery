import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/Components/customButton.dart';
import 'package:virtual_lab/Components/customHeader.dart';
import 'package:virtual_lab/Controllers/controller.dart';
import 'package:virtual_lab/Utils/properties.dart';

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
                                        spacing: 16.h,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          controller.repeatedTextInput(
                                            errorText: controller.lrnErrorText,
                                            controller:
                                                controller.lrnController,
                                            label: 'LRN',
                                          ),
                                          controller.repeatedTextInput(
                                            errorText:
                                                controller.firstnameErrorText,
                                            controller:
                                                controller.firstnameController,
                                            label: 'First Name',
                                          ),
                                          controller.repeatedTextInput(
                                            errorText:
                                                controller.lastnameErrorText,
                                            controller:
                                                controller.lastnameController,
                                            label: 'Last Name',
                                          ),
                                          controller.repeatedTextInput(
                                            errorText:
                                                controller.emailErrorText,
                                            controller:
                                                controller.emailController,
                                            label: 'Email',
                                          ),
                                          Obx(
                                            () => controller.repeatedDropdown(
                                              hasError:
                                                  controller
                                                      .genderErrorText
                                                      .value
                                                      .isNotEmpty,
                                              errorText:
                                                  controller.genderErrorText,
                                              selectedValue:
                                                  controller.gender.value,
                                              label: 'Gender',
                                              hint: 'Select Gender',
                                              items: [
                                                'Male',
                                                'Female',
                                                'Rather not say',
                                              ],
                                              onChanged: (value) {
                                                controller.gender.value =
                                                    value!;
                                              },
                                            ),
                                          ),
                                          Obx(
                                            () => controller.repeatedDropdown(
                                              hasError:
                                                  controller
                                                      .gradeLevelErrorText
                                                      .value
                                                      .isNotEmpty,
                                              errorText:
                                                  controller
                                                      .gradeLevelErrorText,
                                              selectedValue:
                                                  controller.gradeLevel.value,
                                              label: 'Grade Level',
                                              hint: 'Select Grade Level',
                                              items: [
                                                'Junior High School',
                                                'Senior High School',
                                              ],
                                              onChanged: (value) {
                                                controller.gradeLevel.value =
                                                    value!;
                                              },
                                            ),
                                          ),
                                          controller.repeatedTextInput(
                                            errorText:
                                                controller.passwordErrorText,
                                            obscureText: true,
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
                                    onTap: () {
                                      controller.resetErrorHandler();
                                      context.pop();
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: MyButton(
                                    text: 'SIGN UP',
                                    onTap: () {
                                      controller.errorHandlerSignup();
                                      controller.signup(context);
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
              MyHeader(text: 'SIGN UP'),
            ],
          ),
        ),
      ),
    );
  }
}
