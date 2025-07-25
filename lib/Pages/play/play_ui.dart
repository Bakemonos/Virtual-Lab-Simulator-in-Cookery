import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_lab/controllers/controller.dart';
import 'package:virtual_lab/pages/play/inventory_ui.dart';
import 'package:virtual_lab/pages/play/procedure_plating_ui.dart';
import 'package:virtual_lab/pages/play/process_ui.dart';
import 'package:virtual_lab/utils/properties.dart';
import 'package:virtual_lab/utils/routes.dart';

class MyPlayUIPage extends StatelessWidget {
  const MyPlayUIPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppController.instance;

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
            Positioned(
              top: 6.h,
              right: 8.w,
              child: Container(
                height: 60.h,
                width: 60.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: backgroundColor,
                ),
              ),
            ),
            controller.floatingButton(
              context: context,
              icon: menu,
              isLeft: false,
              onTap: () {
                context.go(Routes.menu);
              },
            ),
          ],
        ),
      ),
    );
  }
}
