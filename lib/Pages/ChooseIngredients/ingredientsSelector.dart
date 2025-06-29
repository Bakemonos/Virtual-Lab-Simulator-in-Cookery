import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/Components/custom_button.dart';
import 'package:virtual_lab/Components/custom_header.dart';
import 'package:virtual_lab/Components/custom_text.dart';
import 'package:virtual_lab/Components/shimmer.dart';
import 'package:virtual_lab/Controllers/notifiers.dart';
import 'package:virtual_lab/Models/ingredients.dart';
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

    // Initialize selection list
    controller.selectedList = List.generate(
      ingredients.length,
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
                      margin: EdgeInsets.only(top: 24.h),
                      height: 340.h,
                      decoration: BoxDecoration(
                        color: lightBrown,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 34.h, 16.w, 8.h),
                        child: Column(
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: 400.w,
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
                                    var isSelected =
                                        controller.selectedList[index];
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          isSelected.value = !isSelected.value;
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
                                          padding: EdgeInsets.all(4.w),
                                          child: CachedNetworkImage(
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
                            ),
                            Obx(
                              () => SizedBox(
                                width: 300.w,
                                height: 48.h,
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
                                            setState(() {
                                              //   final selected =
                                              //       List.generate(
                                              //             ingredients.length,
                                              //             (i) =>
                                              //                 controller
                                              //                         .selectedList[i]
                                              //                         .value
                                              //                     ? ingredients[i]
                                              //                     : null,
                                              //           )
                                              //           .whereType<
                                              //             Map<String, dynamic>
                                              //           >()
                                              //           .toList();
                                              //   debugPrint(
                                              //     'Selected: ${selected.length}',
                                              //   );

                                              context.go(Routes.playUI);
                                            });
                                          }
                                          : () {
                                            ;
                                          },
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
