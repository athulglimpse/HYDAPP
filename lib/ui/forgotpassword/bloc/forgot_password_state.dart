part of 'forgot_password_bloc.dart';

@immutable
class ForgotPasswordState extends Equatable {
  final int timeResend;
  final ForgotPasswordStatus forgotPasswordStatus;
  final ForgotPasswordRoute currentRoute;
  final String email;
  final String errMessage;
  final String tokenCode;
  final bool isPasswordMatched;
  final bool hasUppercase;
  final bool hasDigits;
  final bool hasSpecialCharacters;
  final bool hasMinLength;
  final bool isPasswordValid;

  ForgotPasswordState({
    this.email,
    this.isPasswordMatched,
    this.isPasswordValid,
    this.hasUppercase,
    this.hasDigits,
    this.hasSpecialCharacters,
    this.hasMinLength,
    this.tokenCode,
    this.currentRoute,
    this.errMessage,
    this.timeResend,
    this.forgotPasswordStatus,
  });

  factory ForgotPasswordState.initial(int timeResendInit) {
    return ForgotPasswordState(
      hasUppercase: false,
      hasDigits: false,
      hasSpecialCharacters: false,
      hasMinLength: false,
      isPasswordValid: true,
      isPasswordMatched: true,
      currentRoute: ForgotPasswordRoute.enterEmail,
      timeResend: timeResendInit,
    );
  }

  ForgotPasswordState countDown() {
    return copyWith(timeResend: max(0, timeResend - 1));
  }

  // ForgotPasswordState failData(
  //     {ForgotPasswordStatus forgotPasswordStatus, String mess}) {
  //   return ForgotPasswordState(
  //     forgotPasswordStatus: forgotPasswordStatus,
  //     email: email,
  //     tokenCode: tokenCode,
  //     timeResend: timeResend,
  //     errMessage: mess,
  //     currentRoute: currentRoute,
  //   );
  // }

  ForgotPasswordState copyWith({
    int timeResend,
    ForgotPasswordStatus forgotPasswordStatus,
    ForgotPasswordRoute currentRoute,
    String email,
    bool isPasswordMatched,
    bool isPasswordValid,
    bool hasUppercase,
    bool hasDigits,
    String mess,
    bool hasSpecialCharacters,
    bool hasMinLength,
    String tokenCode,
  }) {
    return ForgotPasswordState(
        timeResend: timeResend ?? this.timeResend,
        email: email ?? this.email,
        errMessage: mess,
        forgotPasswordStatus: forgotPasswordStatus ?? ForgotPasswordStatus.none,
        tokenCode: tokenCode ?? this.tokenCode,
        isPasswordMatched: isPasswordMatched ?? this.isPasswordMatched,
        isPasswordValid: isPasswordValid ?? this.isPasswordValid,
        hasUppercase: hasUppercase ?? this.hasUppercase,
        hasDigits: hasDigits ?? this.hasDigits,
        hasSpecialCharacters: hasSpecialCharacters ?? this.hasSpecialCharacters,
        hasMinLength: hasMinLength ?? this.hasMinLength,
        currentRoute: currentRoute ?? this.currentRoute);
  }

  @override
  List<Object> get props => [
        timeResend,
        email,
        tokenCode,
        currentRoute,
        forgotPasswordStatus,
        isPasswordMatched,
        isPasswordValid,
        hasUppercase,
        hasDigits,
        hasSpecialCharacters,
        hasMinLength,
        errMessage
      ];

  @override
  String toString() {
    return '''MyFormState {
      timeResend: $timeResend,
      forgotPasswordStatus: $forgotPasswordStatus,
      email: $email,
      errMessage: $errMessage,
      tokenCode: $tokenCode,
      isPasswordMatched: $isPasswordMatched,
      isPasswordValid: $isPasswordValid,
      hasUppercase: $hasUppercase,
      hasDigits: $hasDigits,
      hasSpecialCharacters: $hasSpecialCharacters,
      hasMinLength: $hasMinLength,
      currentRoute: $currentRoute,
    }''';
  }
}

enum ForgotPasswordStatus {
  none,
  verifyCodeInvalid,
  emailInvalid,
  newPasswordInvalid,
  changePasswordSuccess,
}

enum ForgotPasswordRoute { enterEmail, enterPinCode, enterNewPassword, popBack }

class ForgotPasswordSuccess extends ForgotPasswordState {
  ForgotPasswordSuccess(ForgotPasswordRoute route) : super(currentRoute: route);
}
