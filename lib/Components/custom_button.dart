import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:virtual_lab/Components/custom_text.dart';
import 'package:virtual_lab/Utils/properties.dart';

class MyButton extends StatelessWidget {
  final String text;
  final double? textSize;
  final Color? borderColor;
  final Function() onTap;
  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
    this.borderColor = greenDark,
    this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.w, color: borderColor!),
              borderRadius: BorderRadius.circular(24.r),
            ),
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [greenLighter, greenLight],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(minWidth: 100.w, minHeight: 48.h),
              child: MyText(
                text: text,
                size: textSize ?? 18.sp,
                fontWeight: FontWeight.w600,
                color: textLight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
