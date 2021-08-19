import '../../utils/date_util.dart';
import '../../utils/log_utils.dart';

class OpenTimeModel {
  String headline;
  String timings;
  String date;
  String openTime;
  String closeTime;
  int openTimeTimestamp;
  int closeTimeTimestamp;

  OpenTimeModel(
      {this.headline,
      this.timings,
      this.date,
      this.openTime,
      this.closeTime,
      this.openTimeTimestamp,
      this.closeTimeTimestamp});

  OpenTimeModel.fromJson(Map<String, dynamic> json) {
    try {
      headline = json['headline'];
      timings = json['timings'];
      date = json['date'];
      openTime = json['open_time'];
      closeTime = json['close_time'];
      openTimeTimestamp = json['open_time_timestamp'] ?? 0;
      closeTimeTimestamp = json['close_time_timestamp'] ?? 0;
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  DateTime convertToDateTime() {
    try {
      return DateUtil.convertStringToDate(date,
          formatData: DateUtil.DATE_FORMAT_DDMMYYYY);
    } catch (e) {
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['headline'] = headline;
    data['timings'] = timings;
    data['date'] = date;
    data['open_time'] = openTime;
    data['close_time'] = closeTime;
    data['open_time_timestamp'] = openTimeTimestamp;
    data['close_time_timestamp'] = closeTimeTimestamp;
    return data;
  }
}
