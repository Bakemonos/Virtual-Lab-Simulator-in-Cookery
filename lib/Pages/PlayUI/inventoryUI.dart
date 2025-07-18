import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:virtual_lab/Components/customSvg.dart';
import 'package:virtual_lab/Components/customText.dart';
import 'package:virtual_lab/Components/shimmer.dart';
import 'package:virtual_lab/Controllers/controller.dart';
import 'package:virtual_lab/Models/ingredientsModel.dart';
import 'package:virtual_lab/utils/properties.dart';

class MyInventoryPage extends StatefulWidget {
  const MyInventoryPage({super.key});

  @override
  State<MyInventoryPage> createState() => _MyInventoryPageState();
}

class _MyInventoryPageState extends State<MyInventoryPage> {
  final controller = AppController.instance;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 145.w,
      child: Column(
        children: [
          Obx(() {
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder:
                  (child, animation) => SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0, 1),
                      end: Offset.zero,
                    ).animate(animation),
                    child: ScaleTransition(
                      scale: Tween<double>(
                        begin: 0.20,
                        end: 1.0,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
              child:
                  controller.bagToggle.value
                      ? SizedBox.shrink(key: ValueKey('trashBagClosed'))
                      : Container(
                        key: ValueKey('trashBagOpen'),
                        margin: EdgeInsets.only(bottom: 16.h),
                        width: double.infinity,
                        decoration: controller.designUI(),
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MySvgPicture(path: trashbag),
                              MyText(
                                text: 'Trash bag',
                                color: textLight,
                                size: 12.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
            );
          }),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: controller.designUI(),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Obx(
                  () => AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    transitionBuilder:
                        (child, animation) => SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0, 0.5),
                            end: Offset.zero,
                          ).animate(animation),
                          child: ScaleTransition(
                            scale: Tween<double>(
                              begin: 0.5,
                              end: 1.0,
                            ).animate(animation),
                            child: child,
                          ),
                        ),
                    child:
                        controller.bagToggle.value
                            ? inventoryToggle(controller)
                            : inventory(controller),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget inventory(AppController controller) {
    return InkWell(
      key: ValueKey('inventoryClosed'),
      onTap: controller.bagOntap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MySvgPicture(path: bag),
          SizedBox(height: 4.h),
          MyText(text: 'Bag', color: textLight, size: 12.sp),
        ],
      ),
    );
  }

  Widget inventoryToggle(AppController controller) {
    return Column(
      key: ValueKey('inventoryOpened'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
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
        SizedBox(height: 16.h),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.zero,
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
              return Obx(
                () => InkWell(
                  onTap: () => isSelected.value = !isSelected.value,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
