part of 'register_opt_page.dart';

extension RegisterOtpAction on _RegisterOptPageState {
  Future<void> _handleGoogleSignIn(RegisterOptState state) async {
    await _pbLoading.show();
    try {
      final socialLoginDataResult = await _firebaseWrapper.handleGoogleSignIn();
      socialLoginDataResult.fold((l) {
        _pbLoading.hide();
        UIUtil.showToast(Lang.home_fail_to_sign_in_social.tr());
      }, (socialLoginData) {
        if (socialLoginData.email != null) {
          _registerOptBloc.add(RegisterByEmail(
              firstName: socialLoginData?.firstName ?? socialLoginData.name,
              lastName: socialLoginData.lastName ?? '',
              socialId: socialLoginData.id,
              dob: DateTime.now()
                  .subtract(const Duration(days: 365 * 13 + 4))
                  .toString(),
              hasSocialEmail: 1,
              type: getTypeByEnum(RegisterEnum.GOOGLE),
              email: socialLoginData.email,
              maritalId: state.maritalStatusSelected.id.toString(),
              dialCode: state?.countrySelected?.dialCode ?? ''));
        } else {
          _pbLoading.hide();
          NavigateUtil.openPage(context, RegisterPage.routeName,
              argument: {'type': RegisterEnum.GOOGLE, 'data': socialLoginData});
        }
      });
    } catch (error) {
      await _pbLoading.hide();
    }
  }

  //Take action Facebook SignIn
  Future<void> _handleFacebookSignIn(RegisterOptState state) async {
    await _pbLoading.show();
    try {
      final socialLoginDataResult =
          await _firebaseWrapper.handleFacebookSignIn();
      socialLoginDataResult.fold((l) {
        _pbLoading.hide();
        UIUtil.showToast(Lang.home_fail_to_sign_in_social.tr());
      }, (socialLoginData) {
        if (socialLoginData.email != null) {
          _registerOptBloc.add(RegisterByEmail(
              firstName: socialLoginData?.firstName ?? socialLoginData.name,
              lastName: socialLoginData.lastName ?? '',
              socialId: socialLoginData.id,
              dob: DateTime.now()
                  .subtract(const Duration(days: 365 * 13 + 4))
                  .toString(),
              hasSocialEmail: 1,
              type: getTypeByEnum(RegisterEnum.FACEBOOK),
              email: socialLoginData.email,
              maritalId: state.maritalStatusSelected.id.toString(),
              dialCode: state?.countrySelected?.dialCode ?? ''));
        } else {
          _pbLoading.hide();
          NavigateUtil.openPage(context, RegisterPage.routeName, argument: {
            'type': RegisterEnum.FACEBOOK,
            'data': socialLoginData
          });
        }
      });
    } catch (error) {
      await _pbLoading.hide();
    }
  }
 
  ///Take action Apple SignIn
  Future<void> _handleAppleSignIn(RegisterOptState state) async {
    await _pbLoading.show();
    try {
      final socialLoginDataResult = await _firebaseWrapper.handleAppleSignIn();
      socialLoginDataResult.fold((l) {
        _pbLoading.hide();
        UIUtil.showToast(Lang.home_fail_to_sign_in_social.tr());
      }, (socialLoginData) {
        if (socialLoginData.email != null) {
          var firstName =
              socialLoginData?.firstName ?? (socialLoginData.name ?? '');
          var lastName = socialLoginData.lastName ?? '';
          if (firstName.isEmpty && lastName.isEmpty) {
            firstName = socialLoginData.email.split('@')[0];
            lastName =
                socialLoginData.email.split('@')[1].replaceAll('.com', '');
          }
          _registerOptBloc.add(RegisterByEmail(
              firstName: firstName,
              lastName: lastName,
              socialId: socialLoginData.id,
              dob: DateTime.now()
                  .subtract(const Duration(days: 365 * 13 + 4))
                  .toString(),
              hasSocialEmail: 1,
              type: getTypeByEnum(RegisterEnum.APPLE),
              email: socialLoginData.email,
              maritalId: state.maritalStatusSelected.id.toString(),
              dialCode: state?.countrySelected?.dialCode ?? ''));
        }  else {
          _pbLoading.hide();
          NavigateUtil.openPage(context, RegisterPage.routeName,
              argument: {'type': RegisterEnum.APPLE, 'data': socialLoginData});
        }
      });
    } catch (error) {
      await _pbLoading.hide();
    }
  }
}
