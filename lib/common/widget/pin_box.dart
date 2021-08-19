import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme.dart';

class PinBox {
  final List<Widget> boxes = [];
  final List<FocusNode> focusNodes = [];

  InputDecoration inputFormat(Color fillColor) {
    return InputDecoration(
      fillColor: fillColor,
      filled: true,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(width: 0.0, color: fillColor)),
      contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
    );
  }

  TextStyle textStyle(double fontSize, Color color, FontWeight fontWeight) {
    return TextStyle(
        color: color,
        decoration: TextDecoration.none,
        fontSize: fontSize,
        fontWeight: fontWeight);
  }

  Container pinBox(
      int index,
      double width,
      TextEditingController con,
      FocusNode focusNode,
      FocusNode nextFocusNode,
      Color boxColor,
      Color textColor,
      BuildContext context,
      bool show) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3.0),
      width: width,
      child: TextFormField(
        decoration: inputFormat(boxColor),
        controller: con,
        textAlign: TextAlign.center,
        cursorColor: boxColor,
        maxLines: 1,
        onChanged: (text) {
          if (text.isNotEmpty) {
            con.text = text.substring(text.length - 1);
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            }
          } else if (index > 0) {
            FocusScope.of(context).requestFocus(focusNodes[index - 1]);
          }
        },
        obscureText: !show,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        autofocus: false,
        style: textNormalxxx.copyWith(color: textColor),
      ),
    );
  }

  Widget pinBoxes({
    double width,
    List<TextEditingController> cons,
    Color boxColor,
    Color textColor,
    BuildContext context,
    bool show,
  }) {
    focusNodes.add(FocusNode());
    for (var i = 0; i < cons.length; i++) {
      focusNodes.add(FocusNode());
      if (i == cons.length - 1) {
        focusNodes[i + 1] = null;
      }
      boxes.add(pinBox(i, width, cons[i], focusNodes[i], focusNodes[i + 1],
          boxColor, textColor, context, show));
    }
    return RawKeyboardListener(
      focusNode: focusNodes[0],
      onKey: _handleKeyEvent,
      child: Row(
        children: boxes,
      ),
    );
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.delete) {
    } else {}
  }

  void doDestroy() {
    focusNodes.forEach((element) => element?.dispose());
  }
}
