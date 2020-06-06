import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../constants/app_images_path.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class AppbarCustom extends StatelessWidget with PreferredSizeWidget {
  final String titleTxt;
  final Function() actionPerformed;
  final bool actionBtnVisibility;

  AppbarCustom({this.titleTxt, this.actionPerformed, this.actionBtnVisibility});

  @override
  Widget build(BuildContext context) {
    return GradientAppBar(
        elevation: 2.0,
        leading: Material(
          shadowColor: Colors.transparent,
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: IconButton(
              icon: Image.asset(
                back_arrow,
                height: 20.0,
                width: 20.0,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: Text(
          titleTxt,
          style: TextStyle(fontFamily: regularFont, color: Colors.white),
        ),
        actions: <Widget>[
          actionBtnVisibility
              ? Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: InkWell(
                    onTap: actionPerformed,
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                )
              : Container(),
        ],
        centerTitle: true,
        gradient: gradientApp);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
