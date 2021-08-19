import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class UnityWrapper {
  static void openSplashScreen(UnityWidgetController _unityWidgetController) {
    _unityWidgetController.postMessage(
      'NavigationObject',
      'LoadScene',
      'SplashScreen',
    );
  }

  static void openMainARLocation(UnityWidgetController _unityWidgetController) {
    _unityWidgetController.postMessage(
      'NavigationObject',
      'LoadScene',
      'MainARLocation',
    );
  }

  ///
  /// Send direction data to Unity to render Guideline
  static void sendDirectionData(
      UnityWidgetController _unityWidgetController, String data) {
    _unityWidgetController.postMessage(
      'AR_Session',
      'GuideDirectionLocation',
      data,
    );
  }
}
