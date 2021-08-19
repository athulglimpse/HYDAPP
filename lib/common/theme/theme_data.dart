part of 'theme.dart';

ThemeData defaultTheme() {
  return ThemeData(
    fontFamily: MyFontFamily.graphik,
    accentColor: ThemeColor.primary,
    primarySwatch: ThemeColor.primary,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
