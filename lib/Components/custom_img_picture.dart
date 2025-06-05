import 'package:flutter/material.dart';

class MyImgPicture extends StatelessWidget {
  final String path;
  final double? height;
  final double? width;
  final BoxFit fit;

  const MyImgPicture({
    super.key,
    required this.path,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(path, height: height, width: width, fit: fit);
  }
}
