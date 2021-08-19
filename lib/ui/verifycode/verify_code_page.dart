import 'package:after_layout/after_layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../common/di/injection/injector.dart';
import '../../common/localization/lang.dart';
import '../../common/theme/theme.dart';
import '../../common/widget/my_button.dart';
import '../../common/widget/my_text_view.dart';
import '../../common/widget/pincode/my_pin_theme.dart';
import '../../common/widget/pincode/pin_code.dart';
import '../../utils/app_const.dart';
import '../../utils/navigate_util.dart';
import '../../utils/string_util.dart';
import '../../utils/ui_util.dart';
import '../base/base_widget.dart';
import '../getstarted/get_started_page.dart';
import '../main/main_page.dart';
import '../personalization/personalization_page.dart';
import '../splash/splash_page.dart';
import 'bloc/verify_code_bloc.dart';

class VerifyCodeScreen extends BaseWidget {
  static const routeName = '/VerifyCodeScreen';
  final String email;
  final String tokenCode;
  final String comeFrom;
  VerifyCodeScreen({this.email, this.comeFrom, this.tokenCode});

  @override
  State<StatefulWidget> createState() {
    return VerifyCodeScreenState();
  }
}

class VerifyCodeScreenState extends BaseState<VerifyCodeScreen>
    with AfterLayoutMixin {
  final VerifyCodeBloc _verifyCodeBloc = sl<VerifyCodeBloc>();
  String pinCodeData = '';
  ProgressDialog _pbLoading;

  @override
  void initState() {
    super.initState();
    //Call this method first when LoginScreen init
    initBasicInfo();
  }

  void initBasicInfo() {
    _verifyCodeBloc.listen((state) {
      if (state.isLogout) {
        print('state.isLogout');
        _pbLoading.hide();
        NavigateUtil.replacePage(context, StartedScreen.routeName);
        return;
      }
      if (state.verifyCodeStatus != null) {
        _pbLoading.hide();
        FocusScope.of(context).requestFocus(FocusNode());
        switch (state.verifyCodeStatus) {
          case VerifyCodeStatus.success:
            checkUserDirection(state);
            break;
          case VerifyCodeStatus.verifyCodeFail:
            UIUtil.showToast(state.errMessage);
            break;
          case VerifyCodeStatus.failed:
            UIUtil.showToast(Lang.register_register_failed.tr());
            break;
        }
      } else if (_pbLoading.isShowing()) {
        _pbLoading.hide();
      }
    });
  }

  void checkUserDirection(VerifyCodeState state) {
    if (state.userInfo != null) {
      if (state.userInfo.hasFillPersonalization != 1) {
        if (isMVP) {
          NavigateUtil.openPage(context, MainScreen.routeName);
        } else {
          NavigateUtil.openPage(context, PersonalizationScreen.routeName);
        }
      } else {
        //User need fill personalization data
        NavigateUtil.replacePage(context, MainScreen.routeName,
            argument: state.userInfo);
      }
    }
  }

  @override
  void notifyError(String error) {
    hideLoading();
    super.notifyError(error);
  }

  @override
  Widget build(BuildContext context) {
    _pbLoading = ProgressDialog(context, showLogs: true);
    super.build(context);
    return makeParent(Container(
      color: const Color(0xffFDFBF5),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xffFDFBF5),
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                if (widget.comeFrom != null &&
                    widget.comeFrom == SplashScreen.routeName) {
                  _pbLoading.show();
                  _verifyCodeBloc.add(ClearUserAndBackToStartedScreen());
                } else {
                  NavigateUtil.pop(context);
                }
              },
            ),
            elevation: 0,
            backgroundColor: const Color(0xffFDFBF5),
            title: MyTextView(
              textStyle: textSmallxxx.copyWith(
                  color: Colors.black, fontWeight: FontWeight.bold),
              text: Lang.activate_account_activate_account.tr(),
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return BlocProvider(
                create: (_) => _verifyCodeBloc,
                child: BlocBuilder<VerifyCodeBloc, VerifyCodeState>(
                    builder: (context, state) {
                  return SingleChildScrollView(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: sizeNormal),
                    child: enterVerifyCode(state),
                  ));
                }),
              );
            },
          ),
        ),
      ),
    ));
  }

  Widget enterVerifyCode(VerifyCodeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MyTextView(
          text: Lang.activate_account_enter_the_6_digit_code_sent.tr(),
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
            text: Lang.activate_account_did_get_code.tr(),
            style: textSmallx,
            children: <TextSpan>[
              TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (state.timeResend == 0) {
                        _pbLoading.show();
                        _verifyCodeBloc.add(ResendCode());
                      }
                    },
                  text:
                      ' ${state.timeResend == 0 ? Lang.activate_account_resend_code.tr() : '${Lang.activate_account_resend_in.tr()} '
                          '${state.timeResend.toString()}'}',
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
            text: Lang.activate_account_resend_confirm.tr(),
            onTap: doSubmitPinCode,
            isFillParent: false,
            textStyle: textNormal.copyWith(color: Colors.white),
            buttonColor: const Color(0xff242655),
          ),
        ),
      ],
    );
  }

  /// Check validate pinCode data and submit to Server
  void doSubmitPinCode() {
    final code = pinCodeData;
    final errMessageCode = validateCodePassword(code);
    if (code.isNotEmpty && (errMessageCode?.isEmpty ?? true)) {
      _pbLoading.show();
      _verifyCodeBloc.add(SubmitVerifyCode(code));
    } else {
      UIUtil.showToast(Lang.forgot_password_invalid_did_code.tr());
    }
  }

  @override
  void dispose() {
    _verifyCodeBloc.close();
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if ((widget.email?.isNotEmpty ?? false) &&
        (widget.tokenCode?.isNotEmpty ?? false)) {
      /// this case if use come from Register Flow
      _verifyCodeBloc.add(StartCountDown());
    } else {
      /// this case if use come from Login Flow
      _verifyCodeBloc.add(ResendCode());
    }
  }
}
