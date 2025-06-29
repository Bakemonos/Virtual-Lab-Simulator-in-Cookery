import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:virtual_lab/Components/custom_text.dart';
import 'package:virtual_lab/Utils/properties.dart';

class MyHeader extends StatelessWidget {
  final String text;
  const MyHeader({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
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
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 6.h),
          child: MyText(
            text: text,
            color: textLight,
            fontWeight: FontWeight.w700,
            size: 28.sp,
          ),
        ),
      ),
    );
  }
}
