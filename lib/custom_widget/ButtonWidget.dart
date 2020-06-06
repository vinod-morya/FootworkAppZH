import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../utils/app_localizations.dart';

class ButtonWidget extends StatelessWidget {
  final String btnText;
  final Color textColor;
  final Color buttonColor;
  final double fontSize;
  final double size;
  final Function() onPressed;
  final padding;

  ButtonWidget(this.btnText, this.size, this.onPressed,
      {this.textColor, this.fontSize, this.buttonColor, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: size,
          right: btnText ==
                  AppLocalizations.of(context).translate("create_account_label")
              ? (size + 10)
              : size),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(gradient: gradientAppToolBar),
      child: RaisedButton(
        elevation: (fontSize - 12),
        color: appColor,
        disabledColor: colorWhite,
        textColor: colorWhite,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(fontSize - 18.0)),
        child: Padding(
          padding: padding,
          child: Text(
            btnText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: fontSize,
              fontFamily: robotoBoldCondenseFont,
            ),
          ),
        ),
        splashColor: appColor,
      ),
    );
  }
}
