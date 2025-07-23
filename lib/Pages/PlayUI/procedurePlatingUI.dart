import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
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
              child: Column(
                children: [
                ],
              ),
            ),
          ),
          Expanded(
            child: DragTarget<IngredientsModel>(
              onAcceptWithDetails: (details) {
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
                                      if (hasIngredient)
                                        Draggable(
                                          data: ingredient,
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
                                      if(controller.selectedActions.isNotEmpty) controller.actionButton(
                                        text: 'Confirm',
                                        onPressed: () => confirmIngredient(
                                          type: controller.typeSelected!.menu ?? '',
                                          studentId: controller.userData.value.id!,
                                          take: 'take_one',
                                        ),
                                      ),
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
                                    ],
                                  )),
                                )
                              ],
                            ),
                          ),
                          
                          if(controller.actionToggle.value) const Spacer(),

                          //? ACTION LIST
                          Obx(() {
                            final showActionList = controller.ingredientDragDropData.value.path.isNotEmpty && controller.actionListToggle.value;
                            return controller.actionToggle.value ? const SizedBox() : (showActionList ? actionListUI() : const SizedBox());
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
                                width: 100.w,
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

  void confirmIngredient({
    required String type,
    required String studentId,
    required String take,
  }) {
    controller.preparedIngredients.add(controller.ingredientActionData.value);

    final newInventory = InventoryModel(
      type: type,
      studentId: studentId,
      take: take,
      ingredients: controller.preparedIngredients.toList(),
    );

    controller.preparedData.value = newInventory;

    controller.preparedInventories.add(newInventory);

    debugPrint("✅ Ingredient confirmed: ${controller.ingredientActionData.value.name}");
    debugPrint("📦 Total Inventories: ${controller.preparedInventories.length}");

    controller.ingredientDragDropData.value = IngredientsModel.empty();
    controller.ingredientActionData.value = IngredientsModel.empty();
    controller.selectedActions.clear();
  }


  void actionPerform() {
    final status = controller.handleTap(context).name;
    
    final newAction = ActionsModel(
      action: controller.pendingAction.value!.name,
      status: status,
    );

    controller.selectedActions.add(newAction);

    final ingredient = controller.ingredientDragDropData.value;

    final updatedIngredient = IngredientsModel(
      name: ingredient.name,
      path: ingredient.path,
      type: ingredient.type,
      actions: controller.selectedActions.toList(), 
    );

    controller.ingredientActionData.value = updatedIngredient;

    controller.pendingAction.value = null;
    controller.actionToggle.value = false;  

    debugPrint(
      '\nPath: ${updatedIngredient.path}\n'
      'Name: ${updatedIngredient.name}\n'
      'Type: ${updatedIngredient.type}\n'
      'Actions: ${updatedIngredient.actions.map((e) => e.action).toList()}\n'
      'Statuses: ${updatedIngredient.actions.map((e) => e.status).toList()}\n'
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
                controller.pendingAction.value = action;
                controller.actionToggle.value = true;
                if (!controller.ingredientsCurrentActions.contains(action)) {
                  controller.ingredientsCurrentActions.add(action);
                }
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

}

