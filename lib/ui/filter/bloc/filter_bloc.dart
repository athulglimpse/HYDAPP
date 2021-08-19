import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../data/model/area_item.dart';
import '../../../data/repository/user_repository.dart';
import '../util/filter_util.dart';

import 'filter_event.dart';
import 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final UserRepository userRepository;

  FilterBloc({@required this.userRepository}) : super(FilterState.initial());

  @override
  Stream<FilterState> mapEventToState(FilterEvent event) async* {
    if (event is SelectedAreaItem) {
      yield state.copyWith(areaItem: event.areaItem);
    } else if (event is ReStoreFilter) {
      yield state.copyWith(filterOptSelected: event.filterOptSelected);
    } else if (event is SliderChanged) {
      yield _mergeFilterOpt(
          event.fid, event.type, event.key, event.sliderValue);
    } else if (event is RangeSliderChanged) {
      yield _mergeFilterOpt(
          event.fid, event.type, event.key, event.rangeSliderValue);
    } else if (event is DateChange) {
      yield _mergeFilterOptDate(
          event.fid, event.type, event.key, event.startDate, event.endDate);
    } else if (event is SelectedChanged) {
      yield _mergeFilterOpt(
          event.fid, event.type, event.key, event.itemSelected);
    } else if (event is MultiSelectedChanged) {
      final items = <int, FilterItem>{};
      if (state.filterOptSelected.containsKey(event.fid)) {
        items.addAll(Map<int, FilterItem>.from(
            state.filterOptSelected[event.fid][FILTER_KEY_VALUE]));
      }

      if (items.containsKey(event.itemMultiSelected.id)) {
        items.remove(event.itemMultiSelected.id);
      } else {
        items[event.itemMultiSelected.id] = event.itemMultiSelected;
      }

      yield _mergeFilterOpt(event.fid, event.type, event.key, items);
    } else if (event is ClearAllFilter) {
      yield state.clearAll();
    } else if (event is ClearOptionFilter) {
      yield state.clearOption(fid: event.fid);
    }
  }

  FilterState _mergeFilterOpt(int fid, String type, String key, dynamic value) {
    final filterValue = {
      FILTER_KEY_ID: fid,
      FILTER_KEY_TYPE: type,
      FILTER_KEY_KEY: key,
      FILTER_KEY_VALUE: value,
    };

    final mapFilter = <int, Map>{};
    mapFilter.addAll(state.filterOptSelected);
    mapFilter[fid] = filterValue;
    return state.copyWith(filterOptSelected: mapFilter);
  }

  FilterState _mergeFilterOptDate(
      int fid, String type, String key, String startDate, String endDate) {
    final filterValue = {
      FILTER_KEY_ID: fid,
      FILTER_KEY_TYPE: type,
      FILTER_KEY_KEY: key,
      FILTER_KEY_START_DATE: startDate,
      FILTER_KEY_END_DATE: endDate
    };

    final mapFilter = <int, Map>{};
    mapFilter.addAll(state.filterOptSelected);
    mapFilter[fid] = filterValue;
    return state.copyWith(filterOptSelected: mapFilter);
  }
}
