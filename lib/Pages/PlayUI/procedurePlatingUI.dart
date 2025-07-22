import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:virtual_lab/Components/customSvg.dart';
import 'package:virtual_lab/Controllers/controller.dart';
import 'package:virtual_lab/Models/ingredientsModel.dart';
import 'package:virtual_lab/Pages/PlayUI/actionBarUI.dart';
import 'package:virtual_lab/components/customText.dart';
import 'package:virtual_lab/components/shimmer.dart';
import 'package:virtual_lab/utils/helper.dart';
import 'package:virtual_lab/utils/properties.dart';

class MyProcedurePlatingPage extends StatefulWidget {
  const MyProcedurePlatingPage({super.key});

  @override
  State<MyProcedurePlatingPage> createState() => _MyProcedurePlatingPageState();
}

class _MyProcedurePlatingPageState extends State<MyProcedurePlatingPage>
    with TickerProviderStateMixin {
  final controller = AppController.instance;
  final helper = Helper.instance;
  late AnimationController animationController;
  Color acceptedColor = lightBrown;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    controller.animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 310.w,
      child: Column(
        spacing: 16.h,
        children: [
          Expanded(child: Container(decoration: controller.designUI())),
          Expanded( 
            child: DragTarget<IngredientsModel>(
              onAcceptWithDetails: (details) {
                controller.ingredientDragDropData.value = details.data;
              },
              builder: (context, candidateData, rejectedData) {
                return Obx(() {
                  final ingredient = controller.ingredientDragDropData.value;
                  final hasIngredient = ingredient.path.isNotEmpty;

                  return Container(
                    decoration: controller.designUI(
                      backGround: candidateData.isEmpty ? acceptedColor : greenLighter.withValues(alpha: 0.8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.w),
                      child: Row(
                        spacing: 16.w,
                        children: [

                          //* PROCEDURE AREA
                          SizedBox(
                            width: 140.w,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Expanded(child: MySvgPicture(path: board1,iconSize: 160.h)),
                                if (hasIngredient) Draggable(
                                  data: ingredient,
                                  feedback: SizedBox(
                                    height: 80.h,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.w),
                                      child: CachedNetworkImage(
                                        imageUrl: ingredient.path,
                                        placeholder: (context, url) => ShimmerSkeletonLoader(),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  childWhenDragging: Center(
                                    child: MyText(text: ingredient.name),
                                  ),
                                  child: InkWell(
                                    onTap: () => controller.actionOnTap(ingredient),
                                    child: SizedBox(
                                      height: 80.h,
                                      child: CachedNetworkImage(
                                        imageUrl: ingredient.path,
                                        placeholder: (context, url) => ShimmerSkeletonLoader(),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //* ACTION LIST
                          Obx(() {
                            final showActionList = controller.ingredientDragDropData.value.path.isNotEmpty && controller.actionListToggle.value;
                            return controller.actionToggle.value? SizedBox() : (showActionList ? actionListUI() : SizedBox());
                          }),

                          //* ACTION TAPPER
                          if(controller.actionToggle.value) Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: ()=> controller.handleTap(context),
                                child: Container(
                                  width: 48.w,
                                  height: 48.h,
                                  decoration: BoxDecoration(
                                    color: darkBrown,
                                    borderRadius: BorderRadius.circular(4.r),
                                    border: Border.all(width: 2, color: backgroundColor)
                                  ),
                                  child: Center(
                                    child: MySvgPicture(path: tap),
                                  ),
                                ),
                              )
                              
                            ],
                          ),
			
                          //* ACTION BAR
                          if (controller.actionToggle.value) TimingHitBar(
                            animation: controller.animation,
                            controller: animationController,
                          ),
                        
                        ],
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

   Widget actionListUI() {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
          color: darkBrown,
          border: Border.all(width: 2.w, color: backgroundColor),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Obx(() => ListView.builder(
          itemCount: controller.currentActions.length,
          itemBuilder: (context, index) {
            final action = controller.currentActions[index];
            return InkWell(
              onTap: () {
                controller.actionToggle.value = true;
              },
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: MyText(
                  text: action.name,
                  textAlign: TextAlign.center,
                  color: textLight,
                  size: 14.sp,
                ),
              ),
            );
          },
        )),
      ),
    );
  }

  // Widget actionButtonUI(IngredientsModel ingredient) {
  //   return Obx(() => controller.actionToggle.value? SizedBox() :  actionButton(
  //     text: controller.actionListToggle.value ? 'Close' : 'Action',
  //     onPressed: () => controller.actionOnTap(ingredient),
  //   ));
  // }

  // Widget actionButton({
  //   required String text,
  //   required void Function() onPressed,
  // }) {
  //   return SizedBox(
  //     width: 130.w,
  //     child: TextButton(
  //       style: TextButton.styleFrom(backgroundColor: backgroundColor),
  //       onPressed: onPressed,
  //       child: MyText(text: text, size: 14.sp),
  //     ),
  //   );
  // }

}
