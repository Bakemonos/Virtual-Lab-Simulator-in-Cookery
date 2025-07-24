import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/components/customButton.dart';
import 'package:virtual_lab/components/customHeader.dart';
import 'package:virtual_lab/controllers/controller.dart';
import 'package:virtual_lab/pages/foodChoices.dart';
import 'package:virtual_lab/utils/properties.dart';
import 'package:virtual_lab/utils/routes.dart';

class MyMenuPage extends StatelessWidget {
  const MyMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppController.instance;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, _) => controller.exitDialog(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 360.w,
                    margin: EdgeInsets.only(top: 24.h),
                    decoration: BoxDecoration(
                      color: lightBrown,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 16.w,
                        right: 16.w,
                        bottom: 20.sp,
                        top: 12.w,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: foregroundColor,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 24.w,
                            right: 24.w,
                            top: 40.h,
                            bottom: 8.h,
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 48.h,
                                child: MyButton(
                                  text: 'Play',
                                  onTap: () {
                                    context.push(
                                      Routes.foodChoices,
                                      extra: PageCache.foodChoicesPage,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 12.h),
                              SizedBox(
                                height: 48.h,
                                child: MyButton(
                                  text: 'Achievement',
                                  onTap: () {
                                    context.go(Routes.achievementOption);
                                  },
                                ),
                              ),
                              SizedBox(height: 12.h),
                              SizedBox(
                                height: 48.h,
                                child: MyButton(
                                  text: 'Settings',
                                  onTap: () {
                                    context.push(Routes.settings);
                                  },
                                ),
                              ),
                              SizedBox(height: 12.h),
                              SizedBox(
                                height: 48.h,
                                child: MyButton(
                                  text: 'Quit',
                                  borderColor: redDark,
                                  gradientColor: [redLighter, redLight],
                                  onTap:
                                      () async =>
                                          controller.exitDialog(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                MyHeader(text: 'MENU'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PageCache {
  static final foodChoicesPage = MyFoodChoicesPage();
}
