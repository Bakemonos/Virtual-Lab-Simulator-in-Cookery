import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class MySvgPicture extends StatefulWidget {
  final String path;
  final Color? iconColor;
  final double? iconSize;
  final BlendMode? blendMode;
  final BoxFit? fit;
  const MySvgPicture({
    super.key,
    required this.path,
    this.iconColor,
    this.iconSize,
    this.blendMode,
    this.fit = BoxFit.contain,
  });

  @override
  State<MySvgPicture> createState() => _MySvgPictureState();
}

class _MySvgPictureState extends State<MySvgPicture> {
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      widget.path,
      fit: widget.fit!,
      color: widget.iconColor,
      width: widget.iconSize?? 24.w,
    );
  }
}
