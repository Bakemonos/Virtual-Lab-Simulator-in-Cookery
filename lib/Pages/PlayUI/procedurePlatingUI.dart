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
  late Animation<double> animation;
  Color acceptedColor = lightBrown;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void handleTap() {
    double position = animation.value;
    double centerStart = 0.4;
    double centerEnd = 0.6;

    if (position >= centerStart && position <= centerEnd) {
      print("🎯 Perfect");
    } else if ((position - centerStart).abs() < 0.1 ||
        (position - centerEnd).abs() < 0.1) {
      print("👍 Good");
    } else {
      print("❌ Miss");
    }
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
                debugPrint(details.data.type);
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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  MySvgPicture(
                                    path: board1,
                                    iconSize: hasIngredient ? 140.h : 160.h,
                                  ),
                                  if (hasIngredient)
                                    Draggable(
                                      data: ingredient,
                                      feedback: SizedBox(
                                        height: 80.h,
                                        child: Padding(
                                          padding: EdgeInsets.all(8.w),
                                          child: CachedNetworkImage(
                                            imageUrl: ingredient.path,
                                            placeholder: (context, url) =>
                                                ShimmerSkeletonLoader(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      childWhenDragging: Center(
                                        child: MyText(text: ingredient.name),
                                      ),
                                      child: SizedBox(
                                        height: 80.h,
                                        child: CachedNetworkImage(
                                          imageUrl: ingredient.path,
                                          placeholder: (context, url) =>
                                              ShimmerSkeletonLoader(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              if (hasIngredient) actionButtonUI(ingredient),
                            ],
                          ),

                          if () const Spacer(),

                          //* ACTION LIST
                          Obx(() {
                            final showActionList = controller.ingredientDragDropData.value.path.isNotEmpty && controller.actionToggle.value;
                            return showActionList ? actionListUI() : SizedBox();
                          }),
			
                          //* ACTION BAR
                          if ()
                            GestureDetector(
                              onTap: handleTap,
                              child: TimingHitBar(
                                animation: animation,
                                controller: animationController,
                              ),
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

  Widget actionButtonUI(IngredientsModel ingredient) {
    return Row(
      spacing: 8.w,
      children: [
        actionButton(text: 'Discard', onPressed: () => controller.discard()),
        Obx(() => actionButton(
          text: controller.actionToggle.value ? 'Close' : 'Action',
          onPressed: () => controller.actionOnTap(ingredient),
        )),
      ],
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
                final isSelected =
                    controller.selectedActionIndex.value == index;

                return InkWell(
                  onTap: () {
                    controller.selectedActionIndex.value = index;
                  },
                  child: Container(
                    color: isSelected ? Colors.orange.shade300 : Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: MyText(
                        text: action.name,
                        textAlign: TextAlign.center,
                        color: textLight,
                        size: 14.sp,
                      ),
                    ),
                  ),
                );
              },
            )),
      ),
    );
  }

  Widget actionButton({
    required String text,
    required void Function() onPressed,
  }) {
    return TextButton(
      style: TextButton.styleFrom(backgroundColor: backgroundColor),
      onPressed: onPressed,
      child: MyText(text: text, size: 14.sp),
    );
  }

}
