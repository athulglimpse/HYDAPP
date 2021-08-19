class FlashDealsInfo {
  int _id;
  String _title;
  String _image;
  String _url;
  String _open;
  String _close;
  String _price;
  String _currency;

  FlashDealsInfo({
    int id,
    String title,
    String image,
    String url,
    String close,
    String price,
    String currency,
    String open,
  }) {
    _id = id;
    _title = title;
    _image = image;
    _url = url;
    _open = open;
    _close = close;
    _price = price;
    _currency = currency;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get title => _title;
  set title(String title) => _title = title;
  String get image => _image;
  set image(String image) => _image = image;
  String get url => _url;
  set url(String url) => _url = url;
  String get open => _open;
  set open(String open) => _open = open;
  String get close => _close;
  set close(String close) => _close = close;
  String get price => _price;
  set price(String price) => _price = price;
  String get currency => _currency;
  set currency(String currency) => _currency = currency;

  FlashDealsInfo.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _image = json['image'];
    _url = json['url'];
    _open = json['open'];
    _close = json['close'];
    _price = json['price'];
    _currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = _id;
    data['title'] = _title;
    data['image'] = _image;
    data['url'] = _url;
    data['open'] = _open;
    data['close'] = _close;
    data['price'] = _price;
    data['currency'] = _currency;
    return data;
  }
}
