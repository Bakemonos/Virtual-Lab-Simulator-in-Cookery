import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/Components/customText.dart';

Future<void> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  String cancelText = 'Cancel',
  String confirmText = 'Yes',
  Color confirmColor = Colors.green,
  Color cancelColor = Colors.grey,
  IconData icon = Icons.help_outline,
  Color iconColor = Colors.orange,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
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
              SizedBox(height: 8.h),
              MyText(
                text: message,
                textAlign: TextAlign.center,
                size: 14.sp,
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cancelColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      onPressed: () {
                        context.pop(); 
                        if (onCancel != null) onCancel();
                      },
                      child: MyText(text: cancelText, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: confirmColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      onPressed: () {
                        context.pop();
                        if (onConfirm != null) onConfirm();
                      },
                      child: MyText(text: confirmText, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
