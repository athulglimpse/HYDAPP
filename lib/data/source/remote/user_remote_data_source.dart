import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../utils/data_form_util.dart';
import '../../model/forgot_password_info.dart';
import '../../model/personalization_item.dart';
import '../../model/register_info.dart';
import '../../model/user_info.dart';
import '../api_end_point.dart';
import '../failure.dart';
import '../success.dart';
import 'remote_base.dart';

abstract class UserRemoteDataSource with RemoteBase {
  ///Login API
  Future<String> login(
      String email, String password, String deviceId, String deviceToken);

  Future<String> loginSocial(String socialId, String email, String deviceId,
      String socialMethod, String deviceToken);
  Future<String> linkAccount(String socialId, String email, String deviceId,
      String socialMethod, String password, String deviceToken);

  Future<String> loginAsGuest(String deviceId, String deviceToken);

  ///Get Profile API
  Future<UserInfo> getProfile();

  ///Update Profile
  Future<Success> updateProfile(
      String phoneNumber, String dob, String marital, String dialCode);

  ///upload photo
  Future<Success> uploadPhoto(String path);

  Future<Success> updateDeviceToken(String deviceId, String deviceToken);

  ///Register API
  Future<RegisterInfo> register(
      String firstName,
      String lastName,
      String email,
      String dob,
      String maritalId,
      String pwd,
      String type,
      String dialCode,
      String phone,
      String socialId,
      int hasSocialEmail);

  Future<Success> requestVerify();

  Future<Success> doVerify(String code);

  ///Personalization API
  Future<Success> submitPersonalization(
      List<PersonalizationItem> listItemIds, List<Items> child);

  ///forgot password API
  Future<ForgotPasswordInfo> doVerifyCodeForgotPassword(
      String code, String tokenCode);

  Future<ForgotPasswordInfo> submitEmailForgotPassword(String email);

  Future<Success> createNewPassword(
      String password, String confirmPassword, String token);

  ///Change password API
  Future<String> doCheckOldPassword(String oldPass);

  Future<Success> changePassword(String tokenCode, String newPass);

  ///Update lasted token API Header
  void updateUserToken(String token);

  Future<String> doActivateAccount(String code, String tokenCode);

  Future<String> resendVerifyCode(String email);
}

class UserRemoteDataSourceImpl extends RemoteBaseImpl
    implements UserRemoteDataSource {
  @override
  Future<String> loginSocial(String socialId, String email, String deviceId,
      String socialMethod, String deviceToken) async {
    setPublicToken();
    final response = await dio
        .post(endPointLoginSocial,
            data: DataFormUtil.loginSocialFormData(
                email: email,
                socialId: socialId,
                deviceId: deviceId,
                device_token: deviceToken))
        .catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<String>(response, (responseData) {
      final Map data = responseData.data;
      updateUsrToken(data['access_token']);
      return data['access_token'];
    });
  }

  @override
  Future<String> linkAccount(String socialId, String email, String deviceId,
      String socialMethod, String password, String deviceToken) async {
    setPublicToken();
    final response = await dio
        .post(endPointLinkAccount,
            data: DataFormUtil.linkAccountFormData(
                email: email,
                socialId: socialId,
                deviceId: deviceId,
                password: password,
                device_token: deviceToken))
        .catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<String>(response, (responseData) {
      final Map data = responseData.data;
      updateUsrToken(data['access_token']);
      return data['access_token'];
    });
  }

  @override
  Future<String> login(String email, String password, String deviceId,
      String deviceToken) async {
    setPublicToken();
    final response = await dio
        .post(endPointLogin,
            data: DataFormUtil.loginFormData(
                email: email,
                password: password,
                deviceId: deviceId,
                device_token: deviceToken))
        .catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<String>(response, (responseData) {
      final Map data = responseData.data;
      updateUsrToken(data['access_token']);
      return data['access_token'];
    });
  }

  @override
  Future<String> loginAsGuest(String deviceId, String deviceToken) async {
    setPublicToken();
    final response = await dio
        .post(endPointLogin,
            data: DataFormUtil.loginAsGuestFormData(
                deviceId: deviceId, device_token: deviceToken))
        .catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<String>(response, (responseData) {
      final Map data = responseData.data;
      updateUsrToken(data['access_token']);
      return data['access_token'];
    });
  }

  @override
  Future<UserInfo> getProfile() async {
    setPrivateToken();
    final response = await dio.get(endPointGetProfile).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<UserInfo>(response, (responseData) {
      final Map data = responseData.data;
      return UserInfo.fromJson(data);
    });
  }

  @override
  Future<RegisterInfo> register(
      String firstName,
      String lastName,
      String email,
      String dob,
      String maritalId,
      String pwd,
      String type,
      String dialCode,
      String phone,
      String socialId,
      int hasSocialEmail) async {
    setPublicToken();
    {
      final response = await dio.post(endPointPostRegister, data: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'day_of_birth': dob,
        'marital_status': maritalId,
        'password': pwd,
        'type': type,
        'dial_code': dialCode,
        'phone_number': phone,
        'social_id': socialId,
        'hasSocialEmail': hasSocialEmail
      }).catchError((error) {
        throw RemoteDataFailure(
            errorCode: error.toString(), errorMessage: error.toString());
      });

      final responseData = toResponseData(response.data);
      if (responseData.statusCode == CODE_SUCCESS) {
        if (responseData.data is Map) {
          final Map data = responseData.data;
          if (data.isNotEmpty && data.containsKey('code')) {
            // UIUtil.showToast(data['code']);
            return RegisterInfo.fromJson(data);
          }
          if (data.isNotEmpty && data.containsKey('access_token')) {
            updateUserToken(data['access_token']);
            return RegisterInfo.fromJson(data);
          }
          return RegisterInfo.fromJson(responseData.data);
        } else {
          return RegisterInfo.fromJson(null);
        }
      } else if (responseData.statusCode == CODE_CUSTOM_ACTIVATE_ACCOUNT) {
        final Map data = responseData.data;
        return RegisterInfo.fromJson(data);
      } else {
        throw RemoteDataFailure(
            errorCode: responseData.statusCode.toString(),
            errorMessage: responseData.message);
      }
    }
  }

  @override
  Future<Success> requestVerify() async {
    final response = await dio.post('').catchError((error) {
      print('Catched errro $error');
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<Success>(response, (responseData) {
      return Success();
    });
  }

  @override
  Future<Success> doVerify(String code) async {
    final data = DataFormUtil.verifyFormData(code: code);
    final response =
        await dio.post('', data: json.encode(data)).catchError((error) {
      print('Catched errro $error');
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<Success>(response, (responseData) {
      return Success();
    });
  }

  @override
  void updateUserToken(String token) {
    updateUsrToken(token);
  }

  @override
  Future<Success> submitPersonalization(
      List<PersonalizationItem> listItemIds, List<Items> child) async {
    setPrivateToken();
    final data = DataFormUtil.personalizationFormData(
        listItemIds: listItemIds, child: child);
    final response = await dio
        .post(endPointPostPersonalization, data: data)
        .catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<Success>(response, (responseData) {
      return Success();
    });
  }

  @override
  Future<ForgotPasswordInfo> doVerifyCodeForgotPassword(
      String code, String tokenCode) async {
    final data = DataFormUtil.verifyCodeForgotPasswordFormData(
        code: code, tokenCode: tokenCode);
    final response = await dio
        .post(endPointVerifyCodeForgotPassword, data: data)
        .catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<ForgotPasswordInfo>(response, (responseData) {
      final data = responseData.data;
      return ForgotPasswordInfo.fromJson(data);
    });
  }

  @override
  Future<Success> createNewPassword(
      String password, String confirmPassword, String token) async {
    final data = DataFormUtil.createNewPasswordFormData(
        password: password, confirmPassword: confirmPassword, token: token);
    final response = await dio
        .post(endPointCreateNewPassword, data: json.encode(data))
        .catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<Success>(response, (responseData) {
      return Success();
    });
  }

  @override
  Future<ForgotPasswordInfo> submitEmailForgotPassword(String email) async {
    final data = DataFormUtil.emailForgotPasswordFormData(email: email);
    final response = await dio
        .post(endPointSubmitEmailForgotPassword, data: json.encode(data))
        .catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<ForgotPasswordInfo>(response, (responseData) {
      return ForgotPasswordInfo.fromJson(responseData.data);
    });
  }

  @override
  Future<String> doActivateAccount(String code, String tokenCode) async {
    final data =
        DataFormUtil.activateAccountFormData(code: code, tokenCode: tokenCode);
    final response = await dio
        .post(endPointActivateAccount, data: json.encode(data))
        .catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<String>(response, (responseData) {
      updateUsrToken(responseData.data['access_token']);
      return responseData.data['access_token'];
    });
  }

  @override
  Future<String> resendVerifyCode(String email) async {
    setPublicToken();
    final data = DataFormUtil.emailForgotPasswordFormData(email: email);
    final response = await dio
        .post(endPointResentVerifyCode, data: json.encode(data))
        .catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<String>(response, (responseData) {
      return responseData.data['token_code'];
    });
  }

  @override
  Future<Success> changePassword(String tokenCode, String newPass) async {
    setPrivateToken();
    final response = await dio.post(endPointCheckNewPassword, data: {
      'new_password': newPass,
      'confirm_password': newPass,
      'token_code': tokenCode
    }).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<Success>(response, (responseData) {
      return Success();
    });
  }

  @override
  Future<String> doCheckOldPassword(String oldPass) async {
    setPrivateToken();
    final response = await dio
        .post(endPointCheckOldPassword, data: {'old_password': oldPass});
    return checkStatusCode<String>(response, (responseData) {
      return responseData.data['token'];
    });
  }

  @override
  Future<Success> updateProfile(
      String phoneNumber, String dob, String marital, String dialCode) async {
    setPrivateToken();
    final response = await dio.post(endPointCheckUpdateProfile, data: {
      'phone_number': phoneNumber,
      'day_of_birth': dob,
      'marital_status': marital,
      'dial_code': dialCode,
    });
    return checkStatusCode<Success>(response, (responseData) {
      return Success();
    });
  }

  @override
  Future<Success> uploadPhoto(String path) async {
    setPrivateToken();
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(path,
          filename: File(path)?.path?.split('/')?.last),
      'field_name': 'user_picture',
    });
    final response = await dio.post(
      endPointChangePhotoUser,
      data: formData,
    );
    return checkStatusCode<Success>(response, (responseData) {
      return Success();
    });
  }

  @override
  Future<Success> updateDeviceToken(String deviceId, String deviceToken) async {
    setPrivateToken();
    final response = await dio.post(endPointUpdateDeviceToken, data: {
      'device_id': deviceId,
      'device_token': deviceToken,
    });
    return checkStatusCode<Success>(response, (responseData) {
      return Success();
    });
  }
}
