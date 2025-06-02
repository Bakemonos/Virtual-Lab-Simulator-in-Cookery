import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:virtual_lab/Components/custom_button.dart';
import 'package:virtual_lab/Components/custom_text.dart';
import 'package:virtual_lab/Components/custom_text_field.dart';
import 'package:virtual_lab/Utils/properties.dart';

class MyLoginPage extends StatelessWidget {
  const MyLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
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
                      top: 35.h,
                      bottom: 8.h,
                    ),
                    child: Column(
                      spacing: 10.h,
                      children: [
                        _repeatedTextInput(label: 'User name'),
                        _repeatedTextInput(label: 'Password'),
                        Row(
                          spacing: 16.w,
                          children: [
                            MyButton(text: 'LOGIN'),
                            MyButton(text: 'SIGN UP'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
          width: 150.w,
          child: MyText(text: label, fontWeight: FontWeight.w600),
        ),
        Expanded(child: MyTextfield(controller: controller)),
      ],
    );
  }
}
