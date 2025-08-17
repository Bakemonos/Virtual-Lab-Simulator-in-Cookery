import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/components/custom_button.dart';
import 'package:virtual_lab/components/custom_header.dart';
import 'package:virtual_lab/components/custom_text.dart';
import 'package:virtual_lab/controllers/controller.dart';
import 'package:virtual_lab/utils/properties.dart';

class MyInformationPage extends StatelessWidget {
  const MyInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppController.instance;
    final user = controller.userData.value;
    final progress = controller.progress.value;

    bool coc1Unlocked = true;
    bool coc2Unlocked = progress.coc1 == "complete";
    bool coc3Unlocked = progress.coc2 == "complete";

    String cocStatus(String coc, bool unlocked) {
      if (coc == "complete") return "COMPLETED";
      if (!unlocked) return "NOT UNLOCKED YET";
      return "PENDING";
    }

    Color borderColor(String coc, bool unlocked) {
      if (coc == "complete") return greenDark;
      if (!unlocked) return redDark;
      return darkYellowColor;
    }

    List<Color> gradientColor(String coc, bool unlocked) {
      if (coc == "complete") return [greenLighter, greenLight];
      if (!unlocked) return [redLighter, redLight];
      return [lightYellowColor, darkYellowColor];
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 500.w,
                        margin: EdgeInsets.only(top: 24.h),
                        decoration: BoxDecoration(
                          color: lightBrown,
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.w, bottom: 20.sp),
                          child: Container(
                            decoration: BoxDecoration(
                              color: foregroundColor,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 24.w,right: 24.w,top: 30.h,bottom: 16.h),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          controller.repeatedInformation(label: 'LRN', value: user.lrn),
                                          controller.repeatedInformation(label: 'Email', value: user.email),
                                          controller.repeatedInformation(label: 'Fullname', value: '${user.firstName} ${user.lastName}'),
                                          controller.repeatedInformation(label: 'Gender', value: user.gender),
                                          controller.repeatedInformation(label: 'Grade Level',value: user.gradeLevel),
                                          SizedBox(height: 8.h),
                                          MyText(text: 'Status'),
                                          MyText(text: 'COC 1'),
                                          SizedBox(
                                            height: 48.h,
                                            child: MyButton(
                                              text: cocStatus(progress.coc1, coc1Unlocked),
                                              borderColor: borderColor(progress.coc1, coc1Unlocked),
                                              gradientColor: gradientColor(progress.coc1, coc1Unlocked),
                                              onTap: () {},
                                            ),
                                          ),
                                          MyText(text: 'COC 2'),
                                          SizedBox(
                                            height: 48.h,
                                            child: MyButton(
                                              text: cocStatus(progress.coc2, coc2Unlocked),
                                              borderColor: borderColor(progress.coc2, coc2Unlocked),
                                              gradientColor: gradientColor(progress.coc2, coc2Unlocked),
                                              onTap: () {
                                              },
                                            ),
                                          ),
                                          MyText(text: 'COC 3'),
                                          SizedBox(
                                            height: 48.h,
                                            child: MyButton(
                                              text: cocStatus(progress.coc3, coc3Unlocked),
                                              borderColor: borderColor(progress.coc3, coc3Unlocked),
                                              gradientColor: gradientColor(progress.coc3, coc3Unlocked),
                                              onTap: () {},
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
                    const MyHeader(text: 'PROFILE'),
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
      ),
    );
  }
}
