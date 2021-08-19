import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../data/model/events.dart';
import '../../../../data/model/events_detail.dart';
import '../../../../data/model/user_info.dart';
import '../../../../data/repository/event_repository.dart';
import '../../../../data/repository/home_repository.dart';
import '../../../../data/repository/post_repository.dart';
import '../../../../data/repository/user_repository.dart';
import '../../../../data/source/api_end_point.dart';
import '../../../../data/source/failure.dart';

part 'event_detail_event.dart';
part 'event_detail_state.dart';

class EventDetailBloc extends Bloc<EventDetailEvent, EventDetailState> {
  final EventRepository eventRepository;
  final HomeRepository homeRepository;
  final PostRepository postRepository;
  final UserRepository userRepository;

  EventDetailBloc({
    this.homeRepository,
    this.eventRepository,
    this.postRepository,
    this.userRepository,
  }) : super(EventDetailState.init(userRepository: userRepository));

  @override
  Stream<EventDetailState> mapEventToState(
    EventDetailEvent event,
  ) async* {
    if (event is CopyEventInfo) {
      final eventDetail =
          eventRepository.getEventDetail(event.eventInfo.id.toString());
      if (eventDetail != null) {
        yield state.copyWith(eventDetailInfo: eventDetail);
      } else {
        yield state.copyWith(
            eventDetailInfo: EventDetailInfo.fromModel(event.eventInfo));
      }
      yield state.copyWith(isRefreshing: true);
    } else if (event is AddFavorite) {
      if (state.eventDetailInfo.isFavorite != null) {
        state.eventDetailInfo.isFavorite = !state.eventDetailInfo.isFavorite;
      }
      yield state.copyWith(timeRefresh: DateTime.now().toIso8601String());

      await homeRepository.addFavorite(
          event.id, state.eventDetailInfo.isFavorite, FavoriteType.EVENT);

      add(FetchEventDetailInfo(event.id));
    } else if (event is FetchEventDetailInfo) {
      final result = await eventRepository.fetchEventDetail(id: event.id);
      yield* _handleEventDetailResult(result);
    } else if (event is FetchMoreEventLikeThis) {
      yield* _handleEventAlsoLikeResult(await eventRepository
          .fetchMoreEventLikeThis(id: event.id, cate: event.cate));
    } else if (event is RemoveEventAlsoLike) {
      await postRepository.removePostFromFeed(
          event.id, 'add', ENTITY_TYPE_NODE);
      add(FetchMoreEventLikeThis(event.id, event.cate));
    } else if (event is TurnOffEventAlsoLike) {
      await postRepository.turnOffPostFromOwner(
          event.id, 'add', ENTITY_TYPE_NODE);
      add(FetchMoreEventLikeThis(event.id, event.cate));
    } else if (event is RemoveEvent) {
      await postRepository.removePostFromFeed(
          event.id, 'add', ENTITY_TYPE_NODE);
      yield state.copyWith(currentRoute: EventRoute.enterRemoveEvent);
    } else if (event is TurnOffEvent) {
      await postRepository.turnOffPostFromOwner(
          event.id, 'add', ENTITY_TYPE_NODE);
      yield state.copyWith(currentRoute: EventRoute.enterTurnOffEvent);
    }
  }

  Stream<EventDetailState> _handleEventDetailResult(
    Either<Failure, EventDetailInfo> resultServer,
  ) async* {
    yield resultServer.fold(
      (failure) {
        return state;
      },
      (result) {
        add(FetchMoreEventLikeThis(
            result.id.toString(), result.category?.id?.toString() ?? '0'));
        return state.copyWith(eventDetailInfo: result);
      },
    );
  }

  Stream<EventDetailState> _handleEventAlsoLikeResult(
    Either<Failure, List<EventInfo>> resultServer,
  ) async* {
    yield resultServer.fold(
      (failure) {
        return state;
      },
      (result) {
        return state.copyWith(listEventAlsoLike: result);
      },
    );
  }
}
