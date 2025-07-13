import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MySvgPicture extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      fit: fit!,
      color: iconColor,
      width: iconSize,
    );
  }
}
