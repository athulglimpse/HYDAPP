import '../../utils/log_utils.dart';

class HelpReportModel {
  int id;
  String name;

  HelpReportModel({this.id, this.name});

  HelpReportModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      name = json['name'];
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
