import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:virtual_lab/Pages/PlayUI/inventoryUI.dart';
import 'package:virtual_lab/Pages/PlayUI/procedurePlatingUI.dart';
import 'package:virtual_lab/Pages/PlayUI/processUI.dart';

class MyPlayUIPage extends StatelessWidget {
  const MyPlayUIPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          spacing: 16.w,
          children: [
            MyInventoryPage(),
            MyProcedurePlatingPage(),
            MyProcessPage()
          ],
        ),
      ),
    );
  }
}



