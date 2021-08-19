import 'package:flutter/foundation.dart';

import '../../utils/log_utils.dart';

class AreaItem {
  String name;
  int id;
  String icon;
  String background;
  String isSingle;
  String idContent;
  String bundle;
  List<FilterArea> filter;

  AreaItem(
      {int id,
      String name,
      String icon,
      String background,
      String isSingle,
      String idContent,
      String bundle,
      List<FilterArea> filter}) {
    id = id;
    name = name;
    icon = icon;
    background = background;
    isSingle = isSingle;
    idContent = idContent;
    bundle = bundle;
    filter = filter;
  }

  AreaItem.fromJson(Map<String, dynamic> json) {
    try {
      name = json['name'];
      id = json['id'];
      background = json['background'];
      icon = json['icon'];
      isSingle = json['is_single'];
      idContent = json['id_content'];
      bundle = json['bundle'];
      if (json['filter'] != null) {
        filter = <FilterArea>[];
        json['filter'].forEach((v) {
          filter.add(FilterArea.fromJson(v));
        });
       
      }
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['background'] = background;
    data['icon'] = icon;
    data['is_single'] = isSingle;
    data['id_content'] = idContent;
    data['bundle'] = bundle;
    if (filter != null) {
      data['filter'] = filter.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FilterArea {
  String name;
  int fid;
  String type;
  String key;
  String unit;
  List<FilterItem> filterItem;

  FilterArea(
      {String name,
      int fid,
      String type,
      String unit,
      List<FilterItem> filterItem}) {
    name = name;
    fid = fid;
    type = type;
    unit = unit;
    filterItem = filterItem;
  }

  FilterArea.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    fid = json['fid'];
    type = json['type'];
    key = json['key'];
    unit = json['unit'];
    if (json['data'] != null) {
      filterItem = <FilterItem>[];
      json['data'].forEach((v) {
        filterItem.add(FilterItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['fid'] = fid;
    data['type'] = type;
    data['key'] = key;
    data['unit'] = unit;
    if (filterItem != null) {
      data['data'] = filterItem.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FilterItem {
  bool selected;
  int id;
  String name;
  String number;
  String icon;

  FilterItem({int id, String name, String number, String icon}) {
    name = name;
    id = id;
    number = number;
    icon = icon;
  }

  FilterItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    selected = false;
    name = json['name'];
    number = json['number'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['number'] = number;
    data['icon'] = icon;
    return data;
  }
}
