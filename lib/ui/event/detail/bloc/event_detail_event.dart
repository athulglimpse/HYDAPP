part of 'event_detail_bloc.dart';

@immutable
abstract class EventDetailEvent {}

class CopyEventInfo extends EventDetailEvent {
  final EventInfo eventInfo;

  CopyEventInfo(this.eventInfo);
}

class FetchEventDetailInfo extends EventDetailEvent {
  final String id;

  FetchEventDetailInfo(this.id);
}

class AddFavorite extends EventDetailEvent {
  final String id;
  final String cate;

  AddFavorite({this.id, this.cate});
}

class FetchMoreEventLikeThis extends EventDetailEvent {
  final String id;
  final String cate;

  FetchMoreEventLikeThis(this.id, this.cate);
}

class RemoveEvent extends EventDetailEvent {
  final String id;

  RemoveEvent(this.id);
}

class TurnOffEvent extends EventDetailEvent {
  final String id;

  TurnOffEvent(this.id);
}

class RemoveEventAlsoLike extends EventDetailEvent {
  final String id;
  final String cate;
  RemoveEventAlsoLike(this.id, this.cate);
}

class TurnOffEventAlsoLike extends EventDetailEvent {
  final String id;
  final String cate;

  TurnOffEventAlsoLike(this.id, this.cate);
}
