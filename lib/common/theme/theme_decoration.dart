part of 'theme.dart';

class ThemeDecoration {
  static const sizeSmallxxx_LT = BorderRadius.only(
    topLeft: Radius.circular(sizeSmallxxx),
    topRight: Radius.circular(sizeSmallxxx),
  );

  static final BoxDecoration topScreen = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.white,
        Colors.white.withAlpha(255),
        Colors.white.withAlpha(255),
        Colors.white.withAlpha(0),
      ],
    ),
  );
}
