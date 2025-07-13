import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:virtual_lab/Utils/properties.dart';

class MyText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size, textHeight;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final TextDecoration? decoration;

  const MyText({
    super.key,
    required this.text,
    this.color = lightBrown,
    this.size,
    this.textHeight,
    this.fontWeight = FontWeight.w600,
    this.textAlign = TextAlign.left,
    this.overflow,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: textAlign,
      text,
      style: TextStyle(
        fontFamily: 'Poppins',
        color: color,
        fontSize: size ?? 18.sp,
        fontWeight: fontWeight,
        height: textHeight,
        overflow: overflow,
        decoration: decoration,
      ),
    );
  }
}
