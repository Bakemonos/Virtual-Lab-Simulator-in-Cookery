import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:virtual_lab/Utils/properties.dart';

class ShimmerSkeletonLoader extends StatelessWidget {
  const ShimmerSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6.r)),
      ).animate(
      delay: Duration(milliseconds: 300),
      onPlay: (controller) => controller.repeat(),
    ).shimmer(
      duration: Duration(seconds: 1),
      color: darkBrown,
    );
  }
}