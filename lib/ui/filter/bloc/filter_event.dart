import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../data/model/area_item.dart';

@immutable
abstract class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object> get props => [];
}

class ReStoreFilter extends FilterEvent {
  final Map<int, Map> filterOptSelected;

  ReStoreFilter({this.filterOptSelected});
}

class SelectedAreaItem extends FilterEvent {
  final String fid;
  final String type;
  final AreaItem areaItem;

  SelectedAreaItem({this.fid, this.type, this.areaItem});

  @override
  List<Object> get props => [fid, type, areaItem];
}

class SliderChanged extends FilterEvent {
  final int fid;
  final String type;
  final String key;
  final double sliderValue;

  SliderChanged({this.fid, this.key, this.type, this.sliderValue});

  @override
  List<Object> get props => [fid, type, sliderValue, key];
}

class RangeSliderChanged extends FilterEvent {
  final int fid;
  final String type;
  final String key;
  final Map<String, double> rangeSliderValue;

  RangeSliderChanged({this.fid, this.key, this.type, this.rangeSliderValue});

  @override
  List<Object> get props => [fid, type, rangeSliderValue, key];
}

class SelectedChanged extends FilterEvent {
  final int fid;
  final String type;
  final String key;
  final FilterItem itemSelected;

  SelectedChanged({this.fid, this.key, this.type, this.itemSelected});

  @override
  List<Object> get props => [fid, type, itemSelected, key];
}

class DateChange extends FilterEvent {
  final int fid;
  final String type;
  final String key;
  final String startDate;
  final String endDate;

  DateChange(this.fid, this.type, this.key, this.startDate, this.endDate);

  @override
  List<Object> get props => [fid, type, startDate, key, endDate];
}

class MultiSelectedChanged extends FilterEvent {
  final int fid;
  final String type;
  final String key;
  final FilterItem itemMultiSelected;

  MultiSelectedChanged({this.fid, this.key, this.type, this.itemMultiSelected});

  @override
  List<Object> get props => [fid, type, itemMultiSelected, key];
}

class ClearAllFilter extends FilterEvent {}

class ClearOptionFilter extends FilterEvent {
  final int fid;

  ClearOptionFilter({this.fid});

  @override
  List<Object> get props => [fid];
}
