import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyTextView extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final int maxLine;
  final EdgeInsets padding;
  final TextAlign textAlign;
  final Function onTap;

  MyTextView({
    Key key,
    this.text,
    this.textStyle,
    this.padding = const EdgeInsets.all(0),
    this.textAlign = TextAlign.center,
    this.onTap,
    this.maxLine = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: Text(
            text,
            key: key,
            maxLines:
                maxLine <= 0 ? DefaultTextStyle.of(context).maxLines : maxLine,
            textAlign: textAlign,
            overflow: maxLine > 0
                ? TextOverflow.ellipsis
                : DefaultTextStyle.of(context).overflow,
            style: textStyle,
          ),
        ),
      );
    } else if (maxLine > 0) {
      return Text(
        text,
        key: key,
        maxLines: maxLine,
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
        style: textStyle,
      );
    } else {
      return Text(
        text,
        key: key,
        textAlign: textAlign,
        style: textStyle,
      );
    }
  }
}
