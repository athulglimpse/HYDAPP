import 'package:flutter/material.dart';

class NavigateUtil {
  static Future<T> openPage<T extends Object>(
      BuildContext context, String routeName,
      {Object argument, bool release = false}) {
    if (!release) {
      return Navigator.pushNamed(context, routeName, arguments: argument);
    } else {
      return Navigator.pushNamedAndRemoveUntil(
          context, routeName, (Route<dynamic> route) => false,
          arguments: argument);
    }
  }

  static Future<T> replacePage<T extends Object>(
      BuildContext context, String routeName,
      {Object argument}) {
    return Navigator.pushReplacementNamed(context, routeName,
        arguments: argument);
  }

  static void pop(BuildContext context,
      {Object argument, bool release = false, String routeName}) {
    if (release) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pop(argument);
    }
  }

  static void popHasTarget(BuildContext context, String screenName,
      {Object argument}) {
    Navigator.of(context).popAndPushNamed(screenName, arguments: argument);
  }
}
