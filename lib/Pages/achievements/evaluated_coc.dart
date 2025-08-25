import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/components/custom_header.dart';
import 'package:virtual_lab/components/custom_img_picture.dart';
import 'package:virtual_lab/components/custom_text.dart';
import 'package:virtual_lab/components/shimmer.dart';
import 'package:virtual_lab/controllers/controller.dart';
import 'package:virtual_lab/services/services.dart';
import 'package:virtual_lab/utils/properties.dart';
import 'package:virtual_lab/utils/routes.dart';

class MyEvaluatedCoc extends StatefulWidget {
  const MyEvaluatedCoc({super.key});

  @override
  State<MyEvaluatedCoc> createState() => _MyEvaluatedCocState();
}

class _MyEvaluatedCocState extends State<MyEvaluatedCoc> {
  final controller = AppController.instance;
  final db = ApiServices.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Stack(
                children: [
                  Obx((){
                    final data = controller.grade.value;

                    // debugPrint(data.);

                    return Align(
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
                                child: Column(
                                  spacing: 16.h,
                                  children: [
                                    Expanded(
                                      child: controller.loader.value ? loader() : Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.r),
                                          color: backgroundColor,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.w),
                                          child: Row(
                                            spacing: 8.w,
                                            children: [
                                              SizedBox(
                                                width: 84.w,
                                                child: CachedNetworkImage(
                                                  imageUrl: controller.selectedMenu.path,
                                                  placeholder: (context, url) => ShimmerSkeletonLoader(),
                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  MyText(text: controller.selectedMenu.name),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: List.generate(3, (index) {
                                                      final isSelected = index < (data.starRating);
                                                      final isMiddle = index == 1;
                                      
                                                      return Icon(
                                                        Icons.star,
                                                        color: isSelected ? darkBrown : darkBrown.withValues(alpha: 0.3),
                                                        size: isMiddle ? 36.w : 28.w,
                                                      );
                                                    }),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    _cardMenu(path: dishImg, title: 'Dish'),
                                  ],
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
                              ScrollbarTheme(
                                data: ScrollbarThemeData(
                                  thumbColor: WidgetStateProperty.all(darkBrown),
                                ),
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  thickness: 4.w,
                                  radius: Radius.circular(10.r),
                                  child: SingleChildScrollView(
                                    child: Container(
                                      width: 300.w,
                                      margin: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          MyText(
                                            text: "Evaluation Scores",
                                            color: textLight,
                                            size: 18.sp,
                                          ),
                                          SizedBox(height: 12.h),
                                           GridView.count(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(), 
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 12.w,
                                            mainAxisSpacing: 12.h,
                                            childAspectRatio: 2, 
                                            children: [
                                              _buildScoreBox("Use of Tools", data.useTools),
                                              _buildScoreBox("Procedure", data.procedure),
                                              _buildScoreBox("Safety", data.safety),
                                              _buildScoreBox("Product", data.product),
                                              _buildScoreBox("Time Mgmt", data.timeManagement),
                                              _buildScoreBox("Balance", data.properBalance),
                                              _buildScoreBox("Use of Color", data.useOfColor),
                                              _buildScoreBox("Shape", data.shape),
                                              _buildScoreBox("Garnish", data.useOfGarnish),
                                              _buildScoreBox("Presentation", data.overallPresentation),
                                              _buildScoreBox("Average Score", data.averageScore.toInt()),
                                              _buildScoreBox("Star Rating", data.starRating),
                                            ],
                                          ),
                                          SizedBox(height: 20.h),
                                          MyText(
                                            text: "Comments",
                                            color: textLight,
                                            size: 16.sp,
                                          ),
                                          SizedBox(height: 8.h),
                                          Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.all(12.w),
                                            decoration: BoxDecoration(
                                              color: backgroundColor,
                                              borderRadius: BorderRadius.circular(12.r),
                                              border: Border.all(color: darkBrown),
                                            ),
                                            child: MyText(
                                              text: data.comments,
                                              size: 16.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  MyHeader(text: controller.selectedMenu.title),
                ],
              ),
            ),
          ),
          controller.floatingButton(
            context: context,
            onTap: () {
              controller.submittedCocList.clear();
              context.pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _cardMenu({
    required String path,
    required String title,
  }) {

    return Expanded(
      child: controller.loader.value ? loader() : Stack(
        children: [
          InkWell(
            onTap: () async  {
              context.push(Routes.sliderOption);
              if(context.mounted) await db.getDish(context, type: controller.selectedMenu.menu!.toLowerCase());
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: backgroundColor,
              ),
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Row(
                  spacing: 8.w,
                  children: [
                    MyImgPicture(path: path, size: 84.w),
                    MyText(text: title),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: MyText(text: 'View', fontWeight: FontWeight.w500, size: 14.sp),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildScoreBox(String label, int? value) {
    return controller.loader.value ? loader() : Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: darkBrown),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: label,
            color: darkBrown,
            size: 12.sp,
          ),
          SizedBox(height: 4.h),
          MyText(
            text: value?.toString() ?? "-",
            color: Colors.black,
            size: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget loader(){
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: backgroundColor.withValues(alpha: 0.7),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Row(
          spacing: 8.w,
          children: [],
        ),
      ),
    ).animate(
      delay: Duration(milliseconds: 300),
      onPlay: (controller) => controller.repeat(),
    ).shimmer(duration: Duration(seconds: 1), color: lightBrown);
  }
}
