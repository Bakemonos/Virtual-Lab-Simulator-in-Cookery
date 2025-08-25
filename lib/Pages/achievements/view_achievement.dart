import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/components/custom_button.dart';
import 'package:virtual_lab/components/custom_header.dart';
import 'package:virtual_lab/components/custom_text.dart';
import 'package:virtual_lab/components/shimmer.dart';
import 'package:virtual_lab/controllers/controller.dart';
import 'package:virtual_lab/utils/properties.dart';
import 'package:virtual_lab/utils/routes.dart';

class MyViewAchievementPage extends StatefulWidget {
  const MyViewAchievementPage({super.key});

  @override
  State<MyViewAchievementPage> createState() => _MyViewAchievementPageState();
}

class _MyViewAchievementPageState extends State<MyViewAchievementPage> {
  final controller = AppController.instance;

  @override
  Widget build(BuildContext context) {
    var dish = controller.selectedDish.value;

    return Scaffold(
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
                      margin: EdgeInsets.only(top: 24.h),
                      decoration: BoxDecoration(
                        color: lightBrown,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 48.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: backgroundColor,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8.w),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    spacing: 4.h,
                                    children: [
                                      SizedBox(
                                        height: 100.h,
                                        width: 100.w,
                                        child: CachedNetworkImage(
                                          imageUrl: dish.image,
                                          placeholder: (context, url) => ShimmerSkeletonLoader(),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      MyText(text: dish.name, size: 24.sp,color: darkBrown),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Container(
                                width: 3.w,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              child: SizedBox(
                                width: 300.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyText(
                                      text: dish.name,
                                      fontWeight: FontWeight.bold,
                                      color: textLight,
                                      size: 18.sp,
                                    ),
                                    SizedBox(height: 8.h),
                                    MyText(
                                      text: 'Ingredients:',
                                      fontWeight: FontWeight.w600,
                                      color: textLight,
                                      size: 16.sp,
                                    ),
                                    ...dish.ingredients.map((ingredient) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(vertical: 4.h),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            MyText(
                                              text: '• ${ingredient.name}',
                                              color: textLight,
                                            ),
                                            if (ingredient.actions.isNotEmpty)
                                              Padding(
                                                padding: EdgeInsets.only(left: 16.w, top: 2.h),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: ingredient.actions.map((action) {
                                                    return MyText(
                                                      text:
                                                          '- ${action.action} (${action.status}) using ${action.tool}',
                                                      color: textLight,
                                                      size: 12.sp,
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    }),
                                    SizedBox(height: 16.h),
                                    MyText(
                                      text: 'Equipments:',
                                      fontWeight: FontWeight.w600,
                                      color: textLight,
                                      size: 16.sp,
                                    ),
                                    if (dish.equipments.isEmpty)
                                      MyText(text: '• None', color: textLight),
                                    ...dish.equipments.map((equipment) {
                                      return MyText(text: '• ${equipment.name}', color: textLight);
                                    }),
                                  ],
                                ),
                              ),
                            )

                          ],
                        ),
                      ),
                    ),
                  ),
                  MyHeader(text: 'EVALUATED'),
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

  playFunction(int index) {
    switch (index) {
      case 1:
        return () {};
      case 2:
        return () {};
      default:
        return () {
          context.push(Routes.sliderOption);
        };
    }
  }

  Widget foodChoices({
    required String path,
    required String label,
    required bool unlocked,
    required Function() onTap,
  }) {
    return SizedBox(
      width: 180.w,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 24.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: foregroundColor,
              ),
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  children: [
                    Container(
                      height: 120.h,
                      decoration: BoxDecoration(
                        color: darkBrown,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Center(
                          child: CachedNetworkImage(
                            imageUrl: path,
                            placeholder: (context, url) => ShimmerSkeletonLoader(),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    MyText(
                      text: label,
                      fontWeight: FontWeight.w500,
                      size: 14.sp,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: SizedBox(
                height: 48.h,
                child: MyButton(text: 'View', onTap: unlocked ? onTap : () {}),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
