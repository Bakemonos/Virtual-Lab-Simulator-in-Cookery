import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/Utils/routes.dart';
import 'package:virtual_lab/components/custom_svg.dart';
import 'package:virtual_lab/controllers/controller.dart';
import 'package:virtual_lab/json/tools.dart';
import 'package:virtual_lab/models/ingredients_model.dart';
import 'package:virtual_lab/components/custom_hit_bar.dart';
import 'package:virtual_lab/components/custom_text.dart';
import 'package:virtual_lab/components/shimmer.dart';
import 'package:virtual_lab/utils/enum.dart';
import 'package:virtual_lab/utils/helper.dart';
import 'package:virtual_lab/utils/properties.dart';

class MyProcedurePlatingPage extends StatefulWidget {
  const MyProcedurePlatingPage({super.key});

  @override
  State<MyProcedurePlatingPage> createState() => _MyProcedurePlatingPageState();
}

class _MyProcedurePlatingPageState extends State<MyProcedurePlatingPage> with TickerProviderStateMixin {
  final controller = AppController.instance;
  final helper = Helper.instance;

  late AnimationController animationController;
  Color acceptedColor = lightBrown;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
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
      width: 320.w,
      height: 1.sh, 
      child: Column(
        children: [

          //? DISPLAY DATA
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: controller.designUI(),
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          controller.actionButton(
                            text: 'View Instruction',
                            onPressed: () => controller.instruction(context, controller.typeSelected!),
                          ),
                          SizedBox(width: 8.w),
                          controller.actionButton(
                            text: 'Get',
                            onPressed: () => controller.getDish(context),
                          ),
                          SizedBox(width: 8.w),
                          Obx(() {
                            final requiredNames = controller.typeSelected!.instructions.map((req) => helper.toCamelCase(req.name)).toList();
                            final submittedCategories = controller.submittedCocList.map((dish) => dish.category).toList();
                            final requireDish = requiredNames.every((name) => submittedCategories.contains(name));

                            return controller.actionButton(
                              text: 'Proceed',
                              onPressed: () {
                                if (requireDish) {
                                  context.push(Routes.plating);
                                } else {
                                  controller.showFloatingSnackbar(
                                    context: context,
                                    message: 'All dish must be prepared',
                                  );
                                }
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: controller.typeSelected!.instructions.asMap().entries.map((entry) {
                        final index = entry.key + 1;
                        final goal = entry.value;
                        final goalCategory = goal.name;

                        final alreadySubmitted = controller.submittedCocList.any((item) {
                          return item.category == helper.toCamelCase(goalCategory);
                        });

                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          child: MyText(
                            text: '$index. ${goal.name}',
                            fontWeight: FontWeight.w500,
                            color: textLight,
                            size: 16.sp,
                            decoration: alreadySubmitted ? TextDecoration.lineThrough : TextDecoration.none,
                          ),
                        );
                      }).toList(),
                    )),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),
          //? PROCEDURE AREA

          Expanded(
            child: DragTarget<IngredientsModel>(
              onWillAcceptWithDetails: (details) => details.data.dragKey == 'procedure',
              onAcceptWithDetails: (details) {
                controller.actionListToggle.value = false;
                controller.actionToggle.value = false;
                controller.ingredientDragDropData.value = details.data;
                controller.selectedActions.clear();
              },
              builder: (context, candidateData, rejectedData) {
                return Obx(() {
                  final ingredient = controller.ingredientDragDropData.value;
                  final hasIngredient = ingredient.path.isNotEmpty;

                  return Container(
                    decoration: controller.designUI(
                      backGround: candidateData.isEmpty ? acceptedColor : greenLighter.withOpacity(0.8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Row(
                        children: [
                          SizedBox(
                            height: double.infinity,
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: 140.w,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      MySvgPicture(path: board1, iconSize: 160.h),
                                      if (hasIngredient)
                                        Draggable<IngredientsModel>(
                                          data: IngredientsModel(
                                            name: ingredient.name,
                                            path: ingredient.path,
                                            category: ingredient.category,
                                            actions: ingredient.actions,
                                            dragKey: 'submit',
                                          ),
                                          onDragStarted: () {
                                            controller.bagToggle.value = false;
                                          },
                                          feedback: SizedBox(
                                            height: 80.h,
                                            width: 80.w,
                                            child: Padding(
                                              padding: EdgeInsets.all(8.w),
                                              child: CachedNetworkImage(
                                                imageUrl: ingredient.path,
                                                placeholder: (context, url) => const ShimmerSkeletonLoader(),
                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          childWhenDragging: Center(child: MyText(text: ingredient.name)),
                                          child: InkWell(
                                            onTap: () => controller.actionOnTap(ingredient),
                                            child: SizedBox(
                                              height: 80.h,
                                              width: 80.w,
                                              child: CachedNetworkImage(
                                                imageUrl: ingredient.path,
                                                placeholder: (context, url) => const ShimmerSkeletonLoader(),
                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Obx(() => Row(
                                    children: [
                                      if (hasIngredient)
                                        controller.actionButton(
                                          text: 'Check',
                                          onPressed: () {
                                            final ingredient = controller.ingredientActionData.value;
                                            if (ingredient.actions.isNotEmpty) {
                                              controller.preparedIngredients.add(ingredient);
                                              checkStatus(ingredient);
                                            }
                                          },
                                        ),
                                      SizedBox(width: 8.w),
                                      if (controller.toolListToggle.value)
                                        controller.actionButton(
                                          text: 'Back',
                                          onPressed: () {
                                            controller.toolListToggle.value = false;
                                            controller.actionListToggle.value = true;
                                          },
                                        ),
                                    ],
                                  )),
                                )
                              ],
                            ),
                          ),

                          SizedBox(width: 16.w),

                          //? TOOL OR ACTION LIST
                          Obx(() {
                            final hasIngredient = controller.ingredientDragDropData.value.path.isNotEmpty;
                            if (!hasIngredient) return const SizedBox();
                            if (controller.toolListToggle.value) return toolListUI();
                            if (controller.actionListToggle.value) return actionListUI();
                            return const SizedBox();
                          }),

                          if (controller.actionToggle.value) const Spacer(),

                          //? ACTION TAPPER
                          if (controller.actionToggle.value)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () => controller.actionPerform(context),
                                child: Container(
                                  width: 48.w,
                                  height: 48.h,
                                  decoration: BoxDecoration(
                                    color: darkBrown,
                                    borderRadius: BorderRadius.circular(4.r),
                                    border: Border.all(width: 2, color: backgroundColor),
                                  ),
                                  child: Center(child: MySvgPicture(path: tap)),
                                ),
                              )
                            ],
                          ),

                          //? TIMING BAR
                          if (controller.actionToggle.value)
                          MyTimingHitBar(
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

  Widget toolListUI() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: darkBrown,
          border: Border.all(width: 2.w, color: backgroundColor),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Obx(() {
          return ListView.builder(
            itemCount: controller.selectedTools.length,
            itemBuilder: (context, i) {
              final tool = controller.selectedTools[i];
              return InkWell(
                onTap: () => onToolSelected(tool),
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: MyText(
                    text: tool.name,
                    textAlign: TextAlign.center,
                    color: textLight,
                    size: 14.sp,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget actionListUI() {
    return Expanded(
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
                  onTap: () => onActionSelected(action),
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

  void checkStatus(IngredientsModel ingredient) {
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
                children: [
                  Row(
                    children: [
                      Image.asset(logo, width: 32.w),
                      SizedBox(width: 14.w),
                      MyText(text: 'Ingredient Status'),
                      const Spacer(),
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: Container(
                          width: 32.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            color: lightButtonBackground.withOpacity(0.3),
                          ),
                          child: Center(child: MySvgPicture(path: close, iconColor: darkBrown)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      SizedBox(
                        width: 100.w,
                        height: 100.h,
                        child: CachedNetworkImage(
                          imageUrl: ingredient.path,
                          placeholder: (context, url) => ShimmerSkeletonLoader(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: MyText(
                          text: 'Name: ${ingredient.name}',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  MyText(text: 'Status'),
                  ...ingredient.actions.asMap().entries.map((entry) {
                    final index = entry.key + 1;
                    final act = entry.value;
                    final color = switch (act.status) {
                      'perfect' => greenLighter,
                      'good' => Colors.amber,
                      _ => redLighter,
                    };

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: '$index. ${act.action} : ',
                            fontWeight: FontWeight.w500,
                          ),
                          MyText(
                            text: act.status,
                            fontWeight: FontWeight.w500,
                            color: color,
                          ),
                          MyText(text: '   Tool : ${act.tool}', fontWeight: FontWeight.w500),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void onActionSelected(ActionType action) {
    controller.toolListToggle.value = true;
    controller.pendingAction.value = action;
    controller.selectedTools.value = getToolsForAction(action);
  }

  void onToolSelected(ToolType tool) {
    controller.actionListToggle.value = false;
    controller.actionToggle.value = true;
    controller.toolListToggle.value = false;
    controller.pendingTool.value = tool;
  }

}
