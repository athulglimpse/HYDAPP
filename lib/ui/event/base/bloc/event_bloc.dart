import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../common/dialog/sort_tool_dialog.dart';
import '../../../../common/localization/lang.dart';
import '../../../../data/model/event_category.dart';
import '../../../../data/model/events.dart';
import '../../../../data/model/filter_date_model.dart';
import '../../../../data/repository/event_repository.dart';
import '../../../../data/repository/post_repository.dart';
import '../../../../data/source/api_end_point.dart';
import '../../../../data/source/failure.dart';
import '../../../../utils/date_util.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository eventRepository;
  final PostRepository postRepository;

  EventBloc({this.postRepository, this.eventRepository})
      : super(EventState.init(eventRepository));

  @override
  Stream<EventState> mapEventToState(
    EventEvent event,
  ) async* {
    if (event is FetchEventCategory) {
      final result = await eventRepository.fetchEventCategories();
      yield* _handleEventCategoriesResult(result);
    } else if (event is OnSortEvent) {
      final groupEvents =
          state.groupEvents[state.currentEventCateId.toString()];
      groupEvents.entries.forEach((e) {
        doSortAZ(e.value, event.sortType);
      });
      yield state.copyWith(sortType: event.sortType);
    } else if (event is FetchEvents) {
      const cateId = '0';
      final stateDate = (event.filterDateModel != null &&
              event.filterDateModel.type == FilterDateType.SOONEST)
          ? DateUtil.dateFormatDDMMYYYY(DateTime.now(), locale: 'en')
          : (event.startDate != null
              ? DateUtil.dateFormatDDMMYYYY(event.startDate, locale: 'en')
              : DateUtil.dateFormatDDMMYYYY(state.startDate, locale: 'en'));
      final endDate = (event.filterDateModel != null &&
              event.filterDateModel.type == FilterDateType.SOONEST)
          ? DateUtil.dateFormatDDMMYYYY(
              DateTime(DateTime.now().year + 1, 12, 31),
              locale: 'en')
          : (event.endDate != null
              ? DateUtil.dateFormatDDMMYYYY(event.endDate, locale: 'en')
              : DateUtil.dateFormatDDMMYYYY(state.endDate, locale: 'en'));
      final result = await eventRepository.fetchEvent(
          cate: cateId, stateDate: stateDate, endDate: endDate);

      if (result.isRight()) {
        final listEvent = result.getOrElse(null);

        ///Sort by suitable name
        // listEvent?.sort((a, b) {
        //   if ((a?.suitable?.isNotEmpty ?? false) &&
        //       (b?.suitable?.isNotEmpty ?? false)) {
        //     return a?.suitable[0].name?.toLowerCase()?.trim()?.compareTo(
        //             b?.suitable[0].name?.toLowerCase()?.trim() ?? '') ??
        //         0;
        //   }
        //   return 0;
        // });

        final groupEvents = <String, Map<String, List<EventInfo>>>{};
        state.eventCategories.forEach((cate) {
          final eventByCate =
              listEvent.where((e) => e.category.id == cate.id).toList();
          var groupSuitables = <String, List<EventInfo>>{};
          groupSuitables = groupBy(eventByCate, (e) {
            if (e != null && e.suitable != null) {
              return e.suitable
                  .map((e) => e.name)
                  .toList()
                  .join(' ${Lang.event_and.tr()} ');
            } else {
              return '';
            }
          });

          groupEvents[cate.id.toString()] = groupSuitables;
        });

        ///group by Category All
        var groupSuitables = <String, List<EventInfo>>{};
        groupSuitables = groupBy(listEvent, (e) {
          if (e != null && e.suitable != null) {
            return e.suitable
                .map((e) => e.name)
                .toList()
                .join(' ${Lang.event_and.tr()} ');
          } else {
            return '';
          }
        });
        groupEvents[cateId] = groupSuitables;

        if (listEvent.isEmpty) {
          groupEvents.clear();
        }
        yield state.copyWith(
            isRefreshing: false,
            groupEvents: groupEvents,
            currentFilterDate: event.filterDateModel,
            startDate: event.startDate,
            refreshTime: DateTime.now().toIso8601String(),
            endDate: event.endDate);
      } else {
        yield state.copyWith(
            isRefreshing: false,
            currentFilterDate: event.filterDateModel,
            startDate: event.startDate,
            refreshTime: DateTime.now().toIso8601String(),
            endDate: event.endDate);
      }
    } else if (event is OnClearSearch) {
      yield EventState.clone(state: state);
    } else if (event is SelectEventCategory) {
      yield state.copyWith(
          isRefreshing: true, currentEventCateId: int.parse(event.id));
    } else if (event is SearchEventChanged) {
      final keyWork = event.textSearch.toLowerCase();
      if (keyWork.isNotEmpty) {
        ///Get List Event by Current Category
        final events = <String, List<EventInfo>>{};
        state.groupEvents[event.cateId].entries.forEach((element) {
          events[element.key] = List<EventInfo>.from(element.value);
        });

        events.entries.forEach((element) {
          element.value.removeWhere((event) =>
              !(event?.title?.toLowerCase()?.contains(keyWork) ?? false) &&
              !(event?.pickOneLocation?.locationAt
                      ?.toLowerCase()
                      ?.contains(keyWork) ??
                  false));
        });
        yield SearchResultState(
          keyWord: keyWork,
          events: events,
          state: state,
        );
      } else {
        yield EventState.clone(state: state);
      }
    } else if (event is RemoveEvent) {
      await postRepository.removePostFromFeed(
          event.id, 'add', ENTITY_TYPE_NODE);
      add(FetchEvents(
          startDate: DateTime.now(),
          endDate: DateTime(DateTime.now().year + 1, 12, 31)));
    } else if (event is TurnOffEvent) {
      await postRepository.turnOffPostFromOwner(
          event.id, 'add', ENTITY_TYPE_NODE);
      add(FetchEvents(
          startDate: DateTime.now(),
          endDate: DateTime(DateTime.now().year + 1, 12, 31)));
    }
  }

  Stream<EventState> _handleEventCategoriesResult(
    Either<Failure, List<EventCategory>> resultServer,
  ) async* {
    yield resultServer.fold(
      (failure) {
        return state;
      },
      (result) {
        result.insert(0, EventCategory(id: 0, name: Lang.home_all.tr()));
        add(FetchEvents(
            category: result[0].id.toString(),
            filterDateModel: state.currentFilterDate));
        return state.copyWith(
            eventCategories: result,
            currentFilterDate: state.currentFilterDate);
      },
    );
  }

  Map<String, List<EventInfo>> getListEventSelectCategory(
      String cateId, Map<String, Map<String, List<EventInfo>>> groupEvents) {
    var listEvents = <String, List<EventInfo>>{};
    if (groupEvents != null && groupEvents.isNotEmpty) {
      groupEvents.forEach((key, value) {
        if (key == cateId) {
          listEvents = value;
        }
      });
    }
    return listEvents;
  }

  void doSortAZ(List<EventInfo> events, SortType sortType) {
    if (sortType == SortType.ASC) {
      events.sort((a, b) {
        return a?.title
                ?.toLowerCase()
                ?.trim()
                ?.compareTo(b?.title?.toLowerCase()?.trim() ?? '') ??
            0;
      });
    } else if (sortType == SortType.DESC) {
      events.sort((a, b) {
        return b?.title
                ?.toLowerCase()
                ?.trim()
                ?.compareTo(a?.title?.toLowerCase()?.trim() ?? '') ??
            0;
      });
    } else {
      events.sort((a, b) {
        return a?.pickOneEventTime
                ?.convertToDateTime()
                ?.compareTo(b?.pickOneEventTime?.convertToDateTime()) ??
            0;
      });
    }
  }
}
