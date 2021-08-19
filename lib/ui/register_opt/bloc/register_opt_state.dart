import 'package:equatable/equatable.dart';
import 'package:marvista/data/model/app_config.dart';
import 'package:marvista/data/model/country.dart';
import 'package:marvista/data/repository/config_repository.dart';
import 'package:meta/meta.dart';

import '../../../data/model/static_content.dart';
import '../../../data/model/user_info.dart';
import '../../../data/repository/static_content_repository.dart';

@immutable
class RegisterOptState extends Equatable {
  final bool isEmailValid;
  final StaticContent staticContent;
  final bool isPasswordValid;
  final bool ableToLogin;
  final UserInfo userInfo;
  final Country countrySelected;
  final RegisterStatus registerStatus;
  final MaritalStatus maritalStatusSelected;

  RegisterOptState(
      {@required this.isEmailValid,
      @required this.isPasswordValid,
      this.staticContent,
      this.ableToLogin = false,
      this.countrySelected,
      this.maritalStatusSelected,
      this.registerStatus,
      this.userInfo});

  factory RegisterOptState.initial(ConfigRepository configRepository,
      StaticContentRepository staticContentRepository) {
    return RegisterOptState(
      isEmailValid: true,
      isPasswordValid: true,
      ableToLogin: false,
      registerStatus: null,
      maritalStatusSelected: configRepository?.getAppConfig()?.maritalStatus[0],
      staticContent: staticContentRepository.getLocalStaticContent(),
    );
  }

  RegisterOptState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    StaticContent staticContent,
    Country countrySelected,
    RegisterStatus registerStatus,
    MaritalStatus maritalStatusSelected,
  }) {
    return RegisterOptState(
        isEmailValid: isEmailValid ?? this.isEmailValid,
        staticContent: staticContent ?? this.staticContent,
        isPasswordValid: isPasswordValid ?? this.isPasswordValid,
        countrySelected: countrySelected ?? this.countrySelected,
        registerStatus: registerStatus ?? this.registerStatus,
        maritalStatusSelected:
            maritalStatusSelected ?? this.maritalStatusSelected,
        ableToLogin: isLoginAble(isEmailValid ?? this.isEmailValid,
            isPasswordValid ?? this.isPasswordValid));
  }

  bool isLoginAble(bool isEmailValid, bool isPassValid) {
    return isEmailValid && isPassValid;
  }

  RegisterOptState submitResult(
      {LoginStatus status, RegisterStatus registerStatus, UserInfo userInfo}) {
    return RegisterOptState(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      ableToLogin: ableToLogin,
      userInfo: userInfo,
      staticContent: staticContent,
      registerStatus: registerStatus,
    );
  }

  @override
  List<Object> get props => [
        isEmailValid,
        isPasswordValid,
        ableToLogin,
        staticContent,
        countrySelected,
        registerStatus,
        maritalStatusSelected
      ];

  @override
  String toString() {
    return '''MyFormState {
      isEmailValid: $isEmailValid,
      countrySelected: $countrySelected,
      maritalStatusSelected: $maritalStatusSelected,
      isPasswordValid: $isPasswordValid,
      registerStatus: $registerStatus,
      isAbleToLogin: $ableToLogin,
    }''';
  }
}

enum LoginStatus {
  notVerified,
  notChoosePersonalization,
  success,
  wrongCredential,
  failed,
}

enum RegisterStatus {
  getProfileSuccess,
  registerSuccess,
  alreadyRegister,
  failed,
  verifyCodeFail
}
