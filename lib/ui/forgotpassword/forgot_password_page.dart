import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../common/di/injection/injector.dart';
import '../../common/localization/lang.dart';
import '../../common/theme/theme.dart';
import '../../common/widget/my_button.dart';
import '../../common/widget/my_input_field.dart';
import '../../common/widget/my_text_view.dart';
import '../../common/widget/pincode/my_pin_theme.dart';
import '../../common/widget/pincode/pin_code.dart';
import '../../utils/navigate_util.dart';
import '../../utils/string_util.dart';
import '../../utils/ui_util.dart';
import '../../utils/utils.dart';
import '../base/base_widget.dart';
import '../congratulation_register/congratulation_regiter_page.dart';
import 'bloc/forgot_password_bloc.dart';

class ForgotPasswordScreen extends BaseWidget {
  static const routeName = '/ForgotPasswordScreen';

  ForgotPasswordScreen();

  @override
  State<StatefulWidget> createState() {
    return ForgotPasswordScreenState();
  }
}

class ForgotPasswordScreenState extends BaseState<ForgotPasswordScreen> {
  final FocusNode _focusEmail = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _focusNewPassword = FocusNode();
  final FocusNode _focusConfirmNewPassword = FocusNode();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  String pinCodeData = '';

  ProgressDialog _pbLoading;

  final ForgotPasswordBloc _forgotPasswordBloc = sl<ForgotPasswordBloc>();
  Widget listPinBox;

  @override
  void initState() {
    super.initState();
    needHideKeyboard();
    //Call this method first when LoginScreen init
    initBasicInfo();
    _newPasswordController.addListener(_onPasswordChanged);
    _confirmNewPasswordController.addListener(_onConfirmPasswordChanged);

    _forgotPasswordBloc.listen((state) {
      if (state.currentRoute == ForgotPasswordRoute.popBack) {
        NavigateUtil.pop(context);
        return;
      }
      if (state.forgotPasswordStatus != null) {
        _pbLoading.hide();
        switch (state.forgotPasswordStatus) {
          case ForgotPasswordStatus.changePasswordSuccess:
            NavigateUtil.replacePage(
                context, CongratulationRegisterScreen.routeName,
                argument: {'type': CongratulationEnum.FORGOT_PASSWORD});
            return;
          case ForgotPasswordStatus.none:
            break;
          case ForgotPasswordStatus.verifyCodeInvalid:
          case ForgotPasswordStatus.emailInvalid:
          case ForgotPasswordStatus.newPasswordInvalid:
            UIUtil.showToast(
              state.errMessage,
              backgroundColor: Colors.red,
            );
            break;
          default:
            UIUtil.showToast(
              Lang.login_invalid_email.tr(),
              backgroundColor: Colors.red,
            );
        }
        return;
      }
    });
  }

  void initBasicInfo() {}

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _pbLoading = ProgressDialog(context, showLogs: true);
    _pbLoading.style(message: Lang.started_loading_please_wait.tr());
    return makeParent(Container(
      color: const Color(0xffFDFBF5),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                _forgotPasswordBloc.add(DoBackRoute());
              },
            ),
            backgroundColor: const Color(0xffFDFBF5),
            title: MyTextView(
              textStyle: textNormal.copyWith(color: Colors.black),
              text: Lang.forgot_password_forgot_password.tr(),
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return BlocProvider(
                create: (_) => _forgotPasswordBloc,
                child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                    builder: (context, state) {
                  return SingleChildScrollView(
                      child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(sizeNormal),
                      child: getLayoutByState(state),
                    ),
                  ));
                }),
              );
            },
          ),
        ),
      ),
    ));
  }

  Widget getLayoutByState(ForgotPasswordState state) {
    if (_pbLoading.isShowing()) {
      _pbLoading.hide();
    }
    switch (state.currentRoute) {
      case ForgotPasswordRoute.enterEmail:
        return enterEmailForm();
      case ForgotPasswordRoute.enterPinCode:
        return enterVerifyCode(state);
      case ForgotPasswordRoute.enterNewPassword:
        return createPasswordForm(state);
      default:
        return enterEmailForm();
    }
  }

  Widget createPasswordForm(ForgotPasswordState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MyTextView(
          text: Lang.forgot_password_please_enter_your_new_password.tr(),
          textStyle: textSmallx.copyWith(color: Colors.black),
        ),
        const SizedBox(height: sizeLarge),
        Container(
          margin: const EdgeInsets.only(left: sizeNormal, right: sizeNormal),
          child: Column(
            children: [
              MyInputField(
                focusNode: _focusNewPassword,
                textHint: Lang.forgot_password_new_password.tr(),
                nextFocusNode: _focusConfirmNewPassword,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                obscureText: true,
                textController: _newPasswordController,
                hasPasswordRule: true,
                hasUppercase: state.hasUppercase,
                hasDigits: state.hasDigits,
                hasSpecialCharacters: state.hasSpecialCharacters,
                hasMinLength: state.hasMinLength ?? false,
              ),
              const SizedBox(height: sizeNormal),
              MyInputField(
                focusNode: _focusConfirmNewPassword,
                textHint: Lang.forgot_password_confirm_new_password.tr(),
                autoValidateMode: AutovalidateMode.onUserInteraction,
                textInputAction: TextInputAction.done,
                obscureText: true,
                onFieldSubmitted: (v) => doSubmitNewPassword(),
                textController: _confirmNewPasswordController,
                errorMessage: state.isPasswordMatched
                    ? null
                    : Lang.register_confirm_password_not_matched.tr(),
              ),
            ],
          ),
        ),
        const SizedBox(height: sizeLarge),
        Padding(
          padding: const EdgeInsets.only(top: sizeNormal, bottom: sizeSmall),
          child: MyButton(
            minWidth: sizeImageLarge,
            text: Lang.forgot_password_resend_confirm.tr(),
            onTap: doSubmitNewPassword,
            isFillParent: false,
            textStyle: textNormal.copyWith(color: Colors.white),
            buttonColor: const Color(0xff242655),
          ),
        ),
      ],
    );
  }

  Widget enterVerifyCode(ForgotPasswordState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MyTextView(
          text: Lang.forgot_password_enter_the_6_digit_code_sent.tr(),
          textStyle: textSmallx.copyWith(color: Colors.black),
        ),
        const SizedBox(height: sizeLarge),
        Container(
          margin: const EdgeInsets.only(left: sizeNormal, right: sizeNormal),
          child: PinCode(
            length: 6,
            obscureText: false,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            animationType: AnimationType.fade,
            pinTheme: MyPinTheme(
              shape: MyPinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(sizeVerySmall),
              fieldHeight: sizeLarge,
              selectedColor: Colors.white,
              inactiveColor: Colors.white,
              disabledColor: Colors.white,
              activeColor: Colors.white,
              inactiveFillColor: Colors.white,
              borderWidth: 0,
              selectedFillColor: Colors.blue.withAlpha(100),
              fieldWidth: sizeLarge,
              activeFillColor: Colors.white,
            ),
            animationDuration: const Duration(milliseconds: 300),
            backgroundColor: Colors.transparent,
            keyboardType: TextInputType.number,
            enablePinAutofill: false,
            enableActiveFill: true,
            autoDisposeControllers: false,
            onCompleted: (v) {
              pinCodeData = v;
            },
            onChanged: (value) {
              pinCodeData = value;
            },
            beforeTextPaste: (text) {
              print('Allowing to paste $text');
              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
              //but you can show anything you want here, like your pop up saying wrong paste format or etc
              return true;
            },
            appContext: context,
          ),
        ),
        const SizedBox(height: sizeNormal),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: Lang.forgot_password_did_get_code.tr(),
            style: textSmallx,
            children: <TextSpan>[
              TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (state.timeResend == 0) {
                        _pbLoading.show();
                        _forgotPasswordBloc.add(DoResendCode());
                      }
                    },
                  text:
                      ' ${state.timeResend == 0 ? Lang.forgot_password_resend_code.tr() : '${Lang.forgot_password_resend_in.tr()} ${state.timeResend.toString()}'}',
                  style: textSmallx.copyWith(
                    color: const Color(0xffFDCB6B),
                  )),
            ],
          ),
        ),
        const SizedBox(height: sizeLarge),
        Padding(
          padding: const EdgeInsets.only(top: sizeNormal, bottom: sizeSmall),
          child: MyButton(
            minWidth: sizeImageLarge,
            text: Lang.forgot_password_reset_password_up_case.tr(),
            onTap: doSubmitPinCode,
            isFillParent: false,
            textStyle: textNormal.copyWith(color: Colors.white),
            buttonColor: const Color(0xff242655),
          ),
        ),
      ],
    );
  }

  Widget enterEmailForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MyTextView(
          text:
              Lang.forgot_password_enter_your_email_to_receive_verify_code.tr(),
          textStyle: textSmallx.copyWith(color: Colors.black),
        ),
        const SizedBox(height: sizeLarge),
        Container(
          margin: const EdgeInsets.only(top: sizeSmall),
          padding: const EdgeInsets.all(sizeVerySmall),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(sizeSmall))),
          child: TextFormField(
            focusNode: _focusEmail,
            style: textSmallxx.copyWith(
                fontWeight: FontWeight.bold, color: Colors.black),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(sizeVerySmall),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(90.0)),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  )),
              focusedBorder: InputBorder.none,
              isDense: true,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              labelText: Lang.login_email.tr(),
              labelStyle: textSmallxx.copyWith(
                color: _focusEmail.hasFocus
                    ? const Color(0xffFDCB6B)
                    : const Color(0x32212237),
              ),
            ),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            onFieldSubmitted: (v) {},
          ),
        ),
        const SizedBox(height: sizeLarge),
        Padding(
          padding: const EdgeInsets.only(top: sizeNormal, bottom: sizeSmall),
          child: MyButton(
            minWidth: sizeImageLarge,
            text: Lang.forgot_password_reset_password_up_case.tr(),
            onTap: doSubmitEmailToGetCode,
            isFillParent: false,
            textStyle: textNormal.copyWith(color: Colors.white),
            buttonColor: const Color(0xff242655),
          ),
        ),
      ],
    );
  }

  void doSubmitEmailToGetCode() {
    final email = _emailController.text;
    final errMessageEmail =
        Utils.isValidEmail(email) ? '' : Lang.login_invalid_email.tr();
    if (email.isNotEmpty && (errMessageEmail?.isEmpty ?? true)) {
      _pbLoading.show();
      _forgotPasswordBloc.add(SubmitEmailToVerify(email: email));
    } else {
      UIUtil.showToast(Lang.login_invalid_email.tr(),
        backgroundColor: Colors.red,);
    }
    FocusScope.of(context).requestFocus(FocusNode());
  }

  //Check validate pinCode data and submit to Server
  void doSubmitPinCode() {
    final code = pinCodeData;
    final errMessageCode = validateCodePassword(code);
    if (code.isNotEmpty && (errMessageCode?.isEmpty ?? true)) {
      _pbLoading.show();
      _forgotPasswordBloc.add(SubmitVerifyCode(
          code: code, tokenCode: _forgotPasswordBloc.state.tokenCode));
    } else {
      UIUtil.showToast(Lang.forgot_password_invalid_did_code.tr(),
        backgroundColor: Colors.red,);
    }
  }

  void doSubmitNewPassword() {
    final newPassWord = _newPasswordController.text;
    final confirmNewPassWord = _confirmNewPasswordController.text;

    final errMessageNewPassWord = validatePassword(newPassWord);
    final errMessageConfirmPassWord =
        validateRePassword(newPassWord, confirmNewPassWord);

    //validate password
    if (errMessageNewPassWord?.isNotEmpty ?? false) {
      UIUtil.showToast(errMessageNewPassWord,
        backgroundColor: Colors.red,);
      return;
    }

    //validate password and confirm password
    if (errMessageConfirmPassWord?.isNotEmpty ?? false) {
      UIUtil.showToast(errMessageConfirmPassWord,
        backgroundColor: Colors.red,);
      return;
    }

    //Submit Data do Server
    _pbLoading.show();
    _forgotPasswordBloc.add(SubmitNewPassword(
        newPassword: newPassWord,
        confirmNewPassword: confirmNewPassWord,
        tokenCode: _forgotPasswordBloc.state.tokenCode));
  }

  void _onPasswordChanged() {
    _forgotPasswordBloc
        .add(PasswordChanged(password: _newPasswordController.text));
  }

  void _onConfirmPasswordChanged() {
    _forgotPasswordBloc.add(ConfirmPasswordChanged(
        password: _newPasswordController.text,
        confirmPassword: _confirmNewPasswordController.text));
  }

  @override
  void dispose() {
    _forgotPasswordBloc.close();

    _emailController.dispose();

    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();

    _focusEmail.dispose();
    _focusNewPassword.dispose();
    _focusConfirmNewPassword.dispose();

//    pinCodeController.dispose();
    super.dispose();
  }
}
