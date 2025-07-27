import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/components/custom_button.dart';
import 'package:virtual_lab/components/custom_svg_picture.dart';
import 'package:virtual_lab/components/custom_text.dart';
import 'package:virtual_lab/components/shimmer.dart';
import 'package:virtual_lab/controllers/controller.dart';
import 'package:virtual_lab/models/ingredients_model.dart';
import 'package:virtual_lab/utils/properties.dart';

class MyProcessPage extends StatelessWidget {
  const MyProcessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppController.instance;

    return Expanded(
      child: Container(
        decoration: controller.designUI(),
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Column(
            children: [
              DragTarget<IngredientsModel>(
                onWillAcceptWithDetails: (details) => details.data.dragKey == 'submit' && details.data.actions.isEmpty,
                onAcceptWithDetails: (details) {
                  confirmIngredient(
                    controller: controller,
                    type: controller.typeSelected!.menu ?? '',
                    studentId: controller.userData.value.id!,
                    take: 'take_one',
                  );
                },
                builder: (context, candidateData, rejectedData){
                  return Container(
                    decoration: BoxDecoration(
                      color: candidateData.isEmpty ? darkBrown.withValues(alpha: 0.6) : greenLighter.withValues(alpha: 0.8) ,
                      borderRadius: BorderRadius.circular(8.r)
                    ),
                    width: 200.w, height: 200.h,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CachedNetworkImage(
                        imageUrl: kaldero,
                        placeholder: (context, url) => ShimmerSkeletonLoader(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  SizedBox(
                    width: 80.w,
                    child: Column(
                      spacing: 8.h,
                      children: [
                        controller.actionButton(text: 'Check', onPressed: ()=> checkStatus(context, controller)),
                        controller.actionButton(text: 'Submit', onPressed: ()=> submitCreateDish(context, controller)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget preparedIngredients(AppController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              BeveledRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(4.r),
              ),
            ),
          ),
          onPressed: controller.equipmentOntap,
          icon: Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              color: lightGridColor.withValues(alpha: 0.5),
            ),
            child: Center(
              child: MySvgPicture(path: back, iconColor: textLight),
            ),
          ),
        ),
        SizedBox(
          height: 80.h,
          child: Obx((){
            final prepared = controller.preparedData.value.ingredients;

            return GridView.builder(  
              padding: EdgeInsets.all(8.w),
              scrollDirection: Axis.horizontal,
              physics: AlwaysScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: prepared.length,
              itemBuilder: (context, index) {
                var data = prepared[index];

                return LongPressDraggable(
                  data: data,
                  feedback: SizedBox(
                    height: 80.h,
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: CachedNetworkImage(
                        imageUrl: data.path,
                        placeholder: (context, url) => ShimmerSkeletonLoader(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  childWhenDragging: Container(
                    decoration: BoxDecoration(
                      color: lightGridColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(child: MyText(text: data.name)),
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: lightGridColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: CachedNetworkImage(
                          imageUrl: data.path,
                          placeholder: (context, url) => ShimmerSkeletonLoader(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fit: BoxFit.contain,
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
    );
  }

  Widget equipToggler({
    required AppController controller,
    required String label,
    required iconPath,
  }) {
    return InkWell(
      onTap: controller.equipmentOntap,
      child: Column(
        spacing: 4.h,
        children: [
          MySvgPicture(path: iconPath, iconSize: 48.w),
          MyText(text: label, color: textLight, size: 12.sp),
        ],
      ),
    );
  }

  void checkStatus(BuildContext context, AppController controller) {
    Row repeatedUI(String label, String value) {
      return Row(
        children: [
          MyText(text: '$label: ', fontWeight: FontWeight.w500),
          MyText(text: value),
        ],
      );
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: 360.w,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.h,
                children: [
                  Row(
                    spacing: 14.w,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(logo, width: 32.w),
                      MyText(text: 'Ingredient Status'),
                      const Spacer(),
                      IconButton(
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll(
                            BeveledRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(4.r),
                            ),
                          ),
                        ),
                        onPressed: () => context.pop(),
                        icon: Container(
                          width: 32.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            color: lightButtonBackground.withValues(alpha: 0.3),
                          ),
                          child: Center(
                            child: MySvgPicture(
                              path: close,
                              iconColor: darkBrown,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Obx(() {
                    final preparedData = controller.preparedData.value.ingredients;

                    return Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...preparedData.asMap().entries.map((entry) {
                              final index = entry.key + 1; 
                              final ingredient = entry.value;
                              final actions = ingredient.actions;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  repeatedUI('$index: Ingredient', ingredient.name),  
                                  repeatedUI('Category', ingredient.category),
                                  if (actions.isNotEmpty)
                                    ...actions.asMap().entries.map((entry){
                                      final index = entry.key + 1; 
                                      final a = entry.value;

                                      return Container(
                                        margin: EdgeInsetsGeometry.only(left: 16.w),
                                        child: MyText(
                                            text: '$index Action: ${a.action}, Tool: ${a.tool}, Status: ${a.status}',
                                            fontWeight: FontWeight.w500,
                                            size: 16.sp,
                                        ),
                                      );
                                    }),
                                  SizedBox(height: 16.h),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  })
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void submitCreateDish(BuildContext context, AppController controller) {
    final borderColor = lightBrown.withValues(alpha: 0.3);
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          backgroundColor: Colors.transparent,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 360.w,
                    minWidth: 360.w,
                    maxHeight: MediaQuery.of(context).size.height * 0.9,
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(16.r),
                    color: backgroundColor,
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: SingleChildScrollView(
                        child: Column(
                          spacing: 8.h,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(logo, width: 32.w),
                                SizedBox(width: 14.w),
                                MyText(text: 'Submit dish'),
                                const Spacer(),
                                IconButton(
                                  onPressed: () => context.pop(),
                                  icon: Container(
                                    width: 32.w,
                                    height: 32.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.r),
                                      color: lightButtonBackground.withAlpha(77),
                                    ),
                                    child: Center(
                                      child: MySvgPicture(
                                        path: close,
                                        iconColor: darkBrown,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            controller.repeatedDropdown(
                              label: 'Type',
                              hint: 'Select Type', 
                              items: ['Sauce', 'Main dish', 'Soup'],
                              selectedValue: controller.category.value,
                              defaultBorderColor: borderColor, 
                              onChanged: (value) {
                                controller.category.value = value!;
                              },
                            ),
                            controller.repeatedTextInput(
                              label: 'Dish name', 
                              controller: controller.nameDishController,
                              defaultBorderColor: borderColor,
                            ),
                            SizedBox(height: 16.h),
                            MyButton(
                              text: 'Submit', 
                              onTap: () async {
                                if (controller.tap) return;
                                controller.tap = true;
                                await controller.createDish();
                                if(context.mounted) context.pop();
                                controller.tap = false; 
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void confirmIngredient({
    required AppController controller,
    required String type,
    required String studentId,
    required String take,
  }) {
    final currentIngredient = controller.ingredientActionData.value;

    if (currentIngredient.name.isEmpty) return; // prevents submitting empty ingredient

    if (!controller.preparedIngredients.contains(currentIngredient)) {
      controller.preparedIngredients.add(currentIngredient);
    }

    final newInventory = InventoryModel(
      type: type,
      studentId: studentId,
      take: take,
      ingredients: controller.preparedIngredients.toList(),
    );

    controller.preparedData.value = newInventory;
    controller.preparedInventories.add(newInventory);

    // Clear data only after processing
    controller.ingredientDragDropData.value = IngredientsModel.empty();
    controller.ingredientActionData.value = IngredientsModel.empty();
    controller.selectedActions.clear();
  }


}


// const Spacer(),
// Obx(
//   () => controller.equipmentToggle.value ? preparedIngredients(controller)
//   : SizedBox(
//     width: double.infinity,
//     child: Column(
//       spacing: 12.h,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         equipToggler(controller: controller, iconPath: box, label: 'Inventory'),
//         equipToggler(controller: controller, iconPath: basket, label: 'Basket'),
//       ],
//     ),
//   ),
// ),
