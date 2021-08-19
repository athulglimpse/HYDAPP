part of 'notification_setting_bloc.dart';

@immutable
class NotificationSettingState extends Equatable {
  final List<NotificationSettingModel> notificationItemList;
  final NotificationSettingModel itemChanged;
  final bool success;
  final String errorMessage;

  NotificationSettingState({
    this.notificationItemList,
    this.itemChanged,
    this.success = false,
    this.errorMessage,
  });

  factory NotificationSettingState.initial(
      NotificationRepository notificationRepository) {
    return NotificationSettingState(
        notificationItemList:
            notificationRepository.getLocalListNotificationItems());
  }

  NotificationSettingState copyWith({
    List<NotificationSettingModel> notificationItemList,
    NotificationSettingModel itemChanged,
    bool success,
    String errorMessage,
  }) {
    return NotificationSettingState(
      success: success ?? false,
      errorMessage: errorMessage,
      itemChanged: itemChanged ?? this.itemChanged,
      notificationItemList: notificationItemList ?? this.notificationItemList,
    );
  }

  @override
  List<Object> get props => [
        notificationItemList,
        itemChanged?.toJson(),
        errorMessage,
        success,
        itemChanged
      ];
}
