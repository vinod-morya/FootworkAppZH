import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:footwork_chinese/constants/app_colors.dart';

class CustomInputField extends StatelessWidget {
  final String icon;
  final IconButton suffixIcon;
  final String hintText;
  final TextInputType textInputType;
  final Color iconColor;
  final bool obscureText;
  final TextStyle textStyle, hintStyle;
  final TextInputAction inputAction;
  final bool enabled;
  final controller;
  final inputFormatters;
  final capital;
  final suffixIconStyle;
  final focusNode;
  final imgHeight;
  final imgWidth;

  CustomInputField(
      {this.icon,
      this.hintText,
      this.textInputType,
      this.imgHeight,
      this.imgWidth,
      this.iconColor,
      this.obscureText,
      this.capital = TextCapitalization.none,
      @required this.inputFormatters,
      this.controller,
      this.suffixIconStyle,
      this.enabled = true,
      this.suffixIcon = null,
      this.inputAction = TextInputAction.done,
      this.textStyle,
      this.focusNode,
      this.hintStyle});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      style: textStyle,
      keyboardType: textInputType,
      cursorColor: colorBlack,
      textInputAction: inputAction,
      textCapitalization: capital,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hintText,
        border: InputBorder.none,
        icon: Image.asset(
          icon,
          color: iconColor,
          height: imgHeight,
          width: imgWidth,
        ),
        suffixIcon: suffixIcon,
        suffixStyle: suffixIconStyle,
      ),
    );
  }
}
