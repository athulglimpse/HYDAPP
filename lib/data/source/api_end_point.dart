import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import '../../common/di/injection/injector.dart';
import '../../utils/environment_info.dart';

//Current environment
final EnvironmentInfo env = sl<EnvironmentInfo>();

//Default Language code
String langCode = 'en';

String get baseEndPoint => '${env.host}/json-api/${env.version}/$langCode/';

/// Authentication End Point
String get endPointLogin => '${baseEndPoint}login';
String get endPointLinkAccount => '${baseEndPoint}link-account';
String get endPointLoginSocial => '${baseEndPoint}login-social';
String get endPointGetProfile => '${baseEndPoint}profile';
String get endPointPostRegister => '${baseEndPoint}register';
String get endPointVerifyCodeForgotPassword =>
    '${baseEndPoint}verify-code/forgot';
String get endPointCreateNewPassword => '${baseEndPoint}new-password';
String get endPointSubmitEmailForgotPassword =>
    '${baseEndPoint}forgot-password';
String get endPointPostPersonalization => '${baseEndPoint}personalization';
String get endPointActivateAccount => '${baseEndPoint}verify-code/active';
String get endPointResentVerifyCode => '${baseEndPoint}resend-verify-code';
String get endPointCheckOldPassword => '${baseEndPoint}check-old-password';
String get endPointCheckNewPassword => '${baseEndPoint}new-password';
String get endPointUpdateDeviceToken =>
    '${baseEndPoint}user/update-device-token';
String get endPointCheckUpdateProfile => '${baseEndPoint}user/update-profile';

/// CONFIG End Point
String get endPointGetConfig => '${baseEndPoint}get-config';
String get endPointGetHelp => '${baseEndPoint}taxonomy/help-topic';
String get endPointGetReportIssue => '${baseEndPoint}taxonomy/issue-type';
String get endPointGetStaticContent => '${baseEndPoint}get-static-content';
String get endPointGetPersonalize => '${baseEndPoint}get-personalization';

String get endPointHelp => '${baseEndPoint}help';
String get endPointReportIssue => '${baseEndPoint}report-issue';

///Setting End Point
String get endPointNotificationSetting => '${baseEndPoint}notification-setting';

String get endPointChangePhotoUser => '${baseEndPoint}user/upload-file';
String get endPointReportPhoto => '${baseEndPoint}report-issue/upload-file';

///Notification End Point
String get endPointNotificationHistory => '${baseEndPoint}notifications';
String get endPointDeleteNotification => '${baseEndPoint}notification/%1\$';

///Search and Filter End Point
String get endPointSearch => '${baseEndPoint}search';
String get endPointFilter => '${baseEndPoint}filter';

/// Post End Point
String get endPointRemovePost => '${baseEndPoint}flag-remove';
String get endPointTurnOffPost => '${baseEndPoint}flag-turn-off';
String get endPointLikeComments => '${baseEndPoint}like';
String get endPointReplyComments => '${baseEndPoint}comment/reply';

String get endPointGetComments => '${baseEndPoint}comments?'
    'filter[entity_type][value]=community_post'
    '&filter[pid][value]='
    '&sort[created]=desc'
    '&filter[pid][operator]=IS NULL'
    '&filter[entity_id][value]=%1\$'
    '&page=%2\$&limit=50&t=%3\$';

String get endPointGetReplies => '${baseEndPoint}comments?'
    'filter[entity_type][value]=community_post'
    '&sort[created]=desc'
    '&filter[entity_id][value]=%1\$'
    '&filter[pid][value]=%2\$'
    '&page=%3\$&limit=50&t=%4\$';

String get endPointAddComments => '${baseEndPoint}comment';

String get endPointAddFavorite => '${baseEndPoint}favourite';

String get endPointGetExperiences => '${baseEndPoint}get-experiences';
String get endPointGetWeekendActivties => '${baseEndPoint}weekend-activities';
String get endPointGetCommunity => '${baseEndPoint}community';
String get endPointGetAmenities => '${baseEndPoint}get-places';
String get endPointAmenityAlsoLike =>
    '${baseEndPoint}amenities-also-like?id=%1\$';
String get endPointGetAssetDetail => '${baseEndPoint}amenities-details/%1\$';
String get endPointGetSearchAsset => '${baseEndPoint}assets';
String get endPointGetEvents => '${baseEndPoint}get-events';
String get endPointGetEventsAlsoLike => '${baseEndPoint}get-event-also-like';
String get endPointGetEventsDetail => '${baseEndPoint}get-event-detail';
String get endPointGetHistory => '${baseEndPoint}get-history';
String get endPointGetFeaturedPlaces => '${baseEndPoint}get-featured-places';
String get endPointSearchNearBy => '${baseEndPoint}search/near-by';

String get endPointSearchGroupByAsset => '${baseEndPoint}search/group-by';
String get endPointSearchRecentAsset => '${baseEndPoint}search-recent';

///google api
const String endPointDistanceMatrixBaseLocation =
    'https://maps.googleapis.com/maps/api/distancematrix/json';

///google api
const String endPointDirectionAPI =
    'https://maps.googleapis.com/maps/api/directions/json';

String get endPointGetCommunityDetail => '${baseEndPoint}community/%1\$?t=%2\$';
const String endPointGetAmenityDetail =
    'weekend-activities-detail?id={id}&t={t}';
String get endPointGetWeekendActivitiesAlsoLike =>
    '${baseEndPoint}weekend-activities-also-like';
String get endPointGetEventsCategories => '${baseEndPoint}get-event-categories';

String get endPointGetSaveItem => '${baseEndPoint}saved-items';

String get endPointPostDeActiveAccount => '${baseEndPoint}user/deactive';

String get endPointUploadImage => '${baseEndPoint}upload-image';
String get endPointPostCommunityPhoto => '${baseEndPoint}community/photo';
String get endPointPostCommunityReview => '${baseEndPoint}community/review';
String get endPointGetMyCommunity => '${baseEndPoint}user/community';

const PARAM_ID = 'id';
const PARAM_NAME = 'name';
const PARAM_FILTER_FACILITY = 'facilities';
const PARAM_START_DATE = 'start_date';
const PARAM_EXPERIENCE_ID = 'experience_id';
const PARAM_END_DATE = 'end_date';
const PARAM_CATEGORY = 'category';
const PARAM_TYPE = 'type';
const PARAM_REGISTRATION_NUMBER = 'registration_number';
const PARAM_COUNTRY_CODE = 'country_code';
const PARAM_SEARCH_NAME = 'search_name';
const PARAM_ETA_FROM = 'eta_from';
const PARAM_ETA_TO = 'eta_to';
const PARAM_PRODUCTS = 'products';
const PARAM_AMENITIES_DETAILS = 'amenities_details';

const PARAM_DISTANCE_RANGE = 'distance_range';
const PARAM_EVENT_DETAILS= 'event_details';
const PARAM_MY_POST= 'my_post';
const PARAM_COMMUNITY_POST= 'community_post';
const PARAM_COMMENT= 'comment';
const PARAM_AMENITY= 'amenity';
const PARAM_EN= 'EN';
const PARAM_AR= 'AR';

const ENTITY_TYPE_NODE = 'node';
const ENTITY_TYPE_POST = 'community_post';

const int CODE_SUCCESS = 200;
const int CODE_CREATE = 201;
const int CODE_LINK_ACCOUNT = 101;
const int CODE_BAD_REQUEST = 400;
const int CODE_SERVER_ERROR = 500;
const int CODE_UN_AUTH = 401;
const int CODE_CUSTOM_ACTIVATE_ACCOUNT = 100;

const String RESPONSE_CODE_LINK_ACCOUNT = 'linkaccount';

/*
 * Update latest lang in api
 * Locale - current language
 */
Future<void> updateLangEndPoint(Locale locale,
    {bool canInitLocalDate = false}) async {
  langCode = locale.languageCode;
  if (canInitLocalDate) {
    await Jiffy.locale(locale.languageCode);
  }
}

// const String endPointGetPlaces = 'get-places?$PARAM_TYPE={$PARAM_TYPE}'
//     '&$PARAM_FILTER={$PARAM_FILTER}&$PARAM_CATEGORY='
//     '{$PARAM_CATEGORY}&$PARAM_EXPERIENCE_ID={$PARAM_EXPERIENCE_ID}';
