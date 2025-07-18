import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/Components/customButton.dart';
import 'package:virtual_lab/Components/customHeader.dart';
import 'package:virtual_lab/Controllers/controller.dart';
import 'package:virtual_lab/utils/properties.dart';
import 'package:virtual_lab/Components/customText.dart';
import 'package:virtual_lab/utils/routes.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  @override
  Widget build(BuildContext context) {
    final controller = AppController.instance;
    final signInFormKey = GlobalKey<FormState>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, _) => controller.exitDialog(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
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
                          child: Form(
                            key: signInFormKey,
                            child: Column(
                              spacing: 8.h,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                controller.repeatedTextInput(
                                  errorText: controller.emailErrorText,
                                  controller: controller.emailController,
                                  label: 'Email',
                                ),
                                controller.repeatedTextInput(
                                  errorText: controller.passwordErrorText,
                                  obscureText: true,
                                  controller: controller.passwordController,
                                  label: 'Password',
                                ),
                                InkWell(
                                  onTap:
                                      () =>
                                          context.push(Routes.forgotEnterEmail),
                                  child: MyText(
                                    text: 'Forgot password',
                                    size: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                Row(
                                  spacing: 16.w,
                                  children: [
                                    Expanded(
                                      child: Obx(
                                        () => MyButton(
                                          loading: controller.loader.value,
                                          text: 'LOGIN',
                                          onTap: () {
                                            final form =
                                                signInFormKey.currentState;
                                            if (form != null &&
                                                form.validate()) {
                                              controller.errorHandlerSignin();
                                              controller.signin(context);
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: MyButton(
                                        text: 'SIGN UP',
                                        onTap: () {
                                          controller.resetErrorHandler();
                                          context.push(Routes.signUp);
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
                ),
                MyHeader(text: 'LOGIN'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
