import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyImgPicture extends StatelessWidget {
  final String path;
  final double? size;
  final BoxFit fit;

  const MyImgPicture({
    super.key,
    required this.path,
    this.size,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(path, height: size?? 48.h, width: size?? 48.w, fit: fit);
  }
}
