import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:virtual_lab/Components/customSvgPicture.dart';
import 'package:virtual_lab/Components/customText.dart';
import 'package:virtual_lab/Components/shimmer.dart';
import 'package:virtual_lab/Controllers/controller.dart';
import 'package:virtual_lab/Models/ingredientsModel.dart';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DragTarget<List<IngredientsModel>>(
                onAcceptWithDetails: (details) {
                  controller.processData.value = details.data;
                },
                builder: (context, candidateData, rejectedData){
                  return SizedBox(
                    width: 180.w,
                    height: 80.h,
                    child: CachedNetworkImage(
                      imageUrl: kaldero,
                      placeholder: (context, url) => ShimmerSkeletonLoader(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.contain,
                    ),
                  );
                },
              ),
              controller.actionButton(text: 'Check', onPressed: (){}),
              const Spacer(),
              Obx(
                () => controller.equipmentToggle.value ? preparedIngredients(controller)
                : SizedBox(
                  width: double.infinity,
                  child: Column(
                    spacing: 12.h,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      equipToggler(controller: controller, iconPath: box, label: 'Inventory'),
                      equipToggler(controller: controller, iconPath: basket, label: 'Basket'),
                    ],
                  ),
                ),
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
            width: 48.w,
            height: 48.h,
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
          height: 100.h,
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
  
}
