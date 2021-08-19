import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:marvista/data/model/data_models/search_result_data_model.dart';
import 'package:marvista/data/source/failure.dart';
import 'package:marvista/utils/date_util.dart';

import '../../../../data/model/events.dart';
import '../../../../data/model/places_model.dart';
import '../../../../data/model/recent_model.dart';
import '../../../../data/repository/search_repository.dart';
import '../../../../utils/log_utils.dart';

part 'homesearch_event.dart';

part 'homesearch_state.dart';

class HomeSearchBloc extends Bloc<HomeSearchEvent, HomeSearchState> {
  final SearchRepository searchRepository;

  HomeSearchBloc({
    @required this.searchRepository,
  }) : super(HomeSearchInitial());

  @override
  Stream<HomeSearchState> mapEventToState(
    HomeSearchEvent event,
  ) async* {
    switch (event.runtimeType) {
      case SearchkeyWordEvent:
        yield* _mapSearchChangedEvent(event);
        break;
      case SelectExperienceSearch:
        yield* _mapRefreshSearchChangedEvent(event);
        break;
      case ClearSearchEvent:
        yield* _mapClearSearchEvent(event);
        break;
      case FocusFieldSearchEvent:
        yield* _mapFocusFieldSearchEvent(event);
        break;
      case GetSearchRecentEvent:
        yield* _mapGetSearchRecentEvent(event);
    }
  }

  Stream<HomeSearchState> _mapRefreshSearchChangedEvent(
      SelectExperienceSearch event) async* {
    try {
      var lastKeyword = '';
      if (state is HomeSearchSuccess) {
        lastKeyword = (state as HomeSearchSuccess).keyword;
      }
      final data = await searchRepository.search(
          lastKeyword, event.experienceId ?? state.experienceId);
      if (data != null) {
        yield* _handleSearchResult(data, lastKeyword, event);
      }
    } catch (error) {
      LogUtils.d(error.toString());
      yield HomeSearchError(error.toString());
    }
  }

  Stream<HomeSearchState> _mapSearchChangedEvent(
      SearchkeyWordEvent event) async* {
    try {
      yield Searching(
        recentModels: state.recentModels,
        recentTodayModels: state.recentTodayModels,
        recentYesModels: state.recentYesModels,
        experienceId: event.experienceId ?? state.experienceId,
      );
      final data = await searchRepository.search(
          event.keyword, event.experienceId ?? state.experienceId);
      if (data != null) {
        yield* _handleSearchResult(data, event.keyword, event);
      }
    } catch (error) {
      LogUtils.d(error.toString());
      yield HomeSearchError(error.toString());
    }
  }

  Stream<HomeSearchState> _mapClearSearchEvent(ClearSearchEvent event) async* {
    yield HomeSearchInitial();
  }

  Stream<HomeSearchState> _mapFocusFieldSearchEvent(
      FocusFieldSearchEvent event) async* {
    yield HomeSearchDisplayed(
        isFocusFieldSearch: event.isFocusFieldSearch,
        listTrending: event.listTrending,
        recentModels: state.recentModels,
        recentTodayModels: state.recentTodayModels,
        recentYesModels: state.recentYesModels,
        experienceId: state.experienceId);
  }

  Stream<HomeSearchState> _mapGetSearchRecentEvent(
      HomeSearchEvent event) async* {
    try {
      ///load from cache
      final cacheData = searchRepository.getRecentSearch();
      if (cacheData?.isNotEmpty ?? false) {
        yield GetSearchRecentEventSuccess(
          recentModels: cacheData,
          recentTodayModels: reduceListRecent(mathRecentByDay(cacheData, 0)),
          recentYesModels: reduceListRecent(mathRecentByDay(cacheData, 1)),
          experienceId: event.experienceId,
          // listTrending: event
        );
      }

      final data =
          await searchRepository.recent(5, 'home', DateTime.now().millisecond);
      yield* _handleRecentResult(data, event);
    } catch (e) {
      yield GetSearchRecentEventSuccess(
        experienceId: event?.experienceId ?? 0,
        // listTrending: event
      );
    }
  }

  List<RecentModel> reduceListRecent(List<RecentModel> data) {
    if (data == null || data.isEmpty) {
      return data;
    }
    final reducedList = <RecentModel>[];

    data.reduce((value, element) {
      if (value.content != element.content) {
        reducedList.add(value);
      }
      return element;
    });
    reducedList.add(data.last);
    return reducedList;
  }

  List<RecentModel> mathRecentByDay(List<RecentModel> data, [int subDay = 0]) {
    final now = DateTime.now();
    final dayCheck = DateTime(now.year, now.month, now.day - subDay);
    return data
        ?.where((e) =>
            DateUtil.convertStringToDate(e.search_date,
                formatData: 'dd/MM/yyyy') ==
            dayCheck)
        ?.toList();
  }

  Stream<HomeSearchSuccess> _handleSearchResult(
      Either<Failure, SearchResultDataModel> resultServer,
      lastKeyword,
      event) async* {
    yield resultServer.fold(
      (failure) {
        return state;
      },
      (result) {
        return HomeSearchSuccess(
          events: result.events,
          keyword: lastKeyword,
          recentModels: state.recentModels,
          recentTodayModels: state.recentTodayModels,
          recentYesModels: state.recentYesModels,
          amenities: result.amenities,
          experienceId: event.experienceId ?? state.experienceId,
        );
      },
    );
  }

  Stream<HomeSearchState> _handleRecentResult(
      Either<Failure, List<RecentModel>> resultServer, event) async* {
    yield resultServer.fold(
      (failure) {
        return state;
      },
      (result) {
        return GetSearchRecentEventSuccess(
          recentModels: result,
          recentTodayModels: reduceListRecent(mathRecentByDay(result, 0)),
          recentYesModels: reduceListRecent(mathRecentByDay(result, 1)),
          experienceId: event.experienceId,
          // listTrending: event
        );
      },
    );
  }
}
