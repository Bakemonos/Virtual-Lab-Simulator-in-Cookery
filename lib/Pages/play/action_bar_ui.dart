import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:virtual_lab/utils/properties.dart';

class TimingHitBar extends StatelessWidget {
  final Animation<double> animation;
  final AnimationController controller;

  const TimingHitBar({
    super.key,
    required this.animation,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final barHeight = constraints.maxHeight;
        final greenZoneHeight = 16.h;
    
        final centerStart = (barHeight / 2) - (greenZoneHeight / 2);
        // final centerEnd = (barHeight / 2) + (greenZoneHeight / 2);
        
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 24.w,
              height: barHeight,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            Positioned(
              top: centerStart,
              child: Container(
                width: 24.w,
                height: greenZoneHeight,
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: animation,
              builder: (_, __) {
                final cursorY = animation.value * barHeight;
                return Positioned(
                  top: cursorY.clamp(0, barHeight - 4.h),
                  child: Container(width: 30.w, height: 4.h, color: redLighter),
                );
              },
            ),
          ],
        );
      },
    );
  }
}