import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../model/forgot_password_info.dart';
import '../model/personalization_item.dart';
import '../model/register_info.dart';
import '../model/user_info.dart';
import '../source/failure.dart';
import '../source/local/user_local_datasource.dart';
import '../source/remote/user_remote_data_source.dart';
import '../source/success.dart';
import 'repository.dart';

abstract class UserRepository {
  /// POST API
  /// handle for login
  Future<Either<Failure, UserInfo>> login(
      String email, String pwd, String deviceId, String deviceToken);

  Future<Either<Failure, UserInfo>> loginAsGuest(
      String deviceId, String deviceToken);

  Future<Either<Failure, UserInfo>> linkAccount(
      String socialId,
      String email,
      String deviceId,
      String socialMethod,
      String password,
      String deviceToken);

  Future<Either<Failure, UserInfo>> loginSocial(String socialId, String email,
      String deviceId, String socialMethod, String deviceToken);

  ///Update Profile
  Future<Either<Failure, Success>> updateProfile(
      String phoneNumber, String dob, String marital, String dialCode);

  ///upload Photo
  Future<Either<Failure, Success>> uploadPhoto(String path);

  Future<Either<Failure, Success>> updateDeviceToken(
      String deviceId, String deviceToken);

  /// POST API
  /// Handle for activate account
  Future<Either<Failure, Success>> doVerify(String code);

  /// POST API
  ///
  /// handle for Register
  Future<Either<Failure, RegisterInfo>> register(
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

  Future<Either<Failure, Success>> requestVerify();

  Future<Either<Failure, UserInfo>> getMe({String accessToken});

  Future<Either<Failure, Success>> logout();

  /// POST API
  ///
  /// Submit data for personalization
  Future<Either<Failure, Success>> submitPersonalization(
      List<PersonalizationItem> listItemIds, List<Items> child);

  /// POST API
  ///
  /// handle for forgot password
  Future<Either<Failure, ForgotPasswordInfo>> doVerifyCodeForgotPassword(
      String code, String tokenCode);

  Future<Either<Failure, ForgotPasswordInfo>> submitEmailForgotPassword(
      String email);

  Future<Either<Failure, Success>> createNewPassword(
      String password, String confirmPassword, String token);

  /// POST API
  ///
  /// handle for change password
  Future<Either<Failure, String>> doCheckOldPassword(String oldPass);

  Future<Either<Failure, Success>> changePassword(
      String tokenCode, String newPass);

  /// POST API
  ///
  /// handle activate account
  Future<Either<Failure, String>> doActivateAccount(
      String code, String tokenCode);

  Future<Either<Failure, String>> resendVerifyCode(String email);

  /// Local API
  void saveCurrentUser(UserInfo user);

  UserInfo getCurrentUser();
}

class UserRepositoryImpl extends Repository implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSrc;

  UserRepositoryImpl(
      {@required this.remoteDataSource, @required this.localDataSrc});

  @override
  Future<Either<Failure, UserInfo>> getMe({String accessToken}) async {
    return catchData<UserInfo>(() async {
      if (accessToken != null) {
        localDataSrc.saveAccessToken(accessToken);
      }
      final data = await remoteDataSource.getProfile();
      localDataSrc.saveCurrentUser(data);
      return data;
    });
  }

  @override
  Future<Either<Failure, UserInfo>> linkAccount(String socialId, String email,
      String deviceId, String type, String password, String deviceToken) async {
    return catchData<UserInfo>(() async {
      final data = await remoteDataSource.linkAccount(
          socialId, email, deviceId, type, password, deviceToken);
      //Store accessToken to cache
      localDataSrc.saveAccessToken(data);
      final userInfo = await remoteDataSource.getProfile();
      localDataSrc.saveCurrentUser(userInfo);
      return userInfo;
    });
  }

  @override
  Future<Either<Failure, UserInfo>> loginSocial(String socialId, String email,
      String deviceId, String type, String deviceToken) async {
    return catchData<UserInfo>(() async {
      final data = await remoteDataSource.loginSocial(
          socialId, email, deviceId, type, deviceToken);
      //Store accessToken to cache
      localDataSrc.saveAccessToken(data);
      final userInfo = await remoteDataSource.getProfile();
      localDataSrc.saveCurrentUser(userInfo);
      return userInfo;
    });
  }

  @override
  Future<Either<Failure, UserInfo>> login(
      String email, String pwd, String deviceId, String deviceToken) async {
    return catchData<UserInfo>(() async {
      final data =
          await remoteDataSource.login(email, pwd, deviceId, deviceToken);
      localDataSrc.saveAccessToken(data);
      final userInfo = await remoteDataSource.getProfile();
      localDataSrc.saveCurrentUser(userInfo);
      return userInfo;
    });
  }

  @override
  Future<Either<Failure, Success>> submitPersonalization(
      List<PersonalizationItem> listItemIds, List<Items> child) async {
    return catchData<Success>(() async {
      final data = await remoteDataSource.submitPersonalization(listItemIds,   child);
      return data;
    });
  }

  @override
  Future<Either<Failure, UserInfo>> loginAsGuest(
      String deviceId, String deviceToken) async {
    return catchData<UserInfo>(() async {
      final data = await remoteDataSource.loginAsGuest(deviceId, deviceToken);
      localDataSrc.saveAccessToken(data);
      final userInfo = await remoteDataSource.getProfile();
      localDataSrc.saveCurrentUser(userInfo);
      return userInfo;
    });
  }

  @override
  Future<Either<Failure, RegisterInfo>> register(
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
    return catchData<RegisterInfo>(() async {
      final data = await remoteDataSource.register(firstName, lastName, email,
          dob, maritalId, pwd, type, dialCode, phone, socialId, hasSocialEmail);
      return data;
    });
  }

  @override
  Future<Either<Failure, Success>> requestVerify() async {
    return catchData<Success>(() async {
      final data = await remoteDataSource.requestVerify();
      return data;
    });
  }

  @override
  Future<Either<Failure, Success>> doVerify(String code) async {
    return catchData<Success>(() async {
      final data = await remoteDataSource.doVerify(code);
      return data;
    });
  }

  @override
  void saveCurrentUser(UserInfo user) {
    return localDataSrc.saveCurrentUser(user);
  }

  @override
  UserInfo getCurrentUser() {
    final userInfo = localDataSrc.getCurrentUser();
    remoteDataSource.updateUserToken(localDataSrc.getAccessToken());
    return userInfo;
  }

  @override
  Future<Either<Failure, Success>> logout() async {
    return catchData<Success>(() async {
      final data = await localDataSrc.logout();
      remoteDataSource.updateUserToken('');
      return data;
    });
  }

  @override
  Future<Either<Failure, Success>> createNewPassword(
      String password, String confirmPassword, String token) async {
    return catchData<Success>(() async {
      final data = await remoteDataSource.createNewPassword(
          password, confirmPassword, token);
      return data;
    });
  }

  @override
  Future<Either<Failure, ForgotPasswordInfo>> doVerifyCodeForgotPassword(
      String code, String tokenCode) async {
    return catchData<ForgotPasswordInfo>(() async {
      final data =
          await remoteDataSource.doVerifyCodeForgotPassword(code, tokenCode);
      return data;
    });
  }

  @override
  Future<Either<Failure, ForgotPasswordInfo>> submitEmailForgotPassword(
      String email) async {
    return catchData<ForgotPasswordInfo>(() async {
      final data = await remoteDataSource.submitEmailForgotPassword(email);
      return data;
    });
  }

  @override
  Future<Either<Failure, String>> doActivateAccount(
      String code, String tokenCode) async {
    return catchData<String>(() async {
      final data = await remoteDataSource.doActivateAccount(code, tokenCode);
      localDataSrc.saveAccessToken(data);
      return data;
    });
  }

  @override
  Future<Either<Failure, String>> resendVerifyCode(String email) async {
    return catchData<String>(() async {
      final data = await remoteDataSource.resendVerifyCode(email);
      return data;
    });
  }

  @override
  Future<Either<Failure, Success>> changePassword(
      String tokenCode, String newPass) {
    return catchData<Success>(() async {
      final data = await remoteDataSource.changePassword(tokenCode, newPass);
      return data;
    });
  }

  @override
  Future<Either<Failure, String>> doCheckOldPassword(String oldPass) {
    return catchData<String>(() async {
      final data = await remoteDataSource.doCheckOldPassword(oldPass);
      return data;
    });
  }

  @override
  Future<Either<Failure, Success>> updateProfile(
      String phoneNumber, String dob, String marital, String dialCode) {
    return catchData<Success>(() async {
      final data = await remoteDataSource.updateProfile(
          phoneNumber, dob, marital, dialCode);
      return data;
    });
  }

  @override
  Future<Either<Failure, Success>> uploadPhoto(String path) async {
    return catchData<Success>(() async {
      final data = await remoteDataSource.uploadPhoto(path);
      return data;
    });
  }

  @override
  Future<Either<Failure, Success>> updateDeviceToken(
      String deviceId, String deviceToken) async {
    return catchData<Success>(() async {
      final data =
          await remoteDataSource.updateDeviceToken(deviceId, deviceToken);
      return data;
    });
  }
}
