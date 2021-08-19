part of 'notification_setting_bloc.dart';

@immutable
abstract class NotificationSettingEvent {}

class FetchNotificationData extends NotificationSettingEvent {}

class OnNotificationItemChange extends NotificationSettingEvent {
  final NotificationSettingModel item;

  OnNotificationItemChange(this.item);
}

class OnSubmitNotificationSetting extends NotificationSettingEvent {}
