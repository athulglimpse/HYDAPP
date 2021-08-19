part of 'notification_history_bloc.dart';

@immutable
abstract class NotificationHistoryEvent {}

class FetchNotificationData extends NotificationHistoryEvent {}

class FetchMoreNotificationData extends NotificationHistoryEvent {}

class RemoveNotification extends NotificationHistoryEvent {
  final NotificationHistoryModel item;

  RemoveNotification(this.item);
}

class TurnOffNotification extends NotificationHistoryEvent {
  final NotificationHistoryModel item;

  TurnOffNotification(this.item);
}

class TagReady extends NotificationHistoryEvent {
  final NotificationHistoryModel item;

  TagReady(this.item);
}
