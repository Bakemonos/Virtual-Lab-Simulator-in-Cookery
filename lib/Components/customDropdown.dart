import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:virtual_lab/Utils/properties.dart';

class MyDropDown extends StatefulWidget {
  final String? value;
  final String hintText;
  final List<String> items;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final Color? fillColor;

  const MyDropDown({
    super.key,
    required this.items,
    required this.hintText,
    this.value,
    this.onChanged,
    this.validator,
    this.fillColor = backgroundColor,
  });

  @override
  State<MyDropDown> createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
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

    return SizedBox(
      height: 48.h,
      child: DropdownButtonFormField<String>(
        value: widget.items.contains(widget.value) ? widget.value : null,
        isExpanded: true,
        alignment: Alignment.center, // Center the selected value
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintText: null, // Remove the default hint to customize it manually
          fillColor: widget.fillColor,
          filled: true,
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
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: darkBrown, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.redAccent, width: 2),
          ),
          errorStyle: TextStyle(
            fontSize: 12.sp,
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
        hint: Center(
          child: Text(
            widget.hintText,
            style: hintStyle,
            textAlign: TextAlign.center,
          ),
        ),
        dropdownColor: widget.fillColor,
        iconEnabledColor: darkBrown,
        style: textStyle,
        validator:
            widget.validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
        items:
            widget.items
                .map(
                  (value) => DropdownMenuItem<String>(
                    value: value,
                    child: Center(
                      child: Text(
                        value,
                        style: textStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
                .toList(),
        onChanged: widget.onChanged,
      ),
    );
  }
}
