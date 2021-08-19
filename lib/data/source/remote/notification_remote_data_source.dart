import '../../../common/localization/lang.dart';
import '../../../utils/data_form_util.dart';
import '../../model/notification_history_model.dart';
import '../../model/notification_setting_model.dart';
import '../api_end_point.dart';
import '../failure.dart';
import '../success.dart';
import 'remote_base.dart';

abstract class NotificationRemoteDataSource {
  ///GET API
  Future<List<NotificationSettingModel>> fetchListNotificationItems();

  Future<List<NotificationHistoryModel>> fetchListNotificationHistoryItems(
      {int pageIndex, int limit});

  ///POST API
  Future<Success> submitListNotificationItems(
      List<NotificationSettingModel> listItems);

  Future<Success> removeNotificationFromFeed(String id);

  Future<Success> turnOffNotificationFromOwner(
      String postId, String action, String type);
}

class NotificationRemoteDataSourceImpl extends RemoteBaseImpl
    implements NotificationRemoteDataSource {
  NotificationRemoteDataSourceImpl();

  @override
  Future<List<NotificationSettingModel>> fetchListNotificationItems() async {
    setPrivateToken();
    final response =
        await dio.get(endPointNotificationSetting).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<List<NotificationSettingModel>>(response,
        (responseData) {
      final List<dynamic> strMap = responseData.data;
      return strMap
              ?.map((v) => NotificationSettingModel.fromJson(v))
              ?.toList() ??
          [];
    });
  }

  @override
  Future<List<NotificationHistoryModel>> fetchListNotificationHistoryItems(
      {int pageIndex, int limit}) async {
    setPrivateToken();
    final response =
        await dio.get(endPointNotificationHistory, queryParameters: {
      't': DateTime.now().toIso8601String(),
      'limit': limit,
      'page': pageIndex,
    }).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    return checkStatusCode<List<NotificationHistoryModel>>(response,
        (responseData) {
      final List<dynamic> strMap = responseData.data;
      return strMap
              .where((element) => element != null)
              ?.map((v) => NotificationHistoryModel.fromJson(v))
              ?.toList() ??
          [];
    });
  }

  @override
  Future<Success> submitListNotificationItems(
      List<NotificationSettingModel> listItems) async {
    setPrivateToken();
    final data =
        DataFormUtil.notificationSettingFormData(listItemIds: listItems);
    print(data);
    final response = await dio
        .post(endPointNotificationSetting, data: data)
        .catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<Success>(response, (responseData) {
      return Success();
    });
  }

  @override
  Future<Success> removeNotificationFromFeed(String id) async {
    setPrivateToken();
    final response = await dio
        .delete(endPointDeleteNotification.format([id]))
        .catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    return checkStatusCode<Success>(response, (responseData) {
      return Success();
    });
  }

  @override
  Future<Success> turnOffNotificationFromOwner(
      String postId, String action, String type) async {
    setPrivateToken();
    final data =
        DataFormUtil.postFormData(postId: postId, action: action, type: type);
    final response = await dio
        .post(endPointTurnOffPost, queryParameters: {'debug': 1}, data: data)
        .catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    return checkStatusCode<Success>(response, (responseData) {
      return Success();
    });
  }
}
