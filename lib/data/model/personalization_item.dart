import '../../utils/log_utils.dart';

class PersonalizationItem {
  int _id;
  bool _selected = false;
  String _title;
  String _image;
  String _primaryColor;
  String _secondaryColor;
  List<Items> _items;

  PersonalizationItem({
    int id,
    bool selected,
    String title,
    String image,
    String primaryColor,
    String secondaryColor,
    List<Items> items,
  }) {
    _id = id;
    _selected = selected;
    _title = title;
    _image = image;
    _primaryColor = primaryColor;
    _secondaryColor = secondaryColor;
    _items = items;
  }

  int get id => _id;
  set id(int id) => _id = id;
  bool get selected => _selected;
  set selected(bool selected) => _selected = selected;
  String get title => _title;
  set title(String title) => _title = title;
  String get image => _image;
  set image(String image) => _image = image;
  String get primaryColor => _primaryColor;
  set primaryColor(String primaryColor) => _primaryColor = primaryColor;
  String get secondaryColor => _secondaryColor;
  set secondaryColor(String secondaryColor) => _secondaryColor = secondaryColor;
  List<Items> get items => _items;
  set items(List<Items> items) => _items = items;

  PersonalizationItem.fromJson(Map<String, dynamic> json) {
    try {
      _id = json['id'];
      _title = json['title'];
      _image = json['image'];
      _primaryColor = json['primary_color'];
      _secondaryColor = json['secondary_color'];
      if (json['items'] != null) {
        _items = <Items>[];
        json['items'].forEach((v) {
          final items = Items.fromJson(v);
          items.color = _primaryColor;
          _items.add(items);
        });
      }
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = _id;
    data['selected'] = _selected;
    data['title'] = _title;
    data['image'] = _image;
    data['primary_color'] = _primaryColor;
    data['secondary_color'] = _secondaryColor;
    if (_items != null) {
      data['items'] = _items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int id;
  String _color;
  bool _selected = false;
  String _title;

  Items({bool selected, String title}) {
    _selected = selected;
    _title = title;
  }

  String get color => _color;
  set color(String color) => _color = color;
  bool get selected => _selected;
  set selected(bool selected) => _selected = selected;
  String get title => _title;
  set title(String title) => _title = title;

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    _title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = _title;
    return data;
  }
}
