import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:location/location.dart';
import '../common/di/injection/injector.dart';
import '../data/source/local/prefs/app_preferences.dart';

class LocationWrapper {
  final location = Location();
  final appPre = sl<AppPreferences>();
  StreamController<LocationData> _streamController;
  LocationData _locationData;

  void init() {
    location.changeSettings(distanceFilter: 30);
    location.onLocationChanged.listen((LocationData currentLocation) async {
      _locationData = currentLocation;
      if (!(_streamController?.isClosed ?? true)) {
        _streamController?.sink?.add(currentLocation);
      }
    });
  }

  Future<double> calculateDistance(double lat, double lng) async {
    _locationData ??= await locationData();
    if (_locationData != null) {
      const p = 0.017453292519943295;
      const c = cos;
      final a = 0.5 -
          c((lat - _locationData.latitude) * p) / 2 +
          c(_locationData.latitude * p) *
              c(lat * p) *
              (1 - c((lng - _locationData.longitude) * p)) /
              2;
      return 12742 * asin(sqrt(a));
    } else {
      return 0;
    }
  }

  Future<bool> requestPermission() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    return true;
  }

  Future<LocationData> locationData() async {
    final _serviceEnabled = await location.serviceEnabled();
    if (_serviceEnabled) {
      final locationData = await location.getLocation();
      if (locationData != null) {
        _locationData = locationData;
        final Map mapLocation = <String, double>{
          'latitude': _locationData.latitude,
          'longitude': _locationData.longitude
        };
        appPre.saveMyLocation(json.encode(mapLocation));
        return locationData;
      } else {
        final hasCache = appPre.getMyLocation();
        if (hasCache != null && hasCache.isNotEmpty) {
          try {
            final Map<String, dynamic> data = json.decode(hasCache) as Map;
            final mapLocation =
            data.map((key, value) => MapEntry<String, double>(key, value));
            return LocationData.fromMap(mapLocation);
          } catch (ex) {
            print('Convert Location fail' + ex.toString());
          }
        }
        return null;
      }
    } else {
      final hasCache = appPre.getMyLocation();
      if (hasCache != null && hasCache.isNotEmpty) {
        try {
          final Map<String, dynamic> data = json.decode(hasCache) as Map;
          final mapLocation =
          data.map((key, value) => MapEntry<String, double>(key, value));
          return LocationData.fromMap(mapLocation);
        } catch (ex) {
          print('Convert Location fail' + ex.toString());
        }
      }
      return null;
    }
  }

  Future<void> addListener(StreamController streamController) async {
    _streamController = streamController;
    final hasCache = appPre.getMyLocation();
    if (hasCache != null && hasCache.isNotEmpty) {
      try {
        final Map<String, dynamic> data = json.decode(hasCache) as Map;
        final mapLocation =
        data.map((key, value) => MapEntry<String, double>(key, value));
        _streamController?.sink?.add(LocationData.fromMap(mapLocation));
      } catch (ex) {
        print('Convert Location fail' + ex.toString());
      }
    }
  }
}
