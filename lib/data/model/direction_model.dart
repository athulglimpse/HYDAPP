import '../../utils/log_utils.dart';

class DirectionModel {
  List<GeocodedWaypoints> geocodedWaypoints;
  List<Routes> routes;
  String status;

  DirectionModel({geocodedWaypoints, routes, status});

  DirectionModel.fromJson(Map<String, dynamic> json) {
    try {
      if (json['geocoded_waypoints'] != null) {
        geocodedWaypoints = <GeocodedWaypoints>[];
        json['geocoded_waypoints'].forEach((v) {
          geocodedWaypoints.add(GeocodedWaypoints.fromJson(v));
        });
      }
      if (json['routes'] != null) {
        routes = <Routes>[];
        json['routes'].forEach((v) {
          routes.add(Routes.fromJson(v));
        });
      }
      status = json['status'];
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (geocodedWaypoints != null) {
      data['geocoded_waypoints'] =
          geocodedWaypoints.map((v) => v.toJson()).toList();
    }
    if (routes != null) {
      data['routes'] = routes.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class GeocodedWaypoints {
  String geocoderStatus;
  String placeId;
  List<String> types;

  GeocodedWaypoints({geocoderStatus, placeId, types});

  GeocodedWaypoints.fromJson(Map<String, dynamic> json) {
    try {
      geocoderStatus = json['geocoder_status'];
      placeId = json['place_id'];
      types = json['types'].cast<String>();
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['geocoder_status'] = geocoderStatus;
    data['place_id'] = placeId;
    data['types'] = types;
    return data;
  }
}

class Routes {
  Bounds bounds;
  String copyrights;
  List<Legs> legs;
  Polyline overviewPolyline;
  String summary;
  List<String> warnings;

  Routes({bounds, copyrights, legs, overviewPolyline, summary, warnings});

  Routes.fromJson(Map<String, dynamic> json) {
    try {
      bounds = json['bounds'] != null ? Bounds.fromJson(json['bounds']) : null;
      copyrights = json['copyrights'];
      if (json['legs'] != null) {
        legs = <Legs>[];
        json['legs'].forEach((v) {
          legs.add(Legs.fromJson(v));
        });
      }
      overviewPolyline = json['overview_polyline'] != null
          ? Polyline.fromJson(json['overview_polyline'])
          : null;
      summary = json['summary'];
      warnings = json['warnings'].cast<String>();
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (bounds != null) {
      data['bounds'] = bounds.toJson();
    }
    data['copyrights'] = copyrights;
    if (legs != null) {
      data['legs'] = legs.map((v) => v.toJson()).toList();
    }
    if (overviewPolyline != null) {
      data['overview_polyline'] = overviewPolyline.toJson();
    }
    data['summary'] = summary;
    data['warnings'] = warnings;
    return data;
  }
}

class Bounds {
  Northeast northeast;
  Northeast southwest;

  Bounds({northeast, southwest});

  Bounds.fromJson(Map<String, dynamic> json) {
    try {
      northeast = json['northeast'] != null
          ? Northeast.fromJson(json['northeast'])
          : null;
      southwest = json['southwest'] != null
          ? Northeast.fromJson(json['southwest'])
          : null;
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (northeast != null) {
      data['northeast'] = northeast.toJson();
    }
    if (southwest != null) {
      data['southwest'] = southwest.toJson();
    }
    return data;
  }
}

class Northeast {
  double lat;
  double lng;

  Northeast({lat, lng});

  Northeast.fromJson(Map<String, dynamic> json) {
    try {
      lat = json['lat'];
      lng = json['lng'];
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class Legs {
  Distance distance;
  Distance duration;
  String endAddress;
  Northeast endLocation;
  String startAddress;
  Northeast startLocation;
  List<Steps> steps;

  Legs.fromJson(Map<String, dynamic> json) {
    try {
      distance =
          json['distance'] != null ? Distance.fromJson(json['distance']) : null;
      duration =
          json['duration'] != null ? Distance.fromJson(json['duration']) : null;
      endAddress = json['end_address'];
      endLocation = json['end_location'] != null
          ? Northeast.fromJson(json['end_location'])
          : null;
      startAddress = json['start_address'];
      startLocation = json['start_location'] != null
          ? Northeast.fromJson(json['start_location'])
          : null;
      if (json['steps'] != null) {
        steps = <Steps>[];
        json['steps'].forEach((v) {
          steps.add(Steps.fromJson(v));
        });
      }
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (distance != null) {
      data['distance'] = distance.toJson();
    }
    if (duration != null) {
      data['duration'] = duration.toJson();
    }
    data['end_address'] = endAddress;
    if (endLocation != null) {
      data['end_location'] = endLocation.toJson();
    }
    data['start_address'] = startAddress;
    if (startLocation != null) {
      data['start_location'] = startLocation.toJson();
    }
    if (steps != null) {
      data['steps'] = steps.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Distance {
  String text;
  int value;

  Distance({text, value});

  Distance.fromJson(Map<String, dynamic> json) {
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

class Steps {
  Distance distance;
  Distance duration;
  Northeast endLocation;
  String htmlInstructions;
  Polyline polyline;
  Northeast startLocation;
  List<Steps> steps;
  String travelMode;

  Steps(
      {distance,
      duration,
      endLocation,
      htmlInstructions,
      polyline,
      startLocation,
      steps,
      travelMode});

  Steps.fromJson(Map<String, dynamic> json) {
    try {
      distance =
          json['distance'] != null ? Distance.fromJson(json['distance']) : null;
      duration =
          json['duration'] != null ? Distance.fromJson(json['duration']) : null;
      endLocation = json['end_location'] != null
          ? Northeast.fromJson(json['end_location'])
          : null;
      htmlInstructions = json['html_instructions'];
      polyline =
          json['polyline'] != null ? Polyline.fromJson(json['polyline']) : null;
      startLocation = json['start_location'] != null
          ? Northeast.fromJson(json['start_location'])
          : null;
      if (json['steps'] != null) {
        steps = List<Steps>();
        json['steps'].forEach((v) {
          steps.add(Steps.fromJson(v));
        });
      }
      travelMode = json['travel_mode'];
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (distance != null) {
      data['distance'] = distance.toJson();
    }
    if (duration != null) {
      data['duration'] = duration.toJson();
    }
    if (endLocation != null) {
      data['end_location'] = endLocation.toJson();
    }
    data['html_instructions'] = htmlInstructions;
    if (polyline != null) {
      data['polyline'] = polyline.toJson();
    }
    if (startLocation != null) {
      data['start_location'] = startLocation.toJson();
    }
    if (steps != null) {
      data['steps'] = steps.map((v) => v.toJson()).toList();
    }
    data['travel_mode'] = travelMode;
    return data;
  }
}

class Polyline {
  String points;

  Polyline({points});

  Polyline.fromJson(Map<String, dynamic> json) {
    try {
      points = json['points'];
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['points'] = points;
    return data;
  }
}
