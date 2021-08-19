import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../data/model/notification_history_model.dart';
import '../../../data/repository/notification_repository.dart';
import '../../../data/source/api_end_point.dart';
import '../interactor/notification_interactor.dart';

part 'notification_history_event.dart';
part 'notification_history_state.dart';

class NotificationHistoryBloc
    extends Bloc<NotificationHistoryEvent, NotificationHistoryState> {
  final NotificationRepository notificationRepository;
  final NotificationHistoryInteract notificationHistoryInteract;
  int indexPage = 0;

  NotificationHistoryBloc({
    this.notificationRepository,
    this.notificationHistoryInteract,
  }) : super(NotificationHistoryState.initial(notificationRepository));

  @override
  Stream<NotificationHistoryState> mapEventToState(
    NotificationHistoryEvent event,
  ) async* {
    switch (event.runtimeType) {
      case FetchMoreNotificationData:
        final result = await notificationRepository.fetchNotificationHistory(
            pageIndex: indexPage + 1, limit: 10);
        yield result.fold(
          (failure) => state,
          (value) {
            if (value?.isNotEmpty ?? false) {
              indexPage++;
            }
            final list = <NotificationHistoryModel>[];
            list.addAll(state.notificationItemHistoryList ?? []);
            list.addAll(value ?? []);
            return state.copyWith(
                notificationItemHistoryList: list,
                refreshTime: DateTime.now().toIso8601String());
          },
        );
        break;
      case TagReady:
        yield handleTagReady(event);
        break;
      case FetchNotificationData:
        indexPage = 0;
        final result = await notificationRepository.fetchNotificationHistory(
            pageIndex: indexPage, limit: 10);
        yield* notificationHistoryInteract.handleNotificationHistoryResult(
            result, state);
        break;
      case RemoveNotification:
        final events = event as RemoveNotification;

        final newsList = <NotificationHistoryModel>[
          ...state.notificationItemHistoryList
        ];

        ///remove notification from local
        newsList.removeWhere((element) => events.item.id == element.id);
        yield state.copyWith(notificationItemHistoryList: newsList);

        await notificationRepository
            .removeNotificationFromFeed(events.item.id.toString());

        add(FetchNotificationData());
        break;
      case TurnOffNotification:
        final events = event as TurnOffNotification;
        final type = events.item.type == PARAM_EVENT_DETAILS
            ? ENTITY_TYPE_NODE
            : ENTITY_TYPE_POST;
        final postId = getPostIdByType(events.item, events.item.type);
        await notificationRepository.turnOffNotificationFromOwner(
            postId, 'add', type);
        // yield* notificationHistoryInteract
        //     .handleTurnOffNotificationFromOwnerResult(result, state);
        add(FetchNotificationData());
        break;
      default:
        break;
    }
  }

  NotificationHistoryState handleTagReady(TagReady event) {
    event.item.isNew = false;
    return state.copyWith(refreshTime: DateTime.now().toIso8601String());
  }

  String getPostIdByType(NotificationHistoryModel item, String type) {
    switch (type) {
      case PARAM_EVENT_DETAILS:
        return item.data.eventId.toString();
      case PARAM_MY_POST:
        return item.data.postId.toString();
      default:
        return item.data.postId.toString();
    }
  }
}
