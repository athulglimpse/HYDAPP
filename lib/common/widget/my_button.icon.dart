import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../theme/theme.dart';
import 'my_text_view.dart';

// ignore: must_be_immutable
class MyButtonIcon extends StatelessWidget {
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
  Widget child;
  double height = 0;
  double minWidth = 0;
  bool isOutline = false;
  bool isStadiumBorder = false;

  MyButtonIcon({
    key,
    this.text,
    this.textStyle,
    this.textAlign,
    this.paddingVertical = sizeSmallx,
    this.paddingHorizontal = sizeNormalx,
    this.circular = sizeNormalxx,
    this.onTap,
    this.child,
    this.height = sizeLargexx,
    this.minWidth = 0,
    this.disable = false,
    this.isFillParent = true,
    this.isStadiumBorder = false,
    this.isOutline = false,
    this.disableColor,
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = !disable ? buttonColor : disableColor;
    final onTapButton = !disable ? onTap : null;
    return !isOutline
        ? Material(
            color: color,
            shadowColor: color,
            elevation: elevation,
            borderRadius: BorderRadius.circular(circular),
            child: SizedBox(
              height: height,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(circular)),
                onPressed: onTapButton,
                minWidth: minWidth,
                splashColor: rippleColor.withOpacity(0.5),
                highlightColor: rippleColor.withOpacity(0.1),
                child: child ??
                    MyTextView(
                      text: text,
                      textAlign: TextAlign.center,
                      textStyle: textStyle,
                    ),
              ),
            ),
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
                padding: EdgeInsets.fromLTRB(paddingHorizontal, paddingVertical,
                    paddingHorizontal, paddingVertical),
                onPressed: onTapButton,
                splashColor: rippleColor.withOpacity(0.5),
                highlightColor: rippleColor.withOpacity(0.1),
                child: child ??
                    MyTextView(
                      text: text,
                      textAlign: TextAlign.center,
                      textStyle: textStyle,
                    ),
              ),
            ),
          );
  }
//  StadiumBorder(), circle
}
