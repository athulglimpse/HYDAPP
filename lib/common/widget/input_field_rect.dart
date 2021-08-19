import 'package:flutter/material.dart';
import '../theme/theme.dart';

class InputFieldRect extends StatelessWidget {
  final String hintText;
  final TextInputType textInputType;
  final Color textFieldColor, iconColor, borderColor;
  final bool obscureText;
  final double borderRadius;
  final Function(String) onSubmit;
  final Function onTap;
  final Function onEditingComplete;
  final dynamic cusSubIcon, cusPreIcon;

  final TextEditingController controller;
  final FocusNode focusNode;

  final TextStyle hintStyle;
  final TextStyle textStyle;
  final TextAlign textAlign;

  InputFieldRect({
    Key key,
    this.hintText,
    this.onEditingComplete,
    this.onTap,
    this.focusNode,
    this.obscureText = false,
    this.textInputType,
    this.cusSubIcon,
    this.textAlign = TextAlign.center,
    this.textFieldColor,
    this.onSubmit,
    this.iconColor,
    this.controller,
    this.textStyle,
    this.hintStyle,
    this.borderRadius = sizeVerySmall,
    this.borderColor = Colors.black,
    this.cusPreIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: sizeVerySmall,
      shadowColor: const Color(0x80fbbc43),
      color: Colors.white,
      borderRadius: BorderRadius.circular(borderRadius),
      child: TextField(
        style: textStyle,
        textAlign: textAlign,
        focusNode: focusNode,
        onEditingComplete: onEditingComplete,
        obscureText: obscureText,
        keyboardType: textInputType,
        onTap: onTap ?? () {},
        controller: controller,
        onSubmitted: onSubmit,
        decoration: getInputDecoration(),
      ),
    );
  }

  InputDecoration getInputDecoration() {
    return InputDecoration(
      prefixIcon: cusPreIcon,
      suffixIcon: cusSubIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: sizeSmall),
      hintText: hintText,
      hintStyle: hintStyle,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: borderColor),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: borderColor),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: Color(0x80fbbc43)),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
