import '../../utils/log_utils.dart';

class WeatherInfo {
  String dateTime;
  int epochDateTime;
  int weatherIcon;
  String iconPhrase;
  bool hasPrecipitation;
  bool isDaylight;
  Temperature temperature;
  int precipitationProbability;
  String mobileLink;
  String link;

  WeatherInfo(
      {this.dateTime,
      this.epochDateTime,
      this.weatherIcon,
      this.iconPhrase,
      this.hasPrecipitation,
      this.isDaylight,
      this.temperature,
      this.precipitationProbability,
      this.mobileLink,
      this.link});

  WeatherInfo.fromJson(Map<String, dynamic> json) {
    try {
      dateTime = json['DateTime'];
      epochDateTime = json['EpochDateTime'];
      weatherIcon = json['WeatherIcon'];
      iconPhrase = json['IconPhrase'];
      hasPrecipitation = json['HasPrecipitation'];
      isDaylight = json['IsDaylight'];
      temperature = json['Temperature'] != null
          ? Temperature.fromJson(json['Temperature'])
          : null;
      precipitationProbability = json['PrecipitationProbability'];
      mobileLink = json['MobileLink'];
      link = json['Link'];
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['DateTime'] = dateTime;
    data['EpochDateTime'] = epochDateTime;
    data['WeatherIcon'] = weatherIcon;
    data['IconPhrase'] = iconPhrase;
    data['HasPrecipitation'] = hasPrecipitation;
    data['IsDaylight'] = isDaylight;
    if (temperature != null) {
      data['Temperature'] = temperature.toJson();
    }
    data['PrecipitationProbability'] = precipitationProbability;
    data['MobileLink'] = mobileLink;
    data['Link'] = link;
    return data;
  }
}

class Temperature {
  double value;
  String unit;
  int unitType;

  Temperature({this.value, this.unit, this.unitType});

  Temperature.fromJson(Map<String, dynamic> json) {
    value = json['Value'];
    unit = json['Unit'];
    unitType = json['UnitType'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Value'] = value;
    data['Unit'] = unit;
    data['UnitType'] = unitType;
    return data;
  }
}
