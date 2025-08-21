import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:virtual_lab/components/custom_svg.dart';
import 'package:virtual_lab/components/custom_text.dart';
import 'package:virtual_lab/components/shimmer.dart';
import 'package:virtual_lab/controllers/controller.dart';
import 'package:virtual_lab/json/default_ingredients.dart';
import 'package:virtual_lab/models/ingredients_model.dart';
import 'package:virtual_lab/services/services.dart';
import 'package:virtual_lab/utils/properties.dart';

class MyInventoryPage extends StatefulWidget {
  const MyInventoryPage({super.key});

  @override
  State<MyInventoryPage> createState() => _MyInventoryPageState();
}

class _MyInventoryPageState extends State<MyInventoryPage> {
  final controller = AppController.instance;
  final db = ApiServices.instance;
  Color acceptedColor = lightBrown;

  @override
  void initState() {
     WidgetsBinding.instance.addPostFrameCallback((_) {
      db.getInventory(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130.w,
      child: Column(
        children: [
          Obx(() => AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => SlideTransition(
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
            child: controller.bagToggle.value ? SizedBox.shrink(key: ValueKey('trashBagClosed'))
            : DragTarget<IngredientsModel>(
              onAcceptWithDetails: (details) { 
                controller.discard();
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  key: ValueKey('trashBagOpen'),
                  margin: EdgeInsets.only(bottom: 16.h),
                  width: double.infinity,
                  decoration: controller.designUI(backGround: candidateData.isEmpty ? acceptedColor : redLighter.withValues(alpha: 0.8)),
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
                );
              },
            ),
          )),
          Flexible(
            fit: FlexFit.loose,
            child: Container(
              width: double.infinity,
              decoration: controller.designUI(),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Obx(
                  () => AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => SlideTransition(
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
                    child: controller.bagToggle.value ? inventory(controller) : inventoryToggle(controller),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget inventoryToggle(AppController controller) {
    return InkWell(
      key: ValueKey('inventoryClosed'),
      onTap: controller.bagOntap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MySvgPicture(path: bag, iconSize: 60.h),
          SizedBox(height: 4.h),
          MyText(text: 'Bag', color: textLight, size: 16.sp),
        ],
      ),
    );
  }

  Widget inventory(AppController controller) {
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
        Flexible(
          fit: FlexFit.loose,
          child: Obx(() {
            final ingredients = [
              ...defaultIngredients,
              ...controller.typeInventory.value.ingredients,
            ];
            
            return GridView.builder(
              padding: EdgeInsets.zero,
              physics: AlwaysScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1, 
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                var data = ingredients[index];
                return LongPressDraggable(
                  data: IngredientsModel(
                    name: data.name,
                    image: data.image,
                    category: data.category,
                    actions: data.actions,
                    dragKey: 'procedure', 
                  ),
                  feedback: SizedBox(
                    height: 80.h,
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: CachedNetworkImage(
                        imageUrl: data.image,
                        placeholder: (context, url) => ShimmerSkeletonLoader(),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error),
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
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: lightGridColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.w),
                          child: CachedNetworkImage(
                            imageUrl: data.image,
                            placeholder: (context, url) => ShimmerSkeletonLoader(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
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
            );
          }),
        ),
      ],
    );
  }

  Widget equipment(AppController controller) {
    return Column(
      key: ValueKey('equipmentOpened'),
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
        Flexible(
          fit: FlexFit.loose,
          child: Obx(() {
            final ingredients = controller.typeInventory.value.ingredients;
            return GridView.builder(
              padding: EdgeInsets.zero,
              physics: AlwaysScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                var data = ingredients[index];
                return Stack(
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: lightGridColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: CachedNetworkImage(
                          imageUrl: data.image,
                          placeholder: (context, url) => ShimmerSkeletonLoader(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
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
                );
              },
            );
          }),
        ),
      ],
    );
  }

}

