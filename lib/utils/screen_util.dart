import 'package:flutter/material.dart';

class ScreenUtil {
  static ScreenUtil instance = ScreenUtil();
  final int width;
  final int height;

  static double _realWidth;
  static double _realHeight;
  static double _scaleWidth;
  static double _scaleHeight;
  static MediaQueryData _mediaQueryData;
  static double _textScaleFactor;
  static double _topBarHeight;
  static double _bottomBarHeight;

  ScreenUtil({this.width = 375, this.height = 812});

  static ScreenUtil getInstance() {
    return instance;
  }

  void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _mediaQueryData = mediaQuery;
    _textScaleFactor = _mediaQueryData.textScaleFactor;
    _realWidth = _mediaQueryData.size.width;
    _realHeight = _mediaQueryData.size.height;
    _topBarHeight =
        _mediaQueryData.padding.top == 0 ? 50 : _mediaQueryData.padding.top;
    _bottomBarHeight = _mediaQueryData.padding.bottom;
//
    _scaleWidth = _realWidth / width;
    _scaleHeight = _realHeight / height;
  }

  double getRealWidth() => _realWidth;

  double getRealHeight() => _realHeight;

  double getTopBarHeight() => _topBarHeight;

  double getBottomHeight() => _bottomBarHeight;

  double getWidthPercent(double percent) => _realWidth * percent;

  double getHeightPercent(double percent) => _realHeight * percent;

  double cvWidth(double w) => w * _scaleWidth;

  double cvHeight(double h) => h * _scaleHeight;

  double cvFontSize(double fontSize, {bool allowScale = true}) =>
      allowScale ? cvWidth(fontSize) : cvHeight(fontSize) / _textScaleFactor;
}
