import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/controllers/controller.dart';
import 'package:virtual_lab/models/ingredients_model.dart';
import 'package:virtual_lab/pages/play/inventory_ui.dart';
import 'package:virtual_lab/pages/play/procedure_plating_ui.dart';
import 'package:virtual_lab/pages/play/process_ui.dart';
import 'package:virtual_lab/utils/properties.dart';
import 'package:virtual_lab/utils/routes.dart';

class MyPlayUIPage extends StatefulWidget {
  const MyPlayUIPage({super.key});

  @override
  State<MyPlayUIPage> createState() => _MyPlayUIPageState();
}

class _MyPlayUIPageState extends State<MyPlayUIPage> {
  final controller = AppController.instance;

  @override
  void dispose() {
    controller.discard(); 
    controller.preparedData.value = InventoryModel.empty();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          controller.exitDialog(context);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  spacing: 16.w,
                  children: [
                    const MyInventoryPage(),
                    const MyProcedurePlatingPage(),
                    const MyProcessPage(),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: backgroundColor,
                  border: Border.all(width: 8.w, color: backgroundColor)
                ),
                child: controller.floatingButton(
                  context: context,
                  icon: menu,
                  onTap: () {
                    context.go(Routes.menu);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
