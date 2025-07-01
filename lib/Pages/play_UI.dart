import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:virtual_lab/Components/custom_svg.dart';
import 'package:virtual_lab/Components/custom_text.dart';
import 'package:virtual_lab/Components/shimmer.dart';
import 'package:virtual_lab/Controllers/notifiers.dart';
import 'package:virtual_lab/Models/ingredients_model.dart';
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 120.h,
                      child: GridView.builder(
                        padding: EdgeInsets.all(8.w),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 6,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 1,
                            ),
                        itemCount: ingredients.length,
                        itemBuilder: (context, index) {
                          var data = ingredients[index];
                          var isSelected = controller.selectedList[index];
                          return InkWell(
                            onTap: () {},
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color:
                                    isSelected.value
                                        ? lightGridColor
                                        : lightGridColor.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.w),
                                child: CachedNetworkImage(
                                  imageUrl: data.path,
                                  placeholder:
                                      (context, url) => ShimmerSkeletonLoader(),
                                  errorWidget:
                                      (context, url, error) =>
                                          Icon(Icons.error),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
