import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../theme/theme.dart';

import 'my_text_view.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  String text;

  // ignore: deprecated_member_use
  TextStyle textStyle = ThemeData.dark().textTheme.display1;
  TextAlign textAlign = TextAlign.center;
  final Function onTap;
  final elevation = 5.5;
  final double circular;
  Color buttonColor = Colors.grey[850];
  Color rippleColor = Colors.white;
  Color disableColor = Colors.grey;
  bool disable = false;
  bool isFillParent = true;
  final double paddingVertical;
  final double paddingHorizontal;
  double height = 0;
  double minWidth = 0;
  bool isOutline = false;
  bool isStadiumBorder = false;

  MyButton({
    key,
    this.text,
    this.textStyle,
    this.textAlign,
    this.paddingVertical = sizeSmallx,
    this.paddingHorizontal = sizeNormalx,
    this.circular = sizeNormalxx,
    this.onTap,
    this.height = sizeLargexx,
    this.minWidth = 0,
    this.disable = false,
    this.isFillParent = false,
    this.isStadiumBorder = false,
    this.isOutline = false,
    this.disableColor,
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = !disable ? buttonColor : disableColor;
    final onTapButton = !disable ? onTap : null;
    final maxWidth = isFillParent
        ? (MediaQuery.of(context).size.width - sizeNormalxx)
        : null;
    return !isOutline
        ? Material(
            color: color,
            shadowColor: color,
            elevation: elevation,
            borderRadius: BorderRadius.circular(circular),
            child: SizedBox(
                height: height,
                width: maxWidth,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(circular)),
                  padding: EdgeInsets.fromLTRB(paddingHorizontal,
                      paddingVertical, paddingHorizontal, paddingVertical),
                  onPressed: onTapButton,
                  minWidth: minWidth,
                  splashColor: rippleColor.withOpacity(0.5),
                  highlightColor: rippleColor.withOpacity(0.1),
                  child: MyTextView(
                    text: text,
                    textAlign: TextAlign.center,
                    textStyle: textStyle,
                  ),
                )),
          )
        : Material(
            color: Colors.transparent,
            child: SizedBox(
                height: height,
                child: OutlineButton(
                  borderSide: BorderSide(color: color, width: 2),
                  shape: isStadiumBorder
                      ? const StadiumBorder()
                      : RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(circular)),
                  padding: EdgeInsets.fromLTRB(paddingHorizontal,
                      paddingVertical, paddingHorizontal, paddingVertical),
                  onPressed: onTapButton,
                  splashColor: rippleColor.withOpacity(0.5),
                  highlightColor: rippleColor.withOpacity(0.1),
                  child: MyTextView(
                    text: text,
                    textAlign: TextAlign.center,
                    textStyle: textStyle,
                  ),
                )),
          );
  }
//  StadiumBorder(), circle
}
