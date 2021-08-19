import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../theme/theme.dart';

@immutable
class NormalDialogTemplate {
  static Widget makeTemplate(
    Widget child, {
    PositionDialog positionDialog,
    Color backgroundColor,
    EdgeInsets insetPadding,
    Function onDismiss,
    EdgeInsets insetMargin,
    bool useDragDismiss = false,
    Key key,
  }) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Align(
            alignment: _getPositionDialog(positionDialog),
            child: useDragDismiss
                ? Dismissible(
                    key: key,
                    dragStartBehavior: DragStartBehavior.down,
                    direction: DismissDirection.up,
                    onDismissed: (direction) {
                      if (onDismiss != null) {
                        onDismiss();
                      }
                    },
                    child: Container(
                      margin: insetMargin,
                      padding: insetPadding ?? const EdgeInsets.all(sizeNormal),
                      decoration: BoxDecoration(
                        color: backgroundColor ?? Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: _getBorderRadius(positionDialog),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: sizeSmall,
                            offset: Offset(0.0, sizeSmall),
                          ),
                        ],
                      ),
                      child: child,
                    ),
                  )
                : Container(
                    margin: insetMargin,
                    padding: insetPadding ?? const EdgeInsets.all(sizeNormal),
                    decoration: BoxDecoration(
                      color: backgroundColor ??  Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: _getBorderRadius(positionDialog),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: sizeSmall,
                          offset: Offset(0.0, sizeSmall),
                        ),
                      ],
                    ),
                    child: child,
                  ),
          ),
        ),
      ],
    );
  }

  static BorderRadius _getBorderRadius(PositionDialog positionDialog) {
    switch (positionDialog) {
      case PositionDialog.topCenter:
        return const BorderRadius.only(
            bottomLeft: Radius.circular(sizeSmallxxx),
            bottomRight: Radius.circular(sizeSmallxxx));
        break;
      case PositionDialog.center:
        return BorderRadius.circular(sizeSmallxxx);
        break;
      case PositionDialog.bottomCenter:
        return const BorderRadius.only(
            topLeft: Radius.circular(sizeSmallxxx),
            topRight: Radius.circular(sizeSmallxxx));
        break;
      default:
        return BorderRadius.circular(sizeSmallxxx);
        break;
    }
  }

  static Alignment _getPositionDialog(PositionDialog positionDialog) {
    switch (positionDialog) {
      case PositionDialog.topCenter:
        return Alignment.topCenter;
        break;
      case PositionDialog.center:
        return Alignment.center;
        break;
      case PositionDialog.bottomCenter:
        return Alignment.bottomCenter;
        break;
      default:
        return Alignment.center;
        break;
    }
  }
}

enum PositionDialog { topCenter, center, bottomCenter }
