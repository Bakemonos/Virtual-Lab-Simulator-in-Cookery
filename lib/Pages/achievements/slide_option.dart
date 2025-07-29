import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/components/custom_text.dart';
import 'package:virtual_lab/components/shimmer.dart';
import 'package:virtual_lab/controllers/controller.dart';
import 'package:virtual_lab/utils/properties.dart';
import 'package:virtual_lab/utils/routes.dart';

class MySliderOptionPage extends StatefulWidget {
  const MySliderOptionPage({super.key});

  @override
  State<MySliderOptionPage> createState() => _MySliderOptionPageState();
}

class _MySliderOptionPageState extends State<MySliderOptionPage> {
  final PageController _pageController = PageController(viewportFraction: 0.3);
  final controller = AppController.instance;
  double _currentPage = 0;
  String? selectedClass;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 24.h),
              MyText(text: 'Achievements', size: 32.sp),
              SizedBox(height: 16.h),
              SizedBox(
                height: 250.h,
                child: Obx((){
                  var submitted = controller.submittedCocList;

                  return PageView.builder(
                    controller: _pageController,
                    itemCount: submitted.length,
                    itemBuilder: (context, index) {
                      final item = submitted[index];
                      
                      double difference = (_currentPage - index).abs();
                      double scale = 1 - (difference * 0.3).clamp(0.0, 0.3);
                      bool isSelected = selectedClass == item.id;

                      return Transform.scale(
                        scale: scale,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              controller.selectedDish.value = item;
                              context.go(Routes.viewAchievement);
                              selectedClass = item.id;
                            });
                          },
                          child: Container(
                            width: 250.w,
                            margin: EdgeInsets.only(bottom: 24.h),
                            decoration: BoxDecoration(
                              color: isSelected ? lightBrown : darkBrown,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                if (isSelected) BoxShadow(
                                  color: lightBrown.withValues(alpha: 0.5),
                                  blurRadius: 15,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(right: 16.w,left: 16.w,top: 16.h,bottom: 4.h),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(4.w),
                                        child: Column(
                                          spacing: 8.h,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 90.h,
                                              width: 90.w,
                                              child: CachedNetworkImage(
                                                imageUrl: 'https://res.cloudinary.com/dgvi2di6t/image/upload/v1753802663/beef_soup_ihgwhv.png',
                                                placeholder: (context, url) => ShimmerSkeletonLoader(),
                                                errorWidget: (context, url, error) => Icon(Icons.error),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [ 
                                                Icon(Icons.star,color: darkBrown,size: 28.w),
                                                Icon(Icons.star,color: darkBrown,size: 36.w),
                                                Icon(Icons.star,color: darkBrown,size: 28.w),
                                              ],
                                            ),
                                            MyText(text: item.name, size: 20.sp,color: darkBrown),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  MyText(text: 'View',size: 18.sp,color: textLight),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                })
              ),
            ],
          ),
          controller.floatingButton(
            context: context,
            onTap: () {
              context.go(Routes.achievementOption);
            },
          ),
        ],
      ),
    );
  }
}
