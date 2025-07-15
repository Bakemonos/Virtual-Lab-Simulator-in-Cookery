import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:virtual_lab/Utils/properties.dart';

class MyDropDown extends StatelessWidget {
  final String? value;
  final String hintText;
  final List<String> items;
  final void Function(String?)? onChanged;
  final Color? fillColor;
  final bool hasError;

  const MyDropDown({
    super.key,
    required this.items,
    required this.hintText,
    this.value,
    this.onChanged,
    this.fillColor = backgroundColor,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16.sp,
      color: Theme.of(context).textTheme.labelMedium?.color ?? Colors.black,
      fontWeight: FontWeight.w400,
    );

    final hintStyle = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16.sp,
      color: lightBrown,
      fontWeight: FontWeight.w400,
    );

    Color borderColor = hasError ? redLighter : Colors.transparent;

    return SizedBox(
      height: 48.h,
      child: DropdownButtonFormField<String>(
        value: items.contains(value) ? value : null,
        isExpanded: true,
        alignment: Alignment.center,
        autovalidateMode: AutovalidateMode.always,
        decoration: InputDecoration(
          hintText: null,
          fillColor: fillColor,
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          errorStyle: const TextStyle(height: 0, fontSize: 0),
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 16.w,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: borderColor,
              width: hasError ? 1.5 : 0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: hasError ? redLighter : darkBrown, width: 1.5),
          ),
        ),
        hint: Center(child: Text(hintText, style: hintStyle, textAlign: TextAlign.center)),
        dropdownColor: fillColor,
        iconEnabledColor: darkBrown,
        style: textStyle,
        validator: (value) => null,
        items: items.map((value) => DropdownMenuItem<String>(
          value: value,
          child: Center(
            child: Text(
              value,
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ),
        )).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
