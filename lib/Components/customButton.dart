import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:virtual_lab/Components/customText.dart';
import 'package:virtual_lab/Controllers/controller.dart';
import 'package:virtual_lab/Utils/properties.dart';

class MyButton extends StatelessWidget {
  final String text;
  final double? textSize;
  final Color? borderColor;
  final Function() onTap;
  final List<Color>? gradientColor;
  final bool? loading;

  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
    this.borderColor,
    this.textSize,
    this.gradientColor,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = AppController.instance;

    return ElevatedButton(
      onPressed: () {
        try {
          controller.playClickSound();
        } catch (e) {
          debugPrint('Sound error: $e');
        }
        loading! ? null : onTap();
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.w, color: borderColor ?? greenDark),
          borderRadius: BorderRadius.circular(24.r),
        ),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: gradientColor != null ? LinearGradient(
            colors: gradientColor!,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ) : null,
          color: gradientColor == null ? greenLight : null,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Container(
          alignment: Alignment.center,
          constraints: BoxConstraints(minWidth: 100.w, minHeight: 48.h),
          child: loading! ? Center(child: CircularProgressIndicator(color: textLight)) : MyText(
            text: text,
            size: textSize ?? 18.sp,
            fontWeight: FontWeight.w600,
            color: textLight,
          ),
        ),
      ),
    );
  }
}
