part of '../utils.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(dynamic latitude, dynamic longitude) async {
    if (Platform.isAndroid) {
      var mapUrl = '${IntentAction.googleMapDirection}$latitude,$longitude';
      mapUrl = '${IntentAction.googleMapDirection}$latitude,$longitude';
      if (await canLaunch(mapUrl)) {
        await launch(mapUrl);
      } else {
        throw 'Could not open the map.';
      }
    } else if(Platform.isIOS){
      print(double.tryParse(latitude.toString()));
      print(double.tryParse(longitude.toString()));
      final mapDefault = sl<AppPreferences>().getMapDefault();
      switch (mapDefault) {
        case AppPreferences.APPLE_MAP:
          final mapUrl = '${IntentAction.appleMapDirection}$latitude,$longitude';
          if (await canLaunch(mapUrl)) {
            await launch(mapUrl);
          } else {
            throw 'Could not open the map.';
          }
          break;
        case AppPreferences.GOOGLE_MAP:
          await MapLauncher.showDirections(
            mapType: MapType.google,
            destination: Coords(double.tryParse(latitude.toString()),
                double.tryParse(longitude.toString())),
          );
          break;
        case AppPreferences.WAZE_MAP:
          await MapLauncher.showDirections(
            mapType: MapType.waze,
            destination: Coords(double.tryParse(latitude.toString()),
                double.tryParse(longitude.toString())),
          );
          break;
      }
      // var mapUrl = '${IntentAction.googleMapDirection}$latitude,$longitude';
      // if (Platform.isAndroid) {
      //   mapUrl = '${IntentAction.googleMapDirection}$latitude,$longitude';
      // } else if (Platform.isIOS) {
      //   mapUrl = '${IntentAction.appleMapDirection}$latitude,$longitude';
      // }
      //
      //
      //
      //
      //
    }
  }
}
