import 'package:flutter/material.dart';

class GestureButton extends GestureDetector {
  GestureButton.icon(
    IconData icon, {
    GestureTapCallback onTap,
    Color color,
    double size,
  }) : super(
          child: Icon(
            icon,
            color: color,
            size: size,
          ),
          onTap: onTap,
        );
}
