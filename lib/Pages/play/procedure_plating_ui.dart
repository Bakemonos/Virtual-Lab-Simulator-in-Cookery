import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/components/custom_svg.dart';
import 'package:virtual_lab/controllers/controller.dart';
import 'package:virtual_lab/json/tools.dart';
import 'package:virtual_lab/models/ingredients_model.dart';
import 'package:virtual_lab/pages/play/action_bar_ui.dart';
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
    controller.discard();
    controller.preparedData.value = InventoryModel.empty();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320.w,
      child: Column(
        spacing: 16.h,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: controller.designUI(),
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  spacing: 4.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: controller.actionButton(text: 'View Instruction', onPressed: ()=> controller.instruction(context, controller.typeSelected!)),
                    ),
                    SizedBox(height: 4.h),
                    ...controller.typeSelected!.instructions.asMap().entries.map((entry){
                      final index = entry.key + 1; 
                      final goal = entry.value;

                      return  MyText(
                        text: '$index. ${goal.name}',
                        fontWeight: FontWeight.w500,
                        color: textLight,
                        size: 16.sp,
                      );
                    })
                  ],
                ),
              ),
            ),
          ),


          //? PROCEDURE
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
                      backGround: candidateData.isEmpty ? acceptedColor : greenLighter.withValues(alpha: 0.8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Row(
                        spacing: 16.w,
                        children: [

                          //? PROCEDURE AREA
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
                                      if (hasIngredient) Draggable<IngredientsModel >(
                                        data: IngredientsModel(
                                          name: ingredient.name, 
                                          path: ingredient.path, 
                                          category: ingredient.category,
                                          actions: ingredient.actions,
                                          dragKey: 'submit'
                                        ),
                                        onDragStarted: () {
                                          controller.bagToggle.value= false;
                                        },
                                        feedback: SizedBox(
                                          height: 80.h, width: 80.w,
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
                                        childWhenDragging: Center(
                                          child: MyText(text: ingredient.name),
                                        ),
                                        child: InkWell(
                                          onTap: () => controller.actionOnTap(ingredient),
                                          child: SizedBox(
                                            height: 80.h, width: 80.w,
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
                                  child: Obx(()=> Row(
                                    spacing: 8.w,
                                    children: [
                                      if(hasIngredient) controller.actionButton(
                                        text: 'Check',
                                        onPressed: (){
                                          final ingredient = controller.ingredientActionData.value;
                                          if (ingredient.actions.isNotEmpty) {
                                            controller.preparedIngredients.add(ingredient);
                                            checkStatus(ingredient);
                                          }
                                        }
                                      ),
                                      if(controller.toolListToggle.value) controller.actionButton(
                                        text: 'Back',
                                        onPressed: (){
                                          controller.toolListToggle.value = false;
                                          controller.actionListToggle.value = true;
                                        }
                                      ),
                                    ],
                                  )),
                                )
                              ],
                            ),
                          ),
                          
                          if(controller.actionToggle.value) const Spacer(),

                          //? ACTION / TOOL LIST
                          Obx(() {
                            final hasIngredient = controller.ingredientDragDropData.value.path.isNotEmpty;
                            if (!hasIngredient) return const SizedBox();
                            if (controller.toolListToggle.value) {
                              return toolListUI();
                            }
                            if (controller.actionListToggle.value) {
                              return actionListUI();
                            }
                            return const SizedBox();
                          }),

                          //? ACTION TAPPER
                          if (controller.actionToggle.value) Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: actionPerform,
                                child: Container(
                                  width: 48.w, height: 48.h,
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

                          //? ACTION BAR
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
  

  void actionPerform() {
    final status = controller.handleTap(context).name;
    
    final newAction = ActionsModel(
      status: status,
      action: controller.pendingAction.value!.name,
      tool: controller.pendingTool.value!.name,
    );

    controller.selectedActions.add(newAction);

    final ingredient = controller.ingredientDragDropData.value;

    final updatedIngredient = IngredientsModel(
      name: ingredient.name,
      path: ingredient.path,
      category: ingredient.category,
      actions: controller.selectedActions.toList(), 
    );

    controller.ingredientActionData.value = updatedIngredient;

    controller.pendingAction.value = null;
    controller.actionToggle.value = false;  
  }

  Widget toolListUI() {
    return Expanded(
      flex: 2,
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
                onTap: ()=> onToolSelected(tool),
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
                  Expanded(
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        spacing: 12.h,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 12.w,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100.w, height: 100.h,
                                child: CachedNetworkImage(
                                  imageUrl: ingredient.path,
                                  placeholder: (context, url) => ShimmerSkeletonLoader(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: MyText(
                                  text: 'Name: ${ingredient.name}',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          MyText(text: 'Status'), 
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 12.h,
                            children: List.generate(ingredient.actions.length, (index) {
                              final act = ingredient.actions[index];
                              return Row(
                                children: [
                                  MyText(
                                    text: '${index + 1}. ${act.action} : ',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  MyText(
                                    text: act.status,
                                    fontWeight: FontWeight.w500,
                                    color: switch (act.status) {
                                      'perfect' => greenLighter,
                                      'good' => Colors.amber,
                                      _ => redLighter, 
                                    },
                                  ),
                                  MyText(
                                    text: act.tool,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
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
    controller.actionListToggle.value = false; //* HIDE ACTION LIST 
    controller.actionToggle.value = true; //* SHOW ACTION TAP
    controller.toolListToggle.value = false; //* HIDE TOOLS LIST
    controller.pendingTool.value = tool;
  }

}

