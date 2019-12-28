import 'package:flutter/material.dart';
import 'package:footwork_chinese/constants/app_colors.dart';
import 'package:footwork_chinese/custom_widget/edge_alert.dart';

class TopAlert {
  static void showAlert(context, title, isAlert,
      [description, gravity, duration, icon, color]) {
    EdgeAlert.show(context,
        title: title,
        description: description,
        gravity: gravity == null ? EdgeAlert.BOTTOM : gravity,
        backgroundColor:
            isAlert ? colorRed : color != null ? Color(0XFFFF7F50) : colorGreen,
        duration: duration == null ? EdgeAlert.LENGTH_LONG : duration,
        icon: icon == null && isAlert ? Icons.warning : Icons.done);
  }
}
