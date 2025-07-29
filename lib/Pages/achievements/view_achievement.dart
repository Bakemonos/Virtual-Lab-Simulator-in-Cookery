import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/components/custom_button.dart';
import 'package:virtual_lab/components/custom_header.dart';
import 'package:virtual_lab/components/custom_svg.dart';
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 4.h,
                                    children: [
                                      SizedBox(
                                        height: 100.h,
                                        width: 100.w,
                                        child: CachedNetworkImage(
                                          imageUrl: 'https://res.cloudinary.com/dgvi2di6t/image/upload/v1753612872/beef_qcitkg.png',
                                          placeholder: (context, url) => ShimmerSkeletonLoader(),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Icon(Icons.star,color: darkBrown,size: 32.w),
                                          Icon(Icons.star,color: darkBrown,size: 40.w),
                                          Icon(Icons.star,color: darkBrown,size: 32.w),
                                        ],
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
                                      text: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum',
                                      color: textLight,
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
              context.go(Routes.sliderOption);
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
