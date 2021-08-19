import 'dart:convert';

import '../data/model/notification_setting_model.dart';
import '../data/model/personalization_item.dart';
import '../data/repository/home_repository.dart';
import '../data/source/api_end_point.dart';
import 'app_const.dart';

class DataFormUtil {
  /// Create Link Account Form for Submit Data API Link Account
  ///
  /// [email]: user's email, [String] data type
  /// [password]: password field to verify and link two account, [String] data type
  /// [social_id]: user's socialId, [String] data type
  /// [device_id]: user's device id, [String] data type
  /// [type]: type field to identify user 'guest' or 'member', [String] data type
  ///
  static Map linkAccountFormData(
      {String socialId,
      String email,
      String deviceId,
      String password,
      String device_token}) {
    final data = {
      'email': email,
      'social_id': socialId,
      'password': password,
      'device_id': deviceId,
      'device_token': device_token,
      'type': 'user'
    };
    return data;
  }

  /// Create Login Form for Submit Data API Login Social
  ///
  /// [email]: user's email, [String] data type
  /// [social_id]: user's socialId, [String] data type
  /// [device_id]: user's device id, [String] data type
  /// [type]: type field to identify user 'guest' or 'member', [String] data type
  ///
  static Map loginSocialFormData(
      {String email, String socialId, String deviceId, String device_token}) {
    final data = {
      'email': email,
      'social_id': socialId,
      'device_id': deviceId,
      'device_token': device_token,
      'type': 'user'
    };
    return data;
  }

  /// Create Login Form for Submit Data  API Login
  ///
  /// [email]: user's email, [String] data type
  /// [password]: user's password, [String] data type
  /// [device_id]: user's device id, [String] data type
  /// [type]: type field to identify user 'guest' or 'member', [String] data type
  ///
  static Map loginFormData(
      {String email, String password, String deviceId, String device_token}) {
    final data = {
      'email': email,
      'password': password,
      'device_id': deviceId,
      'device_token': device_token,
      'type': 'user'
    };
    return data;
  }

  ///
  /// Create Login as Guest Form for Submit Data API Login
  ///   [device_id]: user's device id, [String] data type
  ///   [type]: type field to identify user 'guest' or 'member', [String] data type
  ///
  static Map loginAsGuestFormData({String deviceId, String device_token}) {
    final data = {
      'device_id': deviceId,
      'type': 'guest',
      'device_token': device_token,
    };
    return data;
  }

  ///
  /// Create verify Form for Submit Data API Verify Code
  ///   [code]: this code will receive from email, [String] data type
  ///
  static Map verifyFormData({
    String code,
  }) {
    final data = {'verification_code': code};
    return data;
  }

  ///
  /// Create search keyword Form for Submit Data API Search
  ///   [keyword]: this keyword will search area, [String] data type
  ///
  static Map searchKeywordFormData({
    String keyword,
  }) {
    final data = {'keyword': keyword};
    return data;
  }

  ///
  /// Create email Form for Submit Data API Forgot password
  ///   [email]: user's email, [String] data type
  ///
  static Map emailForgotPasswordFormData({
    String email,
  }) {
    final data = {'email': email};
    return data;
  }

  ///
  ///Create verify Code Form for Submit Data API Verify Code Register
  ///   [code]: this code will receive from email, [String] data type
  ///
  static Map activateAccountFormData({String code, String tokenCode}) {
    final data = {'code': code, 'token_code': tokenCode};
    return data;
  }

  ///
  /// Create password Form for Submit Data API Create password
  ///   [password]: password that user entered, [String] data type
  ///   [confirmPassword]: confirmPassword that user entered, it must same password. [String] data type
  ///   [token_code]: token code use for verify, [String] data type
  ///
  static Map createNewPasswordFormData({
    String password,
    String confirmPassword,
    String token,
  }) {
    final data = {
      'new_password': password,
      'confirm_password': confirmPassword,
      'token_code': token
    };
    return data;
  }

  ///
  /// Create verify Code Form for Submit Data API Verify Code Forgot Password
  ///   [code]: this code will receive from email, [String] data type
  ///   [tokenCode]: token code use for verify, [String] data type
  ///
  static Map verifyCodeForgotPasswordFormData({
    String code,
    String tokenCode,
  }) {
    final data = {'code': code, 'token_code': tokenCode};
    return data;
  }

  ///
  ///
  ///
  ///
  ///
  static Map genParamsCommunityPost({
    int page,
    int limit,
    String category,
    List<Map> filterAdv,
    String amenityId,
    String filterFacility,
    String experId,
  }) {
    final data = (amenityId?.isNotEmpty ?? false)
        ? {
            'page': page,
            'limit': limit,
            'filter': filterAdv.isNotEmpty ? json.encode(filterAdv) : '',
            'filter[field_place][value]': amenityId,
            'category': category,
            PARAM_FILTER_FACILITY: filterFacility,
            'experience_id': experId,
            'sort[created]': 'desc',
            't': DateTime.now().toIso8601String()
          }
        : {
            'page': page,
            'limit': limit,
            'filter': filterAdv.isNotEmpty ? json.encode(filterAdv) : '',
            'category': category,
            PARAM_FILTER_FACILITY: filterFacility,
            'experience_id': experId,
            'sort[created]': 'desc',
            't': DateTime.now().toIso8601String()
          };
    return data;
  }

  ///
  /// Create personalization Form for Submit Data API Personalize
  ///   [listItemIds]: these are list interested items that user selected, [List]<PersonalizationItem> data type
  ///
  static Map personalizationFormData(
      {List<PersonalizationItem> listItemIds, List<Items> child}) {
    final data = {};
    data['personal_list'] = {
      'amenity_type': listItemIds.map((e) => {'id': e.id}).toList(),
      'amenity_tag': child.map((e) => {'id': e.id}).toList()
    };

    return data;
  }

  ///
  /// Update notification setting Form for Submit Data API Notification Setting
  ///   [listNotificationItemIds]: these are list update items that user has changed, [List]<NotificationSettingModel> data type
  ///
  static List<Map> notificationSettingFormData({
    List<NotificationSettingModel> listItemIds,
  }) {
    var data = <Map>[];
    // ignore: join_return_with_assignment
    data = listItemIds.map((e) => {'id': e.id, 'status': e.status}).toList();
    return data;
  }

  ///
  /// Create register Form for Submit Data API Register
  ///   [fullName]: user's name, [String] data type
  ///   [email]: user's email, [String] data type
  ///   [dob]: user's bird-day, [String] data type
  ///   [maritalId]: user's marital status, [String] data type
  ///   [type]: type [email|facebook|google|apple] field to identify register method (social or manual), [String] data type
  ///   [pwd]: user's password, [String] data type
  ///   [socialId]: this field will provide when user register by Social method, [String] data type
  ///
  static Map registerFormData(
      {String fullName,
      String email,
      String dob,
      String maritalId,
      String pwd,
      String type,
      String socialId}) {
    final data = {
      'full_name': fullName,
      'email': email,
      'day_of_birth': dob,
      'marital_status': maritalId,
      'password': pwd,
      'type': type,
      'social_id': email
    };
    return data;
  }

  ///
  /// Create add comment Form for Submit Data API Register
  ///   [postId]: community id, [String] data type
  ///   [comment]: user comment, [String] data type
  ///
  static Map addCommentFormData({String postId, String comment}) {
    final data = {
      'post_id': postId,
      'comment': comment,
    };
    return data;
  }

  ///
  /// Create like comment Form for Submit Data API Register
  ///   [postId]: community id, [String] data type
  ///   [commentId]: comment id, [String] data type
  ///
  static Map likeCommentFormData({String id, bool currentLike}) {
    final data = {
      'id': id,
      'entity_type': 'comment',
      'action': currentLike ? 'add' : 'remove',
    };
    return data;
  }

  ///
  /// Create favorite Form to Add post/place/event for Favorite list
  ///   [id]: post/place/event id, [String] data type
  ///   [type]:  category, [String] data type
  ///
  static Map addFavorite(
      {String id, bool isFavorite, FavoriteType favoriteType}) {
    var entityType = '';
    switch (favoriteType) {
      case FavoriteType.COMMUNITY_POST:
        entityType = 'community_post';
        break;
      case FavoriteType.EVENT:
      case FavoriteType.AMENITY:
        entityType = 'node';
        break;
    }
    final data = {
      'id': id,
      'action': isFavorite ? 'add' : 'remove',
      'entity_type': entityType,
    };
    return data;
  }

  ///
  /// Create like comment Form for Submit Data API Register
  ///   [postId]: community id, [String] data type
  ///   [commentId]: comment id, [String] data type
  ///  [comment]: user comment, [String] data type
  ///
  static Map replyCommentFormData(
      {String postId, String commentId, String comment}) {
    final data = {
      'post_id': postId,
      'comment_id': commentId,
      'comment': comment,
    };
    return data;
  }

  ///
  /// Create remove and turn off Form for Submit Data API Register
  ///   [postId]: community id, [String] data type
  ///
  static Map postFormData({String postId, String action, String type}) {
    final data = {
      'post_id': postId,
      'action': action,
      'entity_type': type,
    };
    return data;
  }

  ///
  /// Create community post photo Form for Submit Data API Register
  ///   [image]: list image, [list] data type
  ///   [caption]: caption, [string] data type
  ///   [asset_id]: asset id, [string] data type
  ///
  static Map postPhotoFormData(
      {String caption, String assetId, String experience, List<int> image}) {
    final data = {
      'image': image,
      'caption': caption,
      'place': assetId,
      'experience': experience,
    };
    return data;
  }

  ///
  /// Create community post photo Form for Submit Data API Register
  ///   [image]: list image, [list] data type
  ///   [caption]: caption, [string] data type
  ///   [rate]: rate, [double] data type
  ///   [asset_id]: asset id, [string] data type
  ///
  static Map postReviewFormData({
    String caption,
    String assetId,
    String experience,
    double rate,
    List<int> image,
  }) {
    final data = {
      'image': image,
      'caption': caption,
      'rating': rate,
      'place': assetId,
      'experience': experience,
    };
    return data;
  }

  static Map paramSearchNearBy({
    double lat,
    double long,
    String content,
    double distance = DEFAULT_DISTANCE,
    int experience_id = 0,
  }) {
    final data = {
      'lat': lat,
      'lon': long,
      'content': content,
      'distance': distance,
      'experience_id': (experience_id == 0) ? '' : experience_id,
    };
    return data;
  }
}
