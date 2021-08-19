import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../theme/theme.dart';

class MyTextIconView extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final TextAlign textAlign;
  final Icon iconLeft;
  final MainAxisAlignment mainAxisAlignment;
  final Icon iconRight;
  final EdgeInsets marginText;
  final GestureTapCallback onTap;

  MyTextIconView({
    Key key,
    this.text,
    this.textStyle,
    this.textAlign = TextAlign.center,
    this.onTap,
    this.iconLeft,
    this.iconRight,
    this.marginText,
    this.mainAxisAlignment = MainAxisAlignment.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            (iconLeft != null)
                ? Container(
                    margin:
                        const EdgeInsets.only(top: sizeIcon, right: sizeIcon),
                    child: iconLeft)
                : const SizedBox(),
            Container(
                margin: marginText,
                child: Text(
                  text,
                  key: key,
                  overflow: TextOverflow.ellipsis,
                  textAlign: textAlign,
                  style: textStyle,
                )),
            (iconRight != null) ? iconRight : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
