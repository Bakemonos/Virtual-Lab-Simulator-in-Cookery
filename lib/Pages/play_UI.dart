

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/Components/custom_svg.dart';
import 'package:virtual_lab/Components/shimmer.dart';
import 'package:virtual_lab/Controllers/notifiers.dart';
import 'package:virtual_lab/Models/ingredients.dart';
import 'package:virtual_lab/Pages/menu.dart';
import 'package:virtual_lab/Utils/properties.dart';
import 'package:virtual_lab/Utils/routes.dart';

class MyPlayUIPage extends StatelessWidget {
  const MyPlayUIPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppController.instance;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 70.h),
            height: 100.h,
            decoration: BoxDecoration(
              color: lightBrown,
              border: Border(bottom: BorderSide(width: 10.w, color: darkBrown)),
            ),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(2.w),
                width: double.infinity,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: MySvgPicture(path: plate),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: 180.h,
              width: 380.w,
              margin: EdgeInsets.only(left: 14.w, bottom: 10.h),
              child: GridView.builder(
                padding: EdgeInsets.all(8.w),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  var data = ingredients[index];
                  
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: lightGridColor.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: CachedNetworkImage(
                        imageUrl: data.path,
                        placeholder: (context, url) => ShimmerSkeletonLoader(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: double.infinity,
              width: 280.w,
              decoration: BoxDecoration(
                color: darkBrown.withAlpha(77),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  bottomLeft: Radius.circular(30.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(14.w),
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: [
                    MySvgPicture(path: board),
                    Positioned(
                      top: 50.h,
                      child: SizedBox(
                        height: 56.h * 4 + 10.h * 3,
                        width: 56.w,
                        child: ListView.separated(
                          itemCount: 6,
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (_, __) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            var data = ingredients[index];

                            return AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: darkGridColor,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(4.w),
                                  child: CachedNetworkImage(
                                    imageUrl: data.path,
                                    placeholder: (context, url) => ShimmerSkeletonLoader(),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          controller.floatingButton(
            context: context,
            icon: home,
            onTap: () {
              context.push(
                Routes.foodChoices,
                extra: PageCache.foodChoicesPage,
              );
            },
          ),
        ],
      ),
    );
  }
}
