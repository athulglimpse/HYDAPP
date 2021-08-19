import 'package:marvista/common/localization/lang.dart';
import 'package:easy_localization/easy_localization.dart';

String format(String template, List<Object> arguments) {
  var result = '';
  var argumentsIndex = 0;
  for (var index = 0; index < template.length; index++) {
    if (template.codeUnitAt(index) == 37 /* ascii '%' */) {
      result += arguments[argumentsIndex++].toString();
    } else {
      result += template.substring(index, index + 1);
    }
  }
  return result;
}

String validateMobile(String value) {
  if (value == null || value.isEmpty) {
    return null;
  }
  const pattern = r'(^(?:[+0]9)?[0-9]{5,10}$)';
  final regExp = RegExp(pattern);
  if (value.isEmpty) {
    return 'Please enter mobile number';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter valid mobile number';
  }
  return null;
}

String validateName(String value) {
  if (value.isEmpty) {
    return 'Name is required.';
  }
  final nameExp = RegExp(r'^[A-za-z ]+$');
  if (!nameExp.hasMatch(value)) {
    return 'Please enter only alphabetical characters.';
  }
  return null;
}

String validateUserName(String value) {
  if (value.isEmpty) {
    return 'Username is required.';
  }
  return null;
}

String validatePassword(String value) {
  if (value.isEmpty) {
    return Lang.forgot_password_please_choose_a_password.tr();
  }
  return null;
}

String validateRePassword(String pass, String repass) {
  if (repass != pass) {
    return Lang.register_confirmed_password_not_match.tr();
  }
  return null;
}

String validateCodePassword(String code) {
  if (code.isEmpty) {
    return 'Code is required.';
  }
  return null;
}
