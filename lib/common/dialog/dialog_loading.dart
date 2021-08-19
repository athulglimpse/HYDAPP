import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme.dart';

// ignore: must_be_immutable
class DialogLoading extends Dialog {
  Function(BuildContext context) onDissmis;

  DialogLoading() {
    onDissmis = (BuildContext context) {
      dismissDialog(context);
      SystemChrome.setEnabledSystemUIOverlays([]);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          width: sizeLarge,
          height: sizeLarge,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        ),
      ),
    );
  }

  void dismissDialog(BuildContext context) {
    Navigator.pop(context);
  }
}
