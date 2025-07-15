import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:virtual_lab/Components/customSvg.dart';
import 'package:virtual_lab/Controllers/controller.dart';
import 'package:virtual_lab/Pages/PlayUI/actionBarUI.dart';
import 'package:virtual_lab/Utils/properties.dart';

class MyProcedurePlatingPage extends StatefulWidget {
  const MyProcedurePlatingPage({super.key});

  @override
  State<MyProcedurePlatingPage> createState() => _MyProcedurePlatingPageState();
}

class _MyProcedurePlatingPageState extends State<MyProcedurePlatingPage>  with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.linear,
    ));
  }

  void handleTap() {
    double position = animation.value;
    double centerStart = 0.4; 
    double centerEnd = 0.6;  

    if (position >= centerStart && position <= centerEnd) {
      print("🎯 Perfect");
    } else if ((position - centerStart).abs() < 0.1 || (position - centerEnd).abs() < 0.1) {
      print("👍 Good");
    } else {
      print("❌ Miss");
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppController.instance;

    return SizedBox(
      width: 310.w,
      child: Column(
        spacing: 16.h,
        children: [
          Expanded(
            child: Container(
              decoration: controller.designUI(),
            ),
          ),
          Expanded(
            child: Container(
              decoration: controller.designUI(),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    MySvgPicture(path: board1),
                    const Spacer(),
                    GestureDetector(
                      onTap: handleTap,
                      child: TimingHitBar(animation: animation, controller: animationController),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}