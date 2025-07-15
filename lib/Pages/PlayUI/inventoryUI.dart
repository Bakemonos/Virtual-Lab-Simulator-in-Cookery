import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:virtual_lab/Components/customSvg.dart';
import 'package:virtual_lab/Components/customText.dart';
import 'package:virtual_lab/Components/shimmer.dart';
import 'package:virtual_lab/Controllers/controller.dart';
import 'package:virtual_lab/Models/ingredientsModel.dart';
import 'package:virtual_lab/Utils/properties.dart';

class MyInventoryPage extends StatelessWidget {
  const MyInventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppController.instance;

    return SizedBox(
      width: 145.w,
      child: Column(
        spacing: 16.h,
        children: [
          Container(
            height: 70.h,
            decoration: controller.designUI(),
            child: Center(
              child: MyText(
                text: '03:00',
                size: 24.sp,
                color: textLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: controller.designUI(),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Obx(() => controller.bagToggle.value ? inventory(controller) : inventoryToggle(controller)),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget inventoryToggle(AppController controller) {
    return Column(
      spacing: 16.h,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          spacing: 4.h,
          children: [
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: darkBrown,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(width: 2.w, color: backgroundColor),
              ),
            ),
            MyText(text: 'Trashbin', color: textLight, size: 12.sp),
          ],
        ),
        InkWell(
          onTap: controller.bagOntap,
          child: Column(
            spacing: 4.h,
            children: [
              MySvgPicture(path: bag),
              MyText(text: 'Bag', color: textLight, size: 12.sp),
            ],
          ),
        ),
      ],
    );
  }

  Widget inventory(AppController controller) {
    return Column(
      spacing: 16.h,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          style: ButtonStyle(
            padding: WidgetStatePropertyAll(EdgeInsetsGeometry.zero),
            shape: WidgetStatePropertyAll(
              BeveledRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(4.r),
              ),
            ),
          ),
          onPressed: controller.bagOntap,
          icon: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              color: lightGridColor.withValues(alpha: 0.5),
            ),
            padding: EdgeInsets.all(10.w),
            child: Center(
              child: MySvgPicture(path: back, iconColor: textLight),
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: ingredientsample.length,
            itemBuilder: (context, index) {
              var data = ingredientsample[index];
              var isSelected = controller.selectedList[index];
              return InkWell(
                onTap: () {},
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        isSelected.value
                            ? lightGridColor
                            : lightGridColor.withValues(alpha: 0.5),
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
              );
            },
          ),
        ),
      ],
    );
  }

}