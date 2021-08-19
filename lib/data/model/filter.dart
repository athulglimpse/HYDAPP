import 'package:marvista/utils/log_utils.dart';

class Filter {
  List<FilterItem> _filters;

  Filter({List<FilterItem> filters}) {
    _filters = filters;
  }

  factory Filter.initial() {
    return Filter(
      filters: <FilterItem>[],
    );
  }

  List<FilterItem> get filters => _filters;
  set filters(List<FilterItem> filters) => _filters = filters;

  Filter.fromMap(Map<String, dynamic> json) {
    if (json != null) {
      _filters = <FilterItem>[];
      json.forEach(
          (key, value) => _filters.add(FilterItem.fromMap(key, value)));
    }
  }

  Filter.fromJson(Map<String, dynamic> json) {
    try{
      if (json['filters'] != null) {
        _filters = <FilterItem>[];
        json['filters'].forEach((v) {
          _filters.add(FilterItem.fromJson(v));
        });
      }
    }catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }

  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (_filters != null) {
      data['filters'] = _filters.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FilterItem {
  String _name;
  List<Items> _items;

  FilterItem({List<Items> items, String name}) {
    _items = items;
    _name = name;
  }

  List<Items> get items => _items;
  String get name => _name;
  set name(String name) => _name = name;
  set items(List<Items> items) => _items = items;

  FilterItem.fromMap(String name, Map<String, dynamic> json) {
    try{
      _name = name;
      if (json['items'] != null) {
        _items = <Items>[];
        json['items'].forEach((v) {
          _items.add(Items.fromJson(v));
        });
      }
    }catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }

  }

  FilterItem.fromJson(Map<String, dynamic> json) {
    try{
      _name = json['name'];
      if (json['items'] != null) {
        _items = <Items>[];
        json['items'].forEach((v) {
          _items.add(Items.fromJson(v));
        });
      }
    }catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }

  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (_items != null) {
      data['items'] = _items.map((v) => v.toJson()).toList();
    }
    data['name'] = _name;
    return data;
  }
}

class Items {
  dynamic _id;
  String _name;

  Items({dynamic id, String value}) {
    _id = id;
  }

  dynamic get id => _id;
  set id(dynamic id) => _id = id;
  String get name => _name;
  set name(String name) => _name = name;

  Items.fromJson(Map<String, dynamic> json) {
    try{
      _id = json['id'];
      _name = json['name'];
    }catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }

  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    return data;
  }
}
