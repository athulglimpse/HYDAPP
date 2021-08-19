import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'pin_code.dart';

class MyPinTheme {
  /// Colors of the input fields which have inputs. Default is [Colors.green]
  final Color activeColor;

  /// Color of the input field which is currently selected.
  /// Default is [Colors.blue]
  final Color selectedColor;

  /// Colors of the input fields which don't have inputs.
  /// Default is [Colors.red]
  final Color inactiveColor;

  /// Colors of the input fields if the [PinCodeTextField] is disabled.
  /// Default is [Colors.grey]
  final Color disabledColor;

  /// Colors of the input fields which have inputs. Default is [Colors.green]
  final Color activeFillColor;

  /// Color of the input field which is currently selected.
  /// Default is [Colors.blue]
  final Color selectedFillColor;

  /// Colors of the input fields which don't have inputs.
  /// Default is [Colors.red]
  final Color inactiveFillColor;

  /// Border radius of each pin code field
  final BorderRadius borderRadius;

  /// [height] for the pin code field. default is [50.0]
  final double fieldHeight;

  /// [width] for the pin code field. default is [40.0]
  final double fieldWidth;

  /// Border width for the each input fields. Default is [2.0]
  final double borderWidth;

  /// this defines the shape of the input fields. Default is underlined
  final MyPinCodeFieldShape shape;

  const MyPinTheme.defaults({
    this.borderRadius = BorderRadius.zero,
    this.fieldHeight = 50,
    this.fieldWidth = 40,
    this.borderWidth = 2,
    this.shape = MyPinCodeFieldShape.underline,
    this.activeColor = Colors.white,
    this.selectedColor = Colors.white,
    this.inactiveColor = Colors.white,
    this.disabledColor = Colors.white,
    this.activeFillColor = Colors.white,
    this.selectedFillColor = Colors.blue,
    this.inactiveFillColor = Colors.white,
  });

  // ignore: sort_unnamed_constructors_first
  factory MyPinTheme({
    Color activeColor,
    Color selectedColor,
    Color inactiveColor,
    Color disabledColor,
    Color activeFillColor,
    Color selectedFillColor,
    Color inactiveFillColor,
    BorderRadius borderRadius,
    double fieldHeight,
    double fieldWidth,
    double borderWidth,
    MyPinCodeFieldShape shape,
  }) {
    const defaultValues = MyPinTheme.defaults();
    return MyPinTheme.defaults(
      activeColor:
          (activeColor == null) ? defaultValues.activeColor : activeColor,
      activeFillColor: (activeFillColor == null)
          ? defaultValues.activeFillColor
          : activeFillColor,
      borderRadius:
          (borderRadius == null) ? defaultValues.borderRadius : borderRadius,
      borderWidth:
          (borderWidth == null) ? defaultValues.borderWidth : borderWidth,
      disabledColor:
          (disabledColor == null) ? defaultValues.disabledColor : disabledColor,
      fieldHeight:
          (fieldHeight == null) ? defaultValues.fieldHeight : fieldHeight,
      fieldWidth: (fieldWidth == null) ? defaultValues.fieldWidth : fieldWidth,
      inactiveColor:
          (inactiveColor == null) ? defaultValues.inactiveColor : inactiveColor,
      inactiveFillColor: (inactiveFillColor == null)
          ? defaultValues.inactiveFillColor
          : inactiveFillColor,
      selectedColor:
          (selectedColor == null) ? defaultValues.selectedColor : selectedColor,
      selectedFillColor: (selectedFillColor == null)
          ? defaultValues.selectedFillColor
          : selectedFillColor,
      shape: (shape == null) ? defaultValues.shape : shape,
    );
  }
}