import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marvista/common/widget/auto_hide_keyboard.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../common/constants.dart';
import '../../common/di/injection/injector.dart';
import '../../common/dialog/link_account_dialog.dart';
import '../../common/localization/lang.dart';
import '../../common/theme/theme.dart';
import '../../common/widget/my_button.dart';
import '../../common/widget/my_input_field.dart';
import '../../common/widget/my_text_view.dart';
import '../../utils/app_const.dart';
import '../../utils/firebase_wrapper.dart';
import '../../utils/navigate_util.dart';
import '../../utils/string_util.dart';
import '../../utils/ui_util.dart';
import '../base/base_widget.dart';
import '../forgotpassword/forgot_password_page.dart';
import '../main/main_page.dart';
import '../personalization/personalization_page.dart';
import '../register/util/register_util.dart';
import '../verifycode/verify_code_page.dart';
import 'bloc/bloc.dart';
import 'bloc/login_bloc.dart';

class LoginPage extends BaseWidget {
  static const routeName = 'LoginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends BaseState<LoginPage> {
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  final _loginBloc = sl<LoginBloc>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  ProgressDialog _pbLoading;
  final _firebaseWrapper = sl<FirebaseWrapper>();

  @override
  void initState() {
    super.initState();
    needHideKeyboard();
    canClickBackPress();

    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _loginBloc.listen(onStateChange);
  }

  void showDialogLinkAccount(String email) {
    showDialog(
      context: context,
      builder: (BuildContext context) => LinkAccountDialog(
        email: email,
        onEnterPassword: (v) {
          final errPass = validatePassword(v);
          if (errPass?.isNotEmpty ?? false) {
            UIUtil.showToast(
              errPass,
              backgroundColor: Colors.red,
            );
            return;
          }
          NavigateUtil.pop(context);
          _pbLoading.show();
          _loginBloc.add(LinkAccount(v));
        },
      ),
    );
  }

  Future<void> onStateChange(LoginState state) async {
    if (state.loginStatus != null) {
      await Future.delayed(const Duration(milliseconds: 200));
      await _pbLoading.hide();

      switch (state.loginStatus) {
        case LoginStatus.success:
          await NavigateUtil.openPage(context, MainScreen.routeName);
          break;
        case LoginStatus.notChoosePersonalization:
          if (isMVP) {
            await NavigateUtil.openPage(context, MainScreen.routeName);
          } else {
            await NavigateUtil.openPage(
                context, PersonalizationScreen.routeName);
          }
          break;
        case LoginStatus.notVerified:
          await NavigateUtil.openPage(context, VerifyCodeScreen.routeName);
          break;
        case LoginStatus.linkAccount:
          showDialogLinkAccount(state.email);
          break;
        case LoginStatus.wrongCredential:
          UIUtil.showToast(
            'login_wrong_credential',
            backgroundColor: Colors.red,
          );
          break;
        case LoginStatus.failed:
          UIUtil.showToast(
            state.errorMessage,
            backgroundColor: Colors.red,
          );
          break;
        default:
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _pbLoading = ProgressDialog(context, showLogs: true);
    _pbLoading.style(message: Lang.started_loading_please_wait.tr());
    return AutoHideKeyboard(
      child: Container(
        color: const Color(0xffFDFBF5),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () => NavigateUtil.pop(context),
              ),
              backgroundColor: const Color(0xffFDFBF5),
              title: MyTextView(
                textStyle: textSmallxxx.copyWith(
                    color: Colors.black, fontWeight: FontWeight.bold),
                text: Lang.login_enter_your_credentials.tr(),
              ),
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: SingleChildScrollView(
                      child: buildScreen(context, constraints)),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  BlocProvider<LoginBloc> buildScreen(
      BuildContext context, BoxConstraints constraints) {
    return BlocProvider(
        create: (_) => _loginBloc,
        child: Container(
          child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: sizeLarge,
                    left: sizeLarge,
                    right: sizeLarge,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MyInputField(
                        focusNode: _focusEmail,
                        textHint: Lang.login_email.tr(),
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        nextFocusNode: _focusPassword,
                        textController: _emailController,
                      ),
                      MyInputField(
                        focusNode: _focusPassword,
                        textHint: Lang.login_password.tr(),
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        textController: _passwordController,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          doLogin(state);
                        },
                      ),
                      const SizedBox(
                        height: sizeLarge,
                      ),
                      MyTextView(
                        text: Lang.login_forgot_password.tr(),
                        onTap: () {
                          NavigateUtil.openPage(
                              context, ForgotPasswordScreen.routeName);
                        },
                        textStyle: textSmallxx.copyWith(
                            color: const Color(0xffFDCB6B)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: sizeNormal, bottom: sizeSmall),
                        child: MyButton(
                          paddingHorizontal: sizeExLarge,
                          text: Lang.login_login.tr(),
                          onTap: () {
                            doLogin(state);
                          },
                          isFillParent: false,
                          textStyle: textNormal.copyWith(color: Colors.white),
                          buttonColor: const Color(0xff242655),
                        ),
                      ),
                      const SizedBox(
                        height: sizeLargexx,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: const EdgeInsets.only(right: sizeSmallxx),
                              color: Colors.black,
                              height: 1,
                            ),
                          ),
                          MyTextView(
                            text: Lang.login_or.tr(),
                            textStyle:
                                textSmallx.copyWith(color: Colors.grey[600]),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: const EdgeInsets.only(left: sizeSmallxx),
                              color: Colors.black,
                              height: 1,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: sizeNormalxx,
                      ),
                    ],
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Material(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(sizeVerySmallx)),
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            _handleGoogleSignIn();
                          },
                          splashColor: Colors.white.withAlpha(100),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(sizeVerySmallx)),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(sizeVerySmallx)),
                                  border: Border.all(
                                      width: 0.5, color: Colors.grey[200])),
                              padding: const EdgeInsets.only(
                                  left: sizeNormalxx, right: sizeNormalxx),
                              height: sizeLargexx + sizeVerySmall,
                              child: Center(
                                child: UIUtil.makeImageWidget(Res.icon_google,
                                    size:
                                        const Size(sizeNormalxx, sizeNormalxx)),
                              )),
                        ),
                      ),
                      if (Platform.isIOS)
                        Material(
                          borderRadius: const BorderRadius.all(
                              Radius.circular(sizeVerySmallx)),
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              _handleAppleSignIn();
                            },
                            splashColor: Colors.white.withAlpha(100),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(sizeVerySmallx)),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(sizeVerySmallx)),
                                    border: Border.all(
                                        width: 0.5, color: Colors.grey[200])),
                                padding: const EdgeInsets.only(
                                    left: sizeNormalxx, right: sizeNormalxx),
                                height: sizeLargexx + sizeVerySmall,
                                child: const Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.apple,
                                    size: sizeNormalxx,
                                    color: Colors.black,
                                  ),
                                )),
                          ),
                        ),
                      Material(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(sizeVerySmallx)),
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            _handleFacebookSignIn();
                          },
                          splashColor: Colors.white.withAlpha(100),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(sizeVerySmallx)),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(sizeVerySmallx)),
                                  border: Border.all(
                                      width: 0.5, color: Colors.grey[200])),
                              padding: const EdgeInsets.only(
                                  left: sizeNormalxx, right: sizeNormalxx),
                              height: sizeLargexx + sizeVerySmall,
                              child: const Center(
                                child: FaIcon(
                                  FontAwesomeIcons.facebook,
                                  size: sizeNormalxx,
                                  color: Color.fromARGB(250, 22, 93, 240),
                                ),
                              )),
                        ),
                      ),
                    ])
              ],
            );
          }),
        ));
  }

  bool _isFormAbleToLogin(bool formValidate) {
    return formValidate &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  void doLogin(LoginState state) {
    if (_isFormAbleToLogin(true)) {
      _pbLoading.show();
      _loginBloc.add(LoginButtonPressed(
          username: _emailController.text, password: _passwordController.text));
    } else {
      UIUtil.showToast(Lang.register_please_fill_all_fields.tr(),
        backgroundColor: Colors.red,);
    }
  }

  ///Take action google SignIn
  Future<void> _handleGoogleSignIn() async {
    await _pbLoading.show();
    try {
      final socialLoginDataResult = await _firebaseWrapper.handleGoogleSignIn();
      socialLoginDataResult.fold((l) {
        _pbLoading.hide();
        UIUtil.showToast(Lang.home_fail_to_sign_in_social.tr(),
          backgroundColor: Colors.red,);
      }, (socialLoginData) {
        _loginBloc.add(LoginSocial(
            socialId: socialLoginData.id,
            email: socialLoginData.email,
            type: getTypeByEnum(RegisterEnum.GOOGLE)));
      });
    } catch (error) {
      await _pbLoading.hide();
    }
  }

  ///Take action Facebook SignIn
  Future<void> _handleFacebookSignIn() async {
    await _pbLoading.show();
    try {
      final socialLoginDataResult =
          await _firebaseWrapper.handleFacebookSignIn();
      socialLoginDataResult.fold((l) {
        _pbLoading.hide();
        UIUtil.showToast(Lang.home_fail_to_sign_in_social.tr(),
          backgroundColor: Colors.red,);
      }, (socialLoginData) {
        _loginBloc.add(LoginSocial(
            socialId: socialLoginData.id,
            email: socialLoginData.email,
            type: getTypeByEnum(RegisterEnum.FACEBOOK)));
      });
    } catch (error) {
      await _pbLoading.hide();
    }
  }

  ///Take action Apple SignIn
  Future<void> _handleAppleSignIn() async {
    await _pbLoading.show();
    try {
      final socialLoginDataResult = await _firebaseWrapper.handleAppleSignIn();
      socialLoginDataResult.fold((l) {
        _pbLoading.hide();
        UIUtil.showToast(Lang.home_fail_to_sign_in_social.tr(),
          backgroundColor: Colors.red,);
      }, (socialLoginData) {
        _loginBloc.add(LoginSocial(
            socialId: socialLoginData.id,
            email: socialLoginData.email,
            type: getTypeByEnum(RegisterEnum.APPLE)));
      });
    } catch (error) {
      await _pbLoading.hide();
    }
  }

  void _onEmailChanged() {
    _loginBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPasswordChanged() {
    _loginBloc.add(PasswordChanged(password: _passwordController.text));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    _loginBloc.close();

    _focusPassword.dispose();
    _focusEmail.dispose();
    super.dispose();
  }
}
