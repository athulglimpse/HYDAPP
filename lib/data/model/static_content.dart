import '../../utils/log_utils.dart';

class StaticContent {
  List<GetStatedContent> _staticContent;
  String _termCondition;
  String _policyPrivacy;

  StaticContent({
    List<GetStatedContent> staticContent,
    String termCondition,
    String policyPrivacy,
  }) {
    _staticContent = staticContent;
    _termCondition = termCondition;
    _policyPrivacy = policyPrivacy;
  }

  List<GetStatedContent> get staticData => _staticContent;
  set staticData(List<GetStatedContent> staticContent) =>
      _staticContent = staticContent;
  String get termCondition => _termCondition;
  set termCondition(String termCondition) => _termCondition = termCondition;
  String get policyPrivacy => _policyPrivacy;
  set policyPrivacy(String policyPrivacy) => _policyPrivacy = policyPrivacy;

  StaticContent.fromJson(Map<String, dynamic> json) {
    try {
      if (json['static_content'] != null) {
        _staticContent = <GetStatedContent>[];
        json['static_content'].forEach((v) {
          _staticContent.add(GetStatedContent.fromJson(v));
        });
      }
      _termCondition = json['term_condition'];
      _policyPrivacy = json['policy_privacy'];
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (_staticContent != null) {
      data['static_content'] = _staticContent.map((v) => v.toJson()).toList();
    }
    data['term_condition'] = _termCondition;
    data['policy_privacy'] = _policyPrivacy;
    return data;
  }
}

class GetStatedContent {
  dynamic _id;
  String _title;
  String _description;
  String _image;

  GetStatedContent(
      {dynamic id, String title, String description, String image}) {
    _id = id;
    _title = title;
    _image = image;
    _description = description;
  }

  dynamic get id => _id;
  set id(dynamic id) => _id = id;

  String get title => _title;
  set title(String title) => _title = title;

  String get description => _description;
  set description(String description) => _description = description;

  String get image => _image;
  set image(String image) => _image = image;

  GetStatedContent.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _image = json['image'];
    _description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = _id;
    data['title'] = _title;
    data['image'] = _image;
    data['description'] = _description;
    return data;
  }
}
