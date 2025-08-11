import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/components/custom_button.dart';
import 'package:virtual_lab/components/custom_header.dart';
import 'package:virtual_lab/components/custom_svg_picture.dart';
import 'package:virtual_lab/controllers/controller.dart';
import 'package:virtual_lab/main.dart';
import 'package:virtual_lab/pages/menu.dart';
import 'package:virtual_lab/utils/properties.dart';
import 'package:virtual_lab/utils/routes.dart';

class MySettingsPage extends StatelessWidget {
  const MySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppController.instance;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 24.h),
                  width: 360.w,
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
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16.r),
                                        color: backgroundColor,
                                      ),
                                      height: 60.h,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Obx(() => _settingIconToggle(
                                            controller: controller,
                                            path: controller.soundToggle.value ? soundOn : soundOff,
                                            onTap: () {
                                              controller.setSoundToggle(!controller.soundToggle.value);
                                            },
                                          )),
                                          Obx(() => _settingIconToggle(
                                            controller: controller,
                                            path: controller.musicToggle.value ? musicOn : musicOff,
                                            onTap: () {
                                              final newValue = !controller.musicToggle.value;
                                              controller.setMusicToggle(newValue);

                                              if (newValue) {
                                                BackgroundMusic.play();
                                              } else {
                                                BackgroundMusic.stop();
                                              }
                                            },
                                          )),
                                          _settingIconToggle(
                                            controller: controller,
                                            path: information,
                                            onTap: () => context.push(
                                              Routes.information,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    SizedBox(
                                      height: 48.h,
                                      child: MyButton(
                                        text: 'Continue',
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
                                        text: 'About Game',
                                        onTap: () {
                                          context.push(Routes.aboutGame);
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    SizedBox(
                                      height: 48.h,
                                      child: MyButton(
                                        text: 'Back to Menu',
                                        borderColor: redDark,
                                        gradientColor: [redLighter, redLight],
                                        onTap: () => context.push(Routes.menu),
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    SizedBox(
                                      height: 48.h,
                                      child: MyButton(
                                        text: 'Log out',
                                        borderColor: redDark,
                                        gradientColor: [redLighter, redLight],
                                        onTap:
                                            () async => controller.logoutDialog(
                                              context,
                                            ),
                                      ),
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
              MyHeader(text: 'SETTINGS'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingIconToggle({
    required String path,
    required AppController controller,
    Function()? onTap,
  }) {
    return InkWell(
      onTap: () {
        SoundEffects.playEffect();
        onTap?.call();
      },
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: greenLight,
          border: Border.all(width: 0.5, color: greenDark),
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: Padding(
            padding: EdgeInsets.all(9.w),
            child: MySvgPicture(path: path),
          ),
        ),
      ),
    );
  }
}
