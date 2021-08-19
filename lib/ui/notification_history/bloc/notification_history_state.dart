part of 'notification_history_bloc.dart';

@immutable
class NotificationHistoryState extends Equatable {
  final String refreshTime;
  final List<NotificationHistoryModel> notificationItemHistoryList;

  NotificationHistoryState({
    this.notificationItemHistoryList,
    this.refreshTime,
  });

  factory NotificationHistoryState.initial(
      NotificationRepository notificationRepository) {
    return NotificationHistoryState(
        notificationItemHistoryList:
            notificationRepository.getLocalListNotificationHistoryItems());
  }

  NotificationHistoryState copyWith(
      {List<NotificationHistoryModel> notificationItemHistoryList,
      NotificationHistoryModel itemChanged,
      String refreshTime}) {
    return NotificationHistoryState(
        refreshTime: refreshTime ?? this.refreshTime,
        notificationItemHistoryList:
            notificationItemHistoryList ?? this.notificationItemHistoryList);
  }

  @override
  List<Object> get props => [
        notificationItemHistoryList,
        refreshTime,
        notificationItemHistoryList?.length,
      ];
}
