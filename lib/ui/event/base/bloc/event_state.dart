part of 'event_bloc.dart';

@immutable
class EventState extends Equatable {
  final int currentEventCateId;
  final String refreshTime;
  final bool isRefreshing;
  final FilterDateModel currentFilterDate;
  final SortType sortType;
  final Map<String, Map<String, List<EventInfo>>> groupEvents;
  final List<EventCategory> eventCategories;
  final DateTime startDate;
  final DateTime endDate;
  final List<FilterDateModel> listFilterDates;

  EventState({
    this.listFilterDates,
    this.isRefreshing,
    this.currentEventCateId = 0,
    this.currentFilterDate,
    this.refreshTime,
    this.sortType,
    this.eventCategories,
    this.groupEvents,
    this.startDate,
    this.endDate,
  });

  factory EventState.init(EventRepository eventRepository) {
    final listFilterDates = <FilterDateModel>[];
    listFilterDates.add(FilterDateModel.init(
        name: Lang.event_soonest.tr(), type: FilterDateType.SOONEST));
    listFilterDates.add(FilterDateModel.init(
        name: Lang.event_today.tr(), type: FilterDateType.TODAY));
    listFilterDates.add(FilterDateModel.init(
        name: Lang.event_this_week.tr(), type: FilterDateType.THIS_WEEK));
    listFilterDates.add(FilterDateModel.init(
        name: Lang.event_this_month.tr(), type: FilterDateType.THIS_MONTH));

    return EventState(
        listFilterDates: listFilterDates,
        eventCategories: eventRepository.getEventCategories(),
        startDate: null,
        endDate: null,
        isRefreshing: false,
        sortType: SortType.SOONEST,
        groupEvents: const {},
        currentFilterDate: listFilterDates[0]);
  }

  factory EventState.clone({EventState state}) {
    return EventState(
      listFilterDates: state.listFilterDates,
      currentEventCateId: state.currentEventCateId,
      currentFilterDate: state.currentFilterDate,
      eventCategories: state.eventCategories,
      sortType: state.sortType,
      isRefreshing: state.isRefreshing,
      groupEvents: state.groupEvents,
      startDate: state.startDate,
      endDate: state.endDate,
    );
  }

  EventState copyWith(
      {int currentEventCateId,
      FilterDateModel currentFilterDate,
      Map<String, Map<String, List<EventInfo>>> groupEvents,
      List<EventCategory> eventCategories,
      String refreshTime,
      DateTime startDate,
      bool isRefreshing,
      SortType sortType,
      DateTime endDate,
      List<FilterDateModel> listFilterDates}) {
    return EventState(
      eventCategories: eventCategories ?? this.eventCategories,
      groupEvents: groupEvents ?? this.groupEvents,
      sortType: sortType ?? this.sortType,
      isRefreshing: isRefreshing ?? false,
      refreshTime: refreshTime ?? this.refreshTime,
      currentEventCateId: currentEventCateId ?? this.currentEventCateId,
      currentFilterDate: currentFilterDate ?? this.currentFilterDate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      listFilterDates: listFilterDates ?? this.listFilterDates,
    );
  }

  @override
  List<Object> get props => [
        listFilterDates,
        sortType,
        startDate,
        isRefreshing,
        currentEventCateId,
        refreshTime,
        groupEvents,
        groupEvents?.length ?? 0,
        eventCategories,
        endDate,
      ];
}

class SearchResultState extends EventState {
  final Map<String, List<EventInfo>> events;
  final String keyWord;

  SearchResultState({this.events, this.keyWord, EventState state})
      : super(
          listFilterDates: state.listFilterDates,
          currentEventCateId: state.currentEventCateId,
          currentFilterDate: state.currentFilterDate,
          eventCategories: state.eventCategories,
          groupEvents: state.groupEvents,
          startDate: state.startDate,
          isRefreshing: state.isRefreshing,
          sortType: state.sortType,
          endDate: state.endDate,
        );

  @override
  List<Object> get props => [
        keyWord,
        events,
      ];
}
