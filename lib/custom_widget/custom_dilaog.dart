import 'package:flutter/material.dart';
import 'package:footwork_chinese/custom_widget/AddEditNoteWidget.dart';
import 'package:footwork_chinese/custom_widget/DialogParentWidget.dart';
import 'package:footwork_chinese/custom_widget/InviteUser.dart';
import 'package:footwork_chinese/custom_widget/MarkAsCompleteWidget.dart';

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
