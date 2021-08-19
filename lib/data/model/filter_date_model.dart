import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
class FilterDateModel extends Equatable {
  final String name;
  final FilterDateType type;

  FilterDateModel({this.name, this.type});

  factory FilterDateModel.init({String name, FilterDateType type}) {
    return FilterDateModel(name: name, type: type);
  }

  @override
  List<Object> get props => [name, type];
}

enum FilterDateType { SOONEST, TODAY, THIS_WEEK, THIS_MONTH }
