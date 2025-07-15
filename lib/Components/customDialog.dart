import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:virtual_lab/Utils/properties.dart';

Future<void> quickAlertDialog({
  required BuildContext context,
  required String title,
  required String message,
  required QuickAlertType type,
  String? cancelBtnText = 'Cancel',
  String? confirmBtnText = 'Confirm',
  Color? rightBtnColor = greenLighter,
  void Function()? onConfirmBtnTap,
  bool? showCancelBtn =false,
}) async {
  return QuickAlert.show(
    context: context,
    type: type,
    title: title,
    titleColor: darkBrown,
    text: message,
    textColor: lightBrown,
    cancelBtnText: cancelBtnText!,
    confirmBtnText: confirmBtnText!,
    confirmBtnColor: rightBtnColor!,
    onConfirmBtnTap: onConfirmBtnTap,
    barrierDismissible: false,
    showCancelBtn: showCancelBtn!,
    disableBackBtn: true,
  );
}
