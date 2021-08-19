import 'package:location/location.dart';

import '../../../utils/data_form_util.dart';
import '../../model/amenity_model.dart';
import '../../model/direction_model.dart';
import '../../model/distance_matrix_model.dart';
import '../../model/location_model.dart';
import '../api_end_point.dart';
import '../failure.dart';
import 'remote_base.dart';

abstract class LocationRemoteDataSource {
  ///GET API
  Future<DirectionModel> guideDirection(
      LocationData myLocation, double lat, double long);

  Future<DistanceMatrixModel> estDistanceFromMyLocation(
      LocationModel myLocation,
      Map<String, LocationModel> listDestination,
      TravelMode travelMode);

  Future<List<AmenityModel>> searchNearBy({
    double lat,
    double long,
    String content,
    int experience_id,
    double distances,
  });
}

class LocationRemoteDataSourceImpl extends RemoteBaseImpl
    implements LocationRemoteDataSource {
  LocationRemoteDataSourceImpl();

  @override
  Future<DistanceMatrixModel> estDistanceFromMyLocation(
      LocationModel myLocation,
      Map<String, LocationModel> listDestination,
      TravelMode travelMode) async {
    final myLo = '${myLocation.lat},${myLocation.long}';

    var listDes = '';
    listDestination.entries.forEach((element) {
      listDes += '${element.value.lat},${element.value.long}|';
    });

    /// driving, walking, bicycling, transit
    String mode;
    switch (travelMode) {
      case TravelMode.bicycling:
        mode = 'bicycling';
        break;
      case TravelMode.driving:
        mode = 'driving';
        break;
      case TravelMode.transit:
        mode = 'transit';
        break;
      case TravelMode.walking:
        mode = 'walking';
        break;
    }

    if (listDes.isNotEmpty) {
      listDes = listDes.substring(0, listDes.length - 1);
    }

    final response =
        await dio.get(endPointDistanceMatrixBaseLocation, queryParameters: {
      'origins': myLo,
      'destinations': listDes,
      'mode': mode,
      'key': env.ggKey,
      'departure_time': 'now',
    }).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    if (response.statusCode == CODE_SUCCESS) {
      return DistanceMatrixModel.fromJson(response.data);
    } else {
      throw RemoteDataFailure(
          errorCode: response.statusCode.toString(),
          errorMessage: response.statusMessage);
    }
  }

  @override
  Future<List<AmenityModel>> searchNearBy({
    double lat,
    double long,
    String content,
    int experience_id,
    double distances,
  }) async {
    setPrivateToken();
    final response = await dio
        .get(endPointSearchNearBy,
            queryParameters: DataFormUtil.paramSearchNearBy(
                lat: lat,
                long: long,
                content: content,
                distance: distances,
                experience_id: experience_id))
        .catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<List<AmenityModel>>(response, (responseData) {
      final List<dynamic> strMap = responseData.data;
      return strMap.map((v) => AmenityModel.fromJson(v)).toList();
    });
  }

  @override
  Future<DirectionModel> guideDirection(
      LocationData myLocation, double lat, double long) async {
    final myLo = '${myLocation.latitude},${myLocation.longitude}';
    final desLo = '$lat,$long';

    final response = await dio.get(endPointDirectionAPI, queryParameters: {
      'origin': myLo,
      'destination': desLo,
      'mode': 'transit',
      'key': env.ggKey,
    }).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    if (response.statusCode == CODE_SUCCESS) {
      return DirectionModel.fromJson(response.data);
    } else {
      throw RemoteDataFailure(
          errorCode: response.statusCode.toString(),
          errorMessage: response.statusMessage);
    }
  }
}
