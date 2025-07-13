import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:virtual_lab/Components/customText.dart';

Future<void> showSuccessDialog({
  required BuildContext context,
  required String title,
  required String message,
  String buttonText = 'Continue',
  Color iconColor = Colors.green,
  IconData icon = Icons.check_circle,
  VoidCallback? onConfirm,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        content: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 300.w, maxWidth: 400.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: iconColor, size: 64.w),
              SizedBox(height: 16.h),
              MyText(text: title, size: 20.sp, fontWeight: FontWeight.bold),
              SizedBox(height: 8),
              MyText(text: message, textAlign: TextAlign.center, size: 14.sp),
              SizedBox(height: 24.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: iconColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: () {
                  if (onConfirm != null) {
                    onConfirm();
                  }
                },
                child: MyText(text: buttonText, color: Colors.white),
              ),
            ],
          ),
        ),
      );
    },
  );
}
