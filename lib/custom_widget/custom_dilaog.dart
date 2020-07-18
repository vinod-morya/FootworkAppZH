import 'package:flutter/material.dart';
import 'package:footwork_chinese/custom_widget/InAppWidget.dart';
import 'package:footwork_chinese/custom_widget/PurchaseWidget.dart';

import '../custom_widget/AddEditInstaUrlWidget.dart';
import '../custom_widget/AddEditNoteWidget.dart';
import '../custom_widget/DialogParentWidget.dart';
import '../custom_widget/InviteUser.dart';
import '../custom_widget/MarkAsCompleteWidget.dart';

showDialogMarkAsComplete(BuildContext context,
    {@required String title,
    String okBtnText = "Ok",
    String cancelBtnText = "Cancel",
    String content,
    String icon,
    dynamic rating,
    @required Function(double value) okBtnFunction,
    @required Function(double value) cancelBtnFunction}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return MyDialog(
          elevation: 0.0,
          backgroundColor: Colors.black54,
          child: MarkAsCompleteContent(title, okBtnText, cancelBtnText, content,
              icon, okBtnFunction, cancelBtnFunction, rating),
        );
      });
}

showDialogAddEditComment(BuildContext context,
    {String okBtnText,
    String content,
    String date,
    String icon,
    @required Function(String value) okBtnFunction}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      child: Center(
        child: MyDialog(
          elevation: 0.0,
          backgroundColor: Colors.black54,
          child: AddEditNotes(icon, okBtnFunction, okBtnText, date, content),
        ),
      ));
}

showDialogInviteUser(BuildContext context,
    {String okBtnText,
    String inviteText,
    @required Function(String value) okBtnFunction}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      child: Center(
        child: MyDialog(
          elevation: 0.0,
          backgroundColor: Colors.black54,
          child: InviteUser(okBtnFunction, okBtnText, inviteText),
        ),
      ));
}

showDialogInstaUrl(BuildContext context,
    {String okBtnText,
    String content,
    String date,
    String icon,
    @required Function(String value) okBtnFunction}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      child: Center(
        child: MyDialog(
          elevation: 0.0,
          backgroundColor: Colors.black54,
          child: AddEditInstaUrl(icon, okBtnFunction, okBtnText, date, content),
        ),
      ));
}

showDialogInApp(BuildContext context,
    {String yearlyTxt,
      String title,
      String body,
      @required Function yearlyBtnFunction,
      @required Function restoreBtnFunction}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      child: Center(
        child: MyDialog(
          elevation: 0.0,
          backgroundColor: Colors.black54,
          child: InAppWidget(body,title, yearlyTxt, yearlyBtnFunction,
               restoreBtnFunction),
        ),
      ));
}

showDialogPurchase(BuildContext context,
    {String title,
    String body,
    @required Function aliPayBtnFunction}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      child: Center(
        child: MyDialog(
          elevation: 0.0,
          backgroundColor: Colors.black54,
          child: PurchaseWidget(body, title, aliPayBtnFunction),
        ),
      ));
}
