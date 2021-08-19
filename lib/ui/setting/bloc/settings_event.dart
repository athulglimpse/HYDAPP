import 'package:meta/meta.dart';

import '../../../data/model/language.dart';

@immutable
abstract class SettingsEvent {
  const SettingsEvent();
}

class LoadLanguage extends SettingsEvent {}

class FetchNotificationData extends SettingsEvent {}

class OnSetAppleMapDefault extends SettingsEvent {}

class OnSetGoogleMapDefault extends SettingsEvent {}

class OnSetWazeMapDefault extends SettingsEvent {}

class OnChangeLanguage extends SettingsEvent {
  final Language language;

  OnChangeLanguage({this.language});
}

class OnSubmitNotificationSetting extends SettingsEvent {
  final bool isNotification;

  OnSubmitNotificationSetting({this.isNotification});
}
