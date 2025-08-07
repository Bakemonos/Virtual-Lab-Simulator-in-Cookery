import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/Json/equipment.dart';
import 'package:virtual_lab/components/custom_button.dart';
import 'package:virtual_lab/components/custom_svg_picture.dart';
import 'package:virtual_lab/components/custom_text.dart';
import 'package:virtual_lab/components/shimmer.dart';
import 'package:virtual_lab/controllers/controller.dart';
import 'package:virtual_lab/models/ingredients_model.dart';
import 'package:virtual_lab/utils/properties.dart';

class MyProcessPage extends StatefulWidget {
  const MyProcessPage({super.key});

  @override
  State<MyProcessPage> createState() => _MyProcessPageState();
}

class _MyProcessPageState extends State<MyProcessPage> {
  final submitDishFormKey = GlobalKey<FormState>();
  final controller = AppController.instance;
  
  @override
  Widget build(BuildContext context) {

    return Flexible(
      fit: FlexFit.loose,
      child: Container(
        decoration: controller.designUI(),
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: SizedBox(
            width: double.infinity,
            child: Obx(()=> controller.changeToolToggle.value ? kitchenEquipmentUI() : processUI()),
          ),
        ),
      ),
    ); 
  }

  Widget kitchenEquipmentUI(){
    return Column(
      children: [
        IconButton(
          onPressed: controller.changeToolToggler,
          icon: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              color: lightGridColor.withValues(alpha: 0.5),
            ),
            padding: EdgeInsets.all(8.w),
            child: Center(
              child: MySvgPicture(path: back, iconColor: textLight),
            ),
          ),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: GridView.builder(
            padding: EdgeInsets.zero,
            itemCount: cookingEquipment.length,
            physics: AlwaysScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 8, 
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              var data = cookingEquipment[index];
        
              return InkWell(
                onTap: (){
                  controller.changeToolToggler();
                  controller.cookingToolData.value = data;
                },
                child: Stack(
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: controller.cookingToolData.value == data ? lightGridColor : lightGridColor.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: CachedNetworkImage(
                          imageUrl: data.image,
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
                          color: lightBrown.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.r), bottomRight: Radius.circular(8.r))
                        ),
                        child: MyText(text: data.name, textAlign: TextAlign.center, color: textLight, size: 16.sp,),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ),
      ],
    );
  }

  Widget processUI() {
    return Column(
      children: [
        InkWell(
          onTap: controller.changeToolToggler,
          child: DragTarget<IngredientsModel>(
            onWillAcceptWithDetails: (details) => details.data.dragKey == 'submit' && details.data.actions.isEmpty,
            onAcceptWithDetails: (details) {
              controller.acceptIngredient(
                type: controller.typeSelected.value!.menu ?? '', 
                studentId: controller.userData.value.id!,
                take: 'take_one',
              );
              controller.equipmentData.add(controller.cookingToolData.value); //TODO ADD EQUIPMENT
            },
            builder: (context, candidateData, rejectedData){
              return Column(
                children: [
                  SizedBox(
                    width: 200.w, height: 200.h,
                    child: Stack(
                      children: [
                        Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: candidateData.isEmpty ? darkBrown.withValues(alpha: 0.6) : greenLighter.withValues(alpha: 0.8) ,
                            borderRadius: BorderRadius.circular(8.r)
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(24.w),
                            child: CachedNetworkImage(
                              imageUrl: controller.cookingToolData.value.image,
                              placeholder: (context, url) => ShimmerSkeletonLoader(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            onPressed: controller.changeToolToggler, 
                            icon: Icon(Icons.repeat, color: textLight, size: 40.w),
                          ),
                        ),
                      ],
                    ),
                  ),
                  MyText(text: controller.cookingToolData.value.name, size: 16.sp, fontWeight: FontWeight.w500, color: textLight)
                ],
              );
            },
          ),
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
                  controller.actionButton(text: 'Check', onPressed: checkStatus),
                  controller.actionButton(text: 'Submit', onPressed: (){
                    controller.resetErrorHandler();
                    submitCreateDish();
                  }),
                ],
              ),
            ),
          ],
        ),
      
      ],
    );
  }

  Widget preparedIngredients() {
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

  void checkStatus() {
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
            width: 460.w,
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

                    return Flexible(
                      fit: FlexFit.loose,
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
                                      final color = switch (a.status) {
                                        'perfect' => greenLighter,
                                        'good' => Colors.amber,
                                        _ => redLighter,
                                      };

                                      return Container(
                                        margin: EdgeInsetsGeometry.only(left: 16.w),
                                        child: Row(
                                          children: [
                                            MyText(
                                              text: '$index Action: ${a.action}, Tool: ${a.tool}, Status:',
                                              fontWeight: FontWeight.w500,
                                              size: 16.sp,
                                            ),
                                            MyText(
                                              text: ' ${a.status}',
                                              fontWeight: FontWeight.w500,
                                              size: 16.sp,
                                              color: color,
                                            ),
                                          ],
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

  void submitCreateDish() {
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
                            Form(
                              key: submitDishFormKey,
                              child: Column(
                                children: [
                                  Obx(
                                    () => controller.repeatedDropdown(
                                      hasError: controller.typeErrorText.value.isNotEmpty,
                                      errorText: controller.typeErrorText,
                                      selectedValue: controller.category.value,
                                      defaultBorderColor: borderColor, 
                                      label: 'Type',
                                      hint: 'Select Type', 
                                      items: ['Sauce', 'Main dish', 'Soup'],
                                      onChanged: (value) {
                                        controller.category.value = value!;
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  controller.repeatedTextInput(
                                    label: 'Dish name', 
                                    errorText: controller.dishNameErrorText,
                                    controller: controller.nameDishController,
                                    defaultBorderColor: borderColor,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),
                            MyButton(
                              text: 'Submit', 
                              onTap: () async {
                                final form = submitDishFormKey.currentState;
                                if (form != null && form.validate()) {
                                  if (controller.tap) return;
                                  controller.tap = true;
                                  controller.errorHandlerSSubmitDish();
                                  await controller.createDish(context);
                                  if (context.mounted) await controller.getDish(context); 
                                  controller.tap = false; 
                                }
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

}
