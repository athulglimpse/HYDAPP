part of 'change_password_bloc.dart';

@immutable
class ChangePasswordState {
  final String tokenCode;
  final bool isPasswordMatched;
  final bool hasUppercase;
  final bool hasDigits;
  final bool hasSpecialCharacters;
  final bool hasMinLength;
  final bool isPasswordValid;
  final ChangePassStatus status;

  ChangePasswordState({
    this.hasUppercase = false,
    this.hasDigits = false,
    this.tokenCode,
    this.hasSpecialCharacters = false,
    this.hasMinLength = false,
    this.isPasswordValid = true,
    this.isPasswordMatched = true,
    this.status = ChangePassStatus.NONE,
  });

  ChangePasswordState copyWith({
    String tokenCode,
    bool isPasswordMatched,
    bool hasUppercase,
    ChangePassStatus status,
    bool hasDigits,
    bool hasSpecialCharacters,
    bool hasMinLength,
    bool isPasswordValid,
  }) {
    return ChangePasswordState(
      tokenCode: tokenCode ?? this.tokenCode,
      isPasswordMatched: isPasswordMatched ?? this.isPasswordMatched,
      hasUppercase: hasUppercase ?? this.hasUppercase,
      hasDigits: hasDigits ?? this.hasDigits,
      status: status ?? ChangePassStatus.NONE,
      hasSpecialCharacters: hasSpecialCharacters ?? this.hasSpecialCharacters,
      hasMinLength: hasMinLength ?? this.hasMinLength,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
    );
  }

  @override
  List<Object> get props => [
        isPasswordMatched,
        tokenCode,
        hasUppercase,
        status,
        hasDigits,
        hasSpecialCharacters,
        hasMinLength,
        isPasswordValid,
      ];
}

class CheckOldPasswordState extends ChangePasswordState {}

enum ChangePassStatus {
  NONE,
  FAIL,
  CHECK_PASSWORD_SUCCESS,
  CHANGE_PASSWORD_SUCCESS,
}
