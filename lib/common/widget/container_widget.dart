import 'package:flutter/material.dart';
import '../theme/theme.dart';

class ContainerWidget extends Container {
  ContainerWidget.divider()
      : super(
          padding: const EdgeInsets.all(sizeSmall),
          margin: const EdgeInsets.only(top: sizeSmall),
          width: sizeNormalxxx,
          alignment: Alignment.center,
          height: 4,
          decoration: const BoxDecoration(
            color: Color(0x21212237),
            borderRadius: BorderRadius.all(Radius.circular(sizeVerySmall)),
          ),
        );

  ContainerWidget.circleButton({
    Widget child,
    Color color = ThemeColor.color_212237,
    GestureTapCallback onTap,
  }) : super(
          child: GestureDetector(
            onTap: onTap,
            child: child,
          ),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: color,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 2,
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        );
}

class SizedBoxWidget extends SizedBox {
  SizedBoxWidget.divider({
    double width,
  }) : super(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ContainerWidget.divider()],
          ),
        );
}
