import 'package:marvista/utils/log_utils.dart';

import '../../utils/date_util.dart';

import 'app_config.dart';
import 'image_info.dart';

class UserInfo {
  String _fullName;
  String _email;
  ImageInfoData _photo;
  String _phoneNumber;
  String dialCode;
  String _dayOfBirth;
  dynamic _maritalStatus;
  String _typeRegistration;
  int _hasFillPersonalization;
  int _hasPassword;
  dynamic _isActive;
  String _role;

  bool isUser() {
    return _role != null && _role.toLowerCase() != 'guest';
  }

  bool isActivated() {
    return _isActive != null && _isActive.toString() == '1';
  }

  bool isPassword() {
    return _hasPassword != null && _hasPassword.toString() == '1';
  }

  MaritalStatus marital(List<MaritalStatus> maritals) {
    if (maritals?.isNotEmpty ?? false) {
      for (var i = 0; i < maritals.length; i++) {
        if (maritals[i].id.toString() == (maritalStatus?.toString() ?? '')) {
          return maritals[i];
        }
      }
    }
    return null;
  }

  DateTime dobDateTime() {
    try {
      return DateUtil.convertStringToDate(dayOfBirth,
          formatData: DateUtil.DATE_FORMAT_DDMMYYYY);
    } catch (ex) {
      return DateTime.now();
    }
  }

  dynamic get isActive => _isActive;
  set isActive(dynamic isActive) => _isActive = isActive;
  ImageInfoData get photo => _photo;
  set photo(ImageInfoData photo) => _photo = photo;
  String get phoneNumber => _phoneNumber;
  set phoneNumber(String phoneNumber) => _phoneNumber = phoneNumber;
  String get fullName => _fullName;
  set fullName(String fullName) => _fullName = fullName;
  String get email => _email;
  set email(String email) => _email = email;
  String get dayOfBirth => _dayOfBirth;
  set dayOfBirth(String dayOfBirth) => _dayOfBirth = dayOfBirth;
  dynamic get maritalStatus => _maritalStatus;
  set maritalStatus(dynamic maritalStatus) => _maritalStatus = maritalStatus;
  String get typeRegistration => _typeRegistration;
  set typeRegistration(String typeRegistration) =>
      _typeRegistration = typeRegistration;
  int get hasFillPersonalization => _hasFillPersonalization;
  set hasFillPersonalization(int hasFillPersonalization) =>
      _hasFillPersonalization = hasFillPersonalization;
  String get role => _role;
  set role(String role) => _role = role;
  int get hasPassword => _hasPassword;
  set hasPassword(int hasPassword) =>
      _hasPassword = hasPassword;

  UserInfo.fromJson(Map<String, dynamic> json) {
    try{
      _fullName = json['full_name'];
      if (json['photo'] != null && json['photo'] is Map) {
        _photo = ImageInfoData.fromJson(json['photo']);
      }
      _phoneNumber = json['phone_number'];
      _isActive = json['is_active'];
      _email = json['email'];
      _dayOfBirth = json['day_of_birth'];
      _maritalStatus = json['marital_status'];
      _typeRegistration = json['type_registration'];
      _hasFillPersonalization = json['has_fill_personalization'];
      _hasPassword = json['has_password'];
      _role = json['role'];
      if (json['dial_code'] != null) {
        dialCode = json['dial_code'];
      }
    }catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }


  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['full_name'] = _fullName;
    if (dialCode != null) {
      data['dial_code'] = dialCode;
    }
    data['phone_number'] = _phoneNumber;
    if (_photo != null) {
      data['photo'] = _photo.toJson();
    }
    data['is_active'] = _isActive;
    data['email'] = _email;
    data['day_of_birth'] = _dayOfBirth;
    data['marital_status'] = _maritalStatus;
    data['type_registration'] = _typeRegistration;
    data['has_fill_personalization'] = _hasFillPersonalization;
    data['has_password'] = _hasPassword;
    data['role'] = _role;
    return data;
  }
}
