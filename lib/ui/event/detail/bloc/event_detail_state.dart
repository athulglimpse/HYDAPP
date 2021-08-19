part of 'event_detail_bloc.dart';

@immutable
class EventDetailState extends Equatable {
  final EventDetailInfo eventDetailInfo;
  final String timeRefresh;
  final List<EventInfo> listEventAlsoLike;
  final EventRoute currentRoute;
  final UserInfo userInfo;
  final bool isRefreshing;

  EventDetailState(
      {this.eventDetailInfo,
      this.timeRefresh,
      this.isRefreshing,
      this.currentRoute,
      this.userInfo,
      this.listEventAlsoLike});

  factory EventDetailState.init({UserRepository userRepository}) {
    return EventDetailState(
        currentRoute: EventRoute.enterEventPage,
        isRefreshing: false,
        userInfo: userRepository.getCurrentUser());
  }

  EventDetailState copyWith({
    EventDetailInfo eventDetailInfo,
    String timeRefresh,
    bool isRefreshing,
    List<EventInfo> listEventAlsoLike,
    EventRoute currentRoute,
  }) {
    return EventDetailState(
      userInfo: userInfo ?? userInfo,
      eventDetailInfo: eventDetailInfo ?? this.eventDetailInfo,
      isRefreshing: isRefreshing ?? false,
      listEventAlsoLike: listEventAlsoLike ?? this.listEventAlsoLike,
      timeRefresh: timeRefresh ?? this.timeRefresh,
      currentRoute: currentRoute ?? this.currentRoute,
    );
  }

  @override
  List<Object> get props => [
        eventDetailInfo,
        timeRefresh,
        isRefreshing,
        userInfo,
        listEventAlsoLike,
        currentRoute,
      ];
}

enum EventRoute {
  enterEventPage,
  enterRemoveEvent,
  enterTurnOffEvent,
}
