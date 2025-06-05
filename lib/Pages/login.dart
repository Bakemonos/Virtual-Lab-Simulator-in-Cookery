import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/Components/custom_button.dart';
import 'package:virtual_lab/Components/custom_text.dart';
import 'package:virtual_lab/Components/custom_text_field.dart';
import 'package:virtual_lab/Utils/properties.dart';
import 'package:virtual_lab/Utils/routes.dart';

class MyLoginPage extends StatelessWidget {
  const MyLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final player = AudioPlayer();

    // void playClickSound() async {
    //   await player.play(AssetSource(clickEffect1));
    // }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SizedBox(
          height: 270.h,
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
                          top: 40.h,
                          bottom: 8.h,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _repeatedTextInput(label: 'User name'),
                            SizedBox(height: 8.h),
                            _repeatedTextInput(label: 'Password'),
                            SizedBox(height: 16.h),
                            Row(
                              spacing: 16.w,
                              children: [
                                MyButton(text: 'LOGIN', onTap: () {}),
                                MyButton(
                                  text: 'SIGN UP',
                                  onTap: () async {
                                    // playClickSound();
                                    context.push(Routes.signUp);
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
                      text: 'LOGIN',
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

  Widget _repeatedTextInput({
    required String label,
    TextEditingController? controller,
  }) {
    return Row(
      spacing: 24.w,
      children: [
        SizedBox(
          width: 130.w,
          child: MyText(text: label, fontWeight: FontWeight.w600),
        ),
        Expanded(child: MyTextfield(controller: controller)),
      ],
    );
  }
}
