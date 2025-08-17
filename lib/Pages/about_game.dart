import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/components/custom_header.dart';
import 'package:virtual_lab/controllers/controller.dart';
import 'package:virtual_lab/utils/properties.dart';
import 'package:virtual_lab/components/custom_text.dart';

class MyAboutGamePage extends StatelessWidget {
  const MyAboutGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppController.instance;
    
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              height: 340.h,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: 24.h),
                      width: 500.w,
                      decoration: BoxDecoration(
                        color: lightBrown,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 16.w,
                          right: 16.w,
                          top: 12.w,
                          bottom: 20.sp,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: foregroundColor,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 24.w,
                              right: 14.w,
                              top: 34.h,
                              bottom: 8.h,
                            ),
                            child: ScrollbarTheme(
                              data: ScrollbarThemeData(
                                thumbColor: WidgetStateProperty.all(darkBrown),
                              ),
                              child: Scrollbar(
                                thumbVisibility: true,
                                thickness: 4.w,
                                radius: Radius.circular(10.r),
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.w),
                                    child: Column(
                                      spacing: 8.h,
                                      children: [
                                        MyText(
                                          text: 'Welcome to Cooking Master!',
                                          fontWeight: FontWeight.w600,
                                          size: 24.sp,
                                        ),
                                        MyText(
                                          text: 'In this fun and educational game, you\'ll learn how to prepare delicious meals from around the world. Follow recipe s, manage ingredients, and become the ultimate kitchen pro!',
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.w500,
                                          size: 18.sp,
                                        ),
                                        MyText(
                                          text: 'Developers: Rico Jay & Carlo\nSupport: developerteam2002@gmail.com',
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.w500,
                                          textHeight: 2,
                                          size: 18.sp,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  MyHeader(text: 'ABOUT GAME'),
                ],
              ),
            ),
          ),
          controller.floatingButton(
            context: context,
            onTap: () {
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
