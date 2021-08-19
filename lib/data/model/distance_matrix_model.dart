import '../../utils/log_utils.dart';

class DistanceMatrixModel {
  List<String> destinationAddresses;
  List<String> originAddresses;
  List<EstimateModel> rows;
  String status;

  DistanceMatrixModel({
    this.destinationAddresses,
    this.originAddresses,
    this.rows,
    this.status,
  });

  DistanceMatrixModel.fromJson(Map<String, dynamic> json) {
    try {
      destinationAddresses = json['destination_addresses'].cast<String>();
      originAddresses = json['origin_addresses'].cast<String>();
      if (json['rows'] != null) {
        rows = <EstimateModel>[];
        json['rows'].forEach((v) {
          rows.add(EstimateModel.fromJson(v));
        });
      }
      status = json['status'];
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['destination_addresses'] = destinationAddresses;
    data['origin_addresses'] = originAddresses;
    if (rows != null) {
      data['rows'] = rows.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class EstimateModel {
  List<MyElementsDisMatrix> elements;

  EstimateModel({this.elements});

  EstimateModel.fromJson(Map<String, dynamic> json) {
    try {
      if (json['elements'] != null) {
        elements = <MyElementsDisMatrix>[];
        json['elements'].forEach((v) {
          elements.add(MyElementsDisMatrix.fromJson(v));
        });
      }
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (elements != null) {
      data['elements'] = elements.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyElementsDisMatrix {
  MyDistance distance;
  MyDistance duration;
  String status;

  MyElementsDisMatrix({
    this.distance,
    this.duration,
    this.status,
  });

  MyElementsDisMatrix.fromJson(Map<String, dynamic> json) {
    try {
      distance = json['distance'] != null
          ? MyDistance.fromJson(json['distance'])
          : null;
      duration = json['duration'] != null
          ? MyDistance.fromJson(json['duration'])
          : null;
      status = json['status'];
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    if (status != null && status == 'OK') {
      if (distance != null) {
        data['distance'] = distance.toJson();
      }
      if (duration != null) {
        data['duration'] = duration.toJson();
      }
    }
    return data;
  }
}

class MyDistance {
  String text;
  int value;

  MyDistance({this.text, this.value});

  MyDistance.fromJson(Map<String, dynamic> json) {
    try {
      text = json['text'];
      value = json['value'];
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['text'] = text;
    data['value'] = value;
    return data;
  }
}
