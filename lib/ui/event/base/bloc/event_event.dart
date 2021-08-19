part of 'event_bloc.dart';

@immutable
class EventEvent {}

class FetchEvents extends EventEvent {
  final DateTime startDate;
  final DateTime endDate;
  final FilterDateModel filterDateModel;
  final String category;
  final dynamic filter;

  FetchEvents(
      {this.startDate,
      this.endDate,
      this.filterDateModel,
      this.category,
      this.filter});
}

class FetchEventCategory extends EventEvent {}

class SelectEventCategory extends EventEvent {
  final String id;

  SelectEventCategory({@required this.id});
}

class SearchEventChanged extends EventEvent {
  final String textSearch;
  final String cateId;

  SearchEventChanged({this.textSearch, this.cateId});
}

class OnClearSearch extends EventEvent {}

class RemoveEvent extends EventEvent {
  final String id;

  RemoveEvent(this.id);
}

class TurnOffEvent extends EventEvent {
  final String id;

  TurnOffEvent(this.id);
}

class OnSortEvent extends EventEvent{
  final SortType sortType;

  OnSortEvent(this.sortType);
}