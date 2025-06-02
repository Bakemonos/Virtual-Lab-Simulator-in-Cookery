import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:virtual_lab/Utils/properties.dart';

class MyTextfield extends StatefulWidget {
  final TextEditingController? controller;
  final String? hint;
  final bool? isExpands;
  final bool? noIcon;
  final double? textSize;
  final Color? fillColor;
  final TextAlign? textAlign;
  final TextInputType? keyboardType;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool? obscureText;

  const MyTextfield({
    super.key,
    this.hint,
    this.controller,
    this.textSize,
    this.isExpands = false,
    this.noIcon = false,
    this.fillColor = backgroundColor,
    this.textAlign = TextAlign.center,
    this.keyboardType,
    this.enabled = true,
    this.inputFormatters,
    this.onChanged,
    this.validator,
    this.obscureText = false,
  });

  @override
  State<MyTextfield> createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {
  @override
  Widget build(BuildContext context) {
    var hintStyle = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16.sp,
      color: darkBrown,
      fontWeight: FontWeight.w400,
    );

    var textStyle = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16.sp,
      color: Theme.of(context).textTheme.labelMedium!.color,
      fontWeight: FontWeight.w400,
    );

    return SizedBox(
      height: 48.h,
      child: TextFormField(
        obscureText: widget.obscureText!,
        style: textStyle,
        validator: widget.validator,
        controller: widget.controller,
        textAlign: widget.textAlign!,
        keyboardType: widget.keyboardType,
        enabled: widget.enabled,
        inputFormatters: widget.inputFormatters,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintText: widget.hint,
          hintStyle: hintStyle,
          fillColor: widget.fillColor,
          filled: true,
          border: UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }
}
