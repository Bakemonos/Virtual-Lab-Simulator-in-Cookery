import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/components/custom_button.dart';
import 'package:virtual_lab/components/custom_header.dart';
import 'package:virtual_lab/components/shimmer.dart';
import 'package:virtual_lab/controllers/controller.dart';
import 'package:virtual_lab/json/coc1.dart';
import 'package:virtual_lab/components/custom_text.dart';
import 'package:virtual_lab/utils/helper.dart';
import 'package:virtual_lab/utils/properties.dart';
import 'package:virtual_lab/utils/routes.dart';

class MyIngredientsSelectionPage extends StatefulWidget {
  const MyIngredientsSelectionPage({super.key});

  @override
  State<MyIngredientsSelectionPage> createState() => _MyIngredientsSelectionPageState();
}

class _MyIngredientsSelectionPageState extends State<MyIngredientsSelectionPage> {
  final controller = AppController.instance;
  final helper = Helper.instance;

  @override
  void initState() {
    super.initState();
    controller.selectedList = List.generate(
      ingredientsCOC1.length,
      (_) => false.obs,
    );
    controller.startTimer();
  }

  @override
  Widget build(BuildContext context) {
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
                      width: 500.w,
                      margin: EdgeInsets.only(top: 24.h),
                      decoration: BoxDecoration(
                        color: lightBrown,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 34.h, 16.w, 16.h),
                        child: Column(
                          spacing: 8.h,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: MyText(
                                text:
                                    '${controller.selectedList.where((item) => item.value).length} / ${controller.ingredientLimit.value}',
                                color: textLight,
                                size: 14.sp,
                              ),
                            ),
                            Expanded(
                              child: GridView.builder(
                                padding: EdgeInsets.all(8.w),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 6,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: 1,
                                ),
                                itemCount: ingredientsCOC1.length,
                                itemBuilder: (context, index) {
                                  var data = ingredientsCOC1[index];
                                  var isSelected = controller.selectedList[index];

                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        final selectedCount = controller.selectedList.where((item) => item.value).length;

                                        if (!isSelected.value && selectedCount >= controller.ingredientLimit.value) {
                                          debugPrint(
                                            'Limit Reached'
                                            'You can only select up to 10 ingredients.',
                                          );
                                          return;
                                        }

                                        setState(() {
                                          isSelected.value = !isSelected.value;
                                        });
                                      });
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: isSelected.value ? lightGridColor : lightGridColor.withValues(alpha: 0.5),
                                            borderRadius: BorderRadius.circular(8.r),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.w),
                                            child: data.path == ''? SizedBox() : CachedNetworkImage(
                                              imageUrl: data.path,
                                              placeholder: (context, url) => ShimmerSkeletonLoader(),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: lightBrown.withValues(alpha: 0.6),
                                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.r), bottomRight: Radius.circular(8.r))
                                            ),
                                            child: MyText(text: data.name, textAlign: TextAlign.center, color: textLight, size: 11.sp, overflow: TextOverflow.ellipsis),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Obx(
                              () => SizedBox(
                                height: 48.h,
                                child: Padding(
                                  padding: EdgeInsetsGeometry.symmetric(
                                    horizontal: 60.w,
                                  ),
                                  child: MyButton(
                                    text: controller.seconds.value == 0 ? 'CONFIRM' : helper.formatSecondsToMMSS(controller.seconds.value),
                                    onTap: () async {
                                      if(controller.seconds.value == 0) await controller.ingredientsCreate(context);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  MyHeader(text: 'PICK INGREDIENTS'),
                ],
              ),
            ),
          ),
          controller.floatingButton(
            context: context,
            onTap: () {
              context.go(Routes.foodChoices);
            },
          ),
        ],
      ),
    );
  }
}
