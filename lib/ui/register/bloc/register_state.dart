part of 'register_bloc.dart';

@immutable
class RegisterState extends Equatable {
  final bool isFirstNameValid;
  final bool isLastNameValid;
  final bool isEmailValid;
  final bool isPhoneValid;
  final bool isPasswordValid;
  final int hasSocialEmail;
  final bool isPasswordMatched;
  final bool hasUppercase;
  final bool hasDigits;
  final bool hasSpaceCharacters;
  final bool hasSpecialCharacters;
  final bool hasMinLength;
  final List<MaritalStatus> listMarital;
  final MaritalStatus maritalStatusSelected;
  final RegisterRoute currentRoute;
  final bool ableToRegister;
  final RegisterStatus registerStatus;
  final String tokenCode;
  final int timeResend;
  final DateTime selectedDate;
  final String errMessage;
  final String email;
  final Country countrySelected;
  final List<Country> listCountry;
  final UserInfo userInfo;

  RegisterState({
    @required this.isEmailValid,
    @required this.isFirstNameValid,
    @required this.isLastNameValid,
    @required this.isPhoneValid,
    @required this.selectedDate,
    @required this.hasSocialEmail,
    @required this.listMarital,
    @required this.maritalStatusSelected,
    @required this.isPasswordValid,
    @required this.isPasswordMatched,
    @required this.userInfo,
    @required this.currentRoute,
    this.tokenCode,
    this.hasUppercase,
    this.hasDigits,
    this.hasSpecialCharacters,
    this.hasSpaceCharacters,
    this.hasMinLength,
    this.timeResend,
    this.email,
    this.errMessage,
    this.ableToRegister,
    this.countrySelected,
    this.listCountry,
    this.registerStatus,
  });

  factory RegisterState.initial(
      ConfigRepository configRepository, int timeResendInit) {
    return RegisterState(
      isFirstNameValid: true,
      isLastNameValid: true,
      maritalStatusSelected: configRepository?.getAppConfig()?.maritalStatus[0],
      selectedDate: null,
      hasSocialEmail: 0,
      listMarital: configRepository?.getAppConfig()?.maritalStatus,
      isEmailValid: true,
      isPhoneValid: true,
      currentRoute: RegisterRoute.enterInformationForm,
      isPasswordValid: true,
      isPasswordMatched: true,
      ableToRegister: false,
      hasUppercase: false,
      hasDigits: false,
      hasSpaceCharacters: false,
      hasSpecialCharacters: false,
      hasMinLength: false,
      timeResend: timeResendInit,
      email: '',
      registerStatus: null,
      userInfo: null,
    );
  }

  RegisterState countDown() {
    return copyWith(timeResend: max(0, timeResend - 1));
  }

  RegisterState copyWith({
    bool isFirstNameValid,
    bool isLastNameValid,
    bool isEmailValid,
    bool isPhoneValid,
    MaritalStatus maritalStatusSelected,
    bool isPasswordValid,
    int hasSocialEmail,
    int timeResend,
    String tokenCode,
    String email,
    UserInfo userInfo,
    String fullname,
    String dob,
    String phone,
    String maritalId,
    DateTime selectedDate,
    String errMessage,
    bool isPasswordMatched,
    bool hasUppercase,
    bool hasDigits,
    bool hasSpecialCharacters,
    bool hasSpaceCharacters,
    bool hasMinLength,
    RegisterRoute currentRoute,
    Country selectedCountry,
    List<Country> listCountry,
  }) {
    return RegisterState(
      isFirstNameValid: isFirstNameValid ?? this.isFirstNameValid,
      isLastNameValid: isLastNameValid ?? this.isLastNameValid,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
      hasSocialEmail: hasSocialEmail ?? this.hasSocialEmail,
      userInfo: userInfo ?? this.userInfo,
      timeResend: timeResend ?? this.timeResend,
      selectedDate: selectedDate ?? this.selectedDate,
      maritalStatusSelected:
          maritalStatusSelected ?? this.maritalStatusSelected,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      listMarital: listMarital,
      isPasswordMatched: isPasswordMatched ?? this.isPasswordMatched,
      currentRoute: currentRoute ?? this.currentRoute,
      email: email ?? this.email,
      tokenCode: tokenCode ?? this.tokenCode,
      errMessage: errMessage,
      hasUppercase: hasUppercase ?? this.hasUppercase,
      hasDigits: hasDigits ?? this.hasDigits,
      hasSpecialCharacters: hasSpecialCharacters ?? this.hasSpecialCharacters,
      hasSpaceCharacters: hasSpaceCharacters ?? this.hasSpaceCharacters,
      hasMinLength: hasMinLength ?? this.hasMinLength,
      ableToRegister: isRegisterAble(
          isFirstNameValid ?? this.isFirstNameValid,
          isLastNameValid ?? this.isLastNameValid,
          selectedDate ?? this.selectedDate,
          // isPhoneValid ?? this.isPhoneValid,
          maritalStatusSelected ?? this.maritalStatusSelected,
          isEmailValid ?? this.isEmailValid,
          isPasswordValid ?? this.isPasswordValid,
          isPasswordMatched ?? this.isPasswordMatched),
      countrySelected: selectedCountry ?? countrySelected,
      listCountry: listCountry ?? this.listCountry,
    );
  }

  bool isRegisterAble(
    bool isFirstNameValid,
    bool isLastNameValid,
    DateTime selectDate,
    // bool isPhoneValid,
    MaritalStatus isMaritalSelected,
    bool isEmailValid,
    bool isPasswordValid,
    bool isPasswordMatched,
  ) {
    var dateValid = true;
    if (selectDate != null) {
      dateValid = DateUtil.isValidDOB(selectDate);
    }
    return isFirstNameValid &&
        isLastNameValid &&
        dateValid &&
        // isPhoneValid &&
        isEmailValid &&
        isPasswordValid &&
        isMaritalSelected != null &&
        isPasswordMatched;
  }

  RegisterState submitResult({RegisterStatus status, UserInfo userInfo}) {
    return RegisterState(
      hasSocialEmail: hasSocialEmail,
      isFirstNameValid: isFirstNameValid,
      isLastNameValid: isLastNameValid,
      isEmailValid: isEmailValid,
      isPhoneValid: isPhoneValid,
      listMarital: listMarital,
      listCountry: listCountry,
      countrySelected: countrySelected,
      timeResend: timeResend,
      userInfo: userInfo ?? this.userInfo,
      selectedDate: selectedDate,
      maritalStatusSelected: maritalStatusSelected,
      isPasswordValid: isPasswordValid,
      isPasswordMatched: isPasswordMatched,
      ableToRegister: ableToRegister,
      registerStatus: status,
      currentRoute: currentRoute,
    );
  }

  RegisterState verifyCodeFailData(
      {RegisterStatus registerStatus, String mess}) {
    return RegisterState(
      registerStatus: registerStatus,
      email: email,
      userInfo: userInfo,
      isEmailValid: isEmailValid,
      hasSocialEmail: hasSocialEmail,
      isFirstNameValid: isFirstNameValid,
      isLastNameValid: isLastNameValid,
      isPhoneValid: isPhoneValid,
      isPasswordValid: isPasswordValid,
      selectedDate: selectedDate,
      maritalStatusSelected: maritalStatusSelected,
      isPasswordMatched: isPasswordMatched,
      ableToRegister: ableToRegister,
      tokenCode: tokenCode,
      listMarital: listMarital,
      listCountry: listCountry,
      timeResend: timeResend,
      errMessage: mess,
      currentRoute: currentRoute,
    );
  }

  @override
  List<Object> get props => [
        isFirstNameValid,
        isLastNameValid,
        isEmailValid,
        isPhoneValid,
        isPasswordValid,
        ableToRegister,
        isPasswordMatched,
        maritalStatusSelected,
        currentRoute,
        hasSocialEmail,
        timeResend,
        tokenCode,
        email,
        errMessage,
        hasUppercase,
        hasDigits,
        hasSpecialCharacters,
        hasSpaceCharacters,
        hasMinLength,
        selectedDate,
        userInfo,
        registerStatus,
        listCountry,
        countrySelected,
      ];

  @override
  String toString() {
    return '''MyFormState {
      isFirstNameValid: $isFirstNameValid,
      isLastNameValid: $isLastNameValid,
      isEmailValid: $isEmailValid,
      isPhoneValid: $isPhoneValid,
      isPasswordValid: $isPasswordValid,
      isPasswordMatched: $isPasswordMatched,
      selectedDate: $selectedDate,
      hasSocialEmail: $hasSocialEmail,
      register: $ableToRegister,
      maritalStatusSelected: $maritalStatusSelected,
      tokenCode: $tokenCode,
      timeResend: $timeResend,
      email: $email,
      errMessage: $errMessage,
      hasUppercase: $hasUppercase,
      hasDigits: $hasDigits,
      hasSpecialCharacters: $hasSpecialCharacters,
      hasMinLength: $hasMinLength,
      currentRoute: $currentRoute,
      listCountry: $listCountry,
      selectedCountry: $countrySelected,
    }''';
  }
}

enum RegisterStatus {
  getProfileSuccess,
  registerSuccess,
  alreadyRegister,
  failed,
  verifyCodeFail
}

enum RegisterRoute {
  enterInformationForm,
  enterPinCode,
  popBack,
}
