import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/Components/customButton.dart';
import 'package:virtual_lab/Components/customHeader.dart';
import 'package:virtual_lab/Components/shimmer.dart';
import 'package:virtual_lab/Controllers/controller.dart';
import 'package:virtual_lab/Json/coc1.dart';
import 'package:virtual_lab/Models/ingredientsModel.dart';
import 'package:virtual_lab/Components/customText.dart';
import 'package:virtual_lab/Utils/helper.dart';
import 'package:virtual_lab/Utils/properties.dart';
import 'package:virtual_lab/Utils/routes.dart';

class MyIngredientsSelectionPage extends StatefulWidget {
  const MyIngredientsSelectionPage({super.key});

  @override
  State<MyIngredientsSelectionPage> createState() =>
      _MyIngredientsSelectionPageState();
}

class _MyIngredientsSelectionPageState
    extends State<MyIngredientsSelectionPage> {
  final controller = AppController.instance;
  final helper = Helper.instance;

  @override
  void initState() {
    super.initState();
    controller.selectedList = List.generate(
      ingredientsample.length,
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
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 6,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                      childAspectRatio: 1,
                                    ),
                                itemCount: ingredientsCOC1.length,
                                itemBuilder: (context, index) {
                                  var data = ingredientsCOC1[index];
                                  var isSelected =
                                      controller.selectedList[index];

                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        final selectedCount =
                                            controller.selectedList
                                                .where((item) => item.value)
                                                .length;

                                        if (!isSelected.value &&
                                            selectedCount >=
                                                controller
                                                    .ingredientLimit
                                                    .value) {
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
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color:
                                            isSelected.value
                                                ? lightGridColor
                                                : lightGridColor.withValues(
                                                  alpha: 0.5,
                                                ),
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.w),
                                        child:
                                            data.path == ''
                                                ? SizedBox()
                                                : CachedNetworkImage(
                                                  imageUrl: data.path,
                                                  placeholder:
                                                      (context, url) =>
                                                          ShimmerSkeletonLoader(),
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
                            Obx(
                              () => SizedBox(
                                height: 48.h,
                                child: Padding(
                                  padding: EdgeInsetsGeometry.symmetric(
                                    horizontal: 60.w,
                                  ),
                                  child: MyButton(
                                    text:
                                        controller.seconds.value == 0
                                            ? 'CONFIRM'
                                            : helper.formatSecondsToMMSS(
                                              controller.seconds.value,
                                            ),
                                    onTap:
                                        controller.seconds.value == 0
                                            ? () {
                                              context.go(Routes.playUI);
                                              // sample();
                                            }
                                            : () {
                                              context.go(Routes.playUI);
                                              // sample();
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

  void sample() {
    controller.ingredientsData.clear();

    for (int i = 0; i < ingredientsCOC1.length; i++) {
      if (controller.selectedList[i].value) {
        controller.ingredientsData.add(
          IngredientsModel(
            name: ingredientsCOC1[i].name,
            path: ingredientsCOC1[i].path,
            actions: null,
            actionStatus: null,
          ),
        );
      }
    }

    controller.ingredientsData.refresh();
    debugPrint(
      '\nDATA  \n'
      'type : ${controller.typeSelected!.type}\n'
      'ingredients : ${controller.ingredientsData.map((e) => {'name': e.name}).toList()}\n',
    );
  }
}
