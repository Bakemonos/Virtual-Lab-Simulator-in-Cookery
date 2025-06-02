import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:virtual_lab/Utils/properties.dart';

class MyText extends StatefulWidget {
  final String text;
  final Color? color;
  final double? size, textHeight;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  const MyText({
    super.key,
    required this.text,
    this.color = lightBrown,
    this.size,
    this.textHeight,
    this.fontWeight = FontWeight.w600,
    this.textAlign = TextAlign.left,
    this.overflow,
  });

  @override
  State<MyText> createState() => _MyTextState();
}

class _MyTextState extends State<MyText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: widget.textAlign,
      widget.text,
      style: TextStyle(
        fontFamily: 'Poppins',
        color: widget.color,
        fontSize: widget.size ?? 24.sp,
        fontWeight: widget.fontWeight,
        height: widget.textHeight,
        overflow: widget.overflow,
      ),
    );
  }
}
