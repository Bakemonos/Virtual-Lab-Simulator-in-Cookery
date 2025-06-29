import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:virtual_lab/Components/custom_svg.dart';
import 'package:virtual_lab/Components/custom_text.dart';
import 'package:virtual_lab/Controllers/notifiers.dart';
import 'package:virtual_lab/Utils/properties.dart';

class MyPlayUIPage extends StatelessWidget {
  const MyPlayUIPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppController.instance;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          spacing: 16.w,
          children: [
            //? TIME / INVENTORY
            SizedBox(
              width: 145.w,
              child: Column(
                spacing: 16.h,
                children: [
                  Container(
                    height: 70.h,
                    decoration: BoxDecoration(
                      color: lightBrown,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(width: 2.w, color: darkBrown),
                    ),
                    child: Center(
                      child: MyText(
                        text: '03:00',
                        size: 24.sp,
                        color: textLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: lightBrown,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(width: 2.w, color: darkBrown),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          spacing: 16.h,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              spacing: 4.h,
                              children: [
                                Container(
                                  width: 60.w,
                                  height: 60.h,
                                  decoration: BoxDecoration(
                                    color: darkBrown,
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      width: 2.w,
                                      color: backgroundColor,
                                    ),
                                  ),
                                ),
                                MyText(
                                  text: 'Trashbin',
                                  color: textLight,
                                  size: 12.sp,
                                ),
                              ],
                            ),
                            Column(
                              spacing: 4.h,
                              children: [
                                MySvgPicture(path: bag),
                                MyText(
                                  text: 'Bag',
                                  color: textLight,
                                  size: 12.sp,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //? PROCEDURE / PLATING
            SizedBox(
              width: 310.w,
              child: Column(
                spacing: 16.h,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: lightBrown,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(width: 2.w, color: darkBrown),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: lightBrown,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(width: 2.w, color: darkBrown),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Row(children: [MySvgPicture(path: board1)]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //? PROCESS
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: lightBrown,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(width: 2.w, color: darkBrown),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
