import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:virtual_lab/Utils/properties.dart';

class MyTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final bool? obscureText;
  final bool? error; // NEW: For red border control
  final Color? fillColor;
  final TextAlign? textAlign;
  final TextInputType? keyboardType;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;

  const MyTextfield({
    super.key,
    this.controller,
    this.hint,
    this.obscureText = false,
    this.error = false, // default no error
    this.fillColor = backgroundColor,
    this.textAlign = TextAlign.center,
    this.keyboardType,
    this.enabled = true,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hintStyle = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16.sp,
      color: lightBrown,
      fontWeight: FontWeight.w400,
    );

    final textStyle = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16.sp,
      color: Theme.of(context).textTheme.labelMedium?.color ?? Colors.black,
      fontWeight: FontWeight.w400,
    );

    return SizedBox(
      height: 48.h,
      child: TextField(
        obscureText: obscureText ?? false,
        style: textStyle,
        controller: controller,
        textAlign: textAlign ?? TextAlign.center,
        keyboardType: keyboardType,
        enabled: enabled ?? true,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintText: hint,
          hintStyle: hintStyle,
          fillColor: fillColor ?? backgroundColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: error == true ? redLighter : Colors.transparent,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: error == true ? redLighter : darkBrown,
              width: 1.5,
            ),
          ),
          errorStyle: TextStyle(fontSize: 0, height: 0), // Hide Flutter errors
        ),
      ),
    );
  }
}
