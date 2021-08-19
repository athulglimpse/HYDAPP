import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../common/di/injection/injector.dart';
import '../../common/localization/lang.dart';
import '../../common/theme/theme.dart';
import '../../common/widget/my_text_view.dart';
import '../../data/source/api_end_point.dart';
import '../../utils/app_const.dart';
import '../../utils/firebase_wrapper.dart';
import '../../utils/my_custom_route.dart';
import '../../utils/navigate_util.dart';
import '../../utils/ui_util.dart';
import '../base/base_widget.dart';
import '../congratulation_register/congratulation_regiter_page.dart';
import '../legalandpolicy/legal_policy_page.dart';
import '../main/main_page.dart';
import '../personalization/personalization_page.dart';
import '../register/register_page.dart';
import '../register/util/register_util.dart';
import 'bloc/bloc.dart';
import 'bloc/register_opt_bloc.dart';

part 'register_otp_action.dart';

class RegisterOptPage extends BaseWidget {
  static const routeName = 'RegisterOptPage';
  @override
  _RegisterOptPageState createState() => _RegisterOptPageState();
}

class _RegisterOptPageState extends BaseState<RegisterOptPage> {
  final _registerOptBloc = sl<RegisterOptBloc>();
  final _firebaseWrapper = sl<FirebaseWrapper>();
  ProgressDialog _pbLoading;

  @override
  void initState() {
    super.initState();
    _registerOptBloc.listen((state) {
      if (state.registerStatus != null) {
        _pbLoading.hide();
        FocusScope.of(context).requestFocus(FocusNode());
        switch (state.registerStatus) {
          case RegisterStatus.registerSuccess:
            break;
          case RegisterStatus.getProfileSuccess:
            if (state.userInfo.hasFillPersonalization == 0) {
              if (isMVP) {
                NavigateUtil.openPage(
                    context, CongratulationRegisterScreen.routeName, argument: {
                  RouteArgument.type: CongratulationEnum.REGISTER
                });
              } else {
                NavigateUtil.openPage(context, PersonalizationScreen.routeName);
              }
              return;
            }
            NavigateUtil.openPage(context, MainScreen.routeName);
            break;
          case RegisterStatus.alreadyRegister:
            //NavigateUtil.replacePage(context, LoginPage.routeName);
            UIUtil.showToast(Lang.register_sign_up_success.tr());
            return;
          case RegisterStatus.failed:
            UIUtil.showToast(Lang.register_register_failed.tr());
            break;
          default:
        }
      }
    });
    _registerOptBloc.add(LoadCountryCode());
  }

  @override
  Widget build(BuildContext context) {
    _pbLoading = ProgressDialog(context, showLogs: true);
    _pbLoading.style(message: Lang.started_loading_please_wait.tr());

    return Container(
      color: const Color(0xffFDFBF5),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
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
              textStyle: textNormal.copyWith(
                  color: Colors.black, fontWeight: FontWeight.bold),
              text: Lang.login_glad_to_meet_you.tr(),
            ),
          ),
          body: LayoutBuilder(
            builder: buildScreen,
          ),
        ),
      ),
    );
  }

  BlocProvider<RegisterOptBloc> buildScreen(
      BuildContext context, BoxConstraints constraints) {
    return BlocProvider(
      create: (_) => _registerOptBloc,
      child: Container(
        child: BlocBuilder<RegisterOptBloc, RegisterOptState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(sizeLarge),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Material(
                    elevation: sizeVerySmall,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(sizeNormalx)),
                    color: const Color(0xff3B5998),
                    child: InkWell(
                      onTap: () {
                        _handleFacebookSignIn(state);
                      },
                      splashColor: Colors.white.withAlpha(100),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(sizeNormalx)),
                      child: Container(
                          padding: const EdgeInsets.only(
                              left: sizeNormal, right: sizeSmall),
                          height: sizeLargexx,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              MyTextView(
                                text: Lang.login_sign_up_with_facebook.tr(),
                                textStyle:
                                    textSmallxxx.copyWith(color: Colors.white),
                              ),
                              RawMaterialButton(
                                constraints: const BoxConstraints(
                                    maxWidth: sizeNormalx,
                                    maxHeight: sizeNormalx,
                                    minWidth: sizeNormalx,
                                    minHeight: sizeNormalx),
                                fillColor: Colors.white,
                                shape: const CircleBorder(),
                                onPressed: () {},
                                child: const FaIcon(
                                  FontAwesomeIcons.facebookF,
                                  size: sizeSmallxxx,
                                  color: Color(0xff929292),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                  const SizedBox(height: sizeNormal),
                  Material(
                    elevation: sizeVerySmall,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(sizeNormalx)),
                    color: const Color(0xff4885ED),
                    child: InkWell(
                      onTap: () {
                        _handleGoogleSignIn(state);
                      },
                      splashColor: Colors.white.withAlpha(100),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(sizeNormalx)),
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: sizeNormal, right: sizeSmall),
                        height: sizeLargexx,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            MyTextView(
                              text: Lang.login_sign_up_with_google.tr(),
                              textStyle:
                                  textSmallxxx.copyWith(color: Colors.white),
                            ),
                            RawMaterialButton(
                              onPressed: () {},
                              constraints: const BoxConstraints(
                                  maxWidth: sizeNormalx,
                                  maxHeight: sizeNormalx,
                                  minWidth: sizeNormalx,
                                  minHeight: sizeNormalx),
                              fillColor: Colors.white,
                              shape: const CircleBorder(),
                              child: const FaIcon(
                                FontAwesomeIcons.google,
                                size: sizeSmallxxx,
                                color: Color(0xffD8D8D8),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: sizeNormal),
                  if (Platform.isIOS)
                    Material(
                      elevation: sizeVerySmall,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(sizeNormalx)),
                      color: Colors.black,
                      child: InkWell(
                        onTap: () {
                          _handleAppleSignIn(state);
                        },
                        splashColor: Colors.white.withAlpha(100),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(sizeNormalx)),
                        child: Container(
                            padding: const EdgeInsets.only(
                                left: sizeNormal, right: sizeSmall),
                            height: sizeLargexx,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                MyTextView(
                                  text: Lang.login_sign_up_with_apple.tr(),
                                  textStyle: textSmallxxx.copyWith(
                                      color: Colors.white),
                                ),
                                RawMaterialButton(
                                  onPressed: () {},
                                  constraints: const BoxConstraints(
                                      maxWidth: sizeNormalx,
                                      maxHeight: sizeNormalx,
                                      minWidth: sizeNormalx,
                                      minHeight: sizeNormalx),
                                  fillColor: Colors.white,
                                  shape: const CircleBorder(),
                                  child: const FaIcon(
                                    FontAwesomeIcons.apple,
                                    size: sizeNormal,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            )),
                      ),
                    ),
                  if (Platform.isIOS) const SizedBox(height: sizeNormalxx),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MyTextView(
                        text: Lang.login_or.tr(),
                        textStyle:
                            textNormal.copyWith(color: const Color(0x804A4A4A)),
                      ),
                    ],
                  ),
                  const SizedBox(height: sizeNormalxx),
                  Material(
                    elevation: sizeVerySmall,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(sizeNormalx)),
                    color: const Color(0xff212237),
                    child: InkWell(
                      onTap: () {
                        NavigateUtil.openPage(context, RegisterPage.routeName,
                            argument: {'type': RegisterEnum.EMAIL});
                      },
                      splashColor: Colors.white.withAlpha(100),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(sizeNormalx)),
                      child: Container(
                          padding: const EdgeInsets.only(
                              left: sizeNormal, right: sizeSmall),
                          height: sizeLargexx,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: (context.locale.languageCode
                                            .toUpperCase() ==
                                        PARAM_EN)
                                    ? MyTextView(
                                        textAlign: TextAlign.start,
                                        text:
                                            Lang.login_sign_up_with_email.tr(),
                                        textStyle: textSmallxxx.copyWith(
                                            color: Colors.white),
                                      )
                                    : FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: MyTextView(
                                          textAlign: TextAlign.start,
                                          text: Lang.login_sign_up_with_email
                                              .tr(),
                                          textStyle: textSmallxxx.copyWith(
                                              color: Colors.white),
                                        ),
                                      ),
                              ),
                              RawMaterialButton(
                                onPressed: () {},
                                constraints: const BoxConstraints(
                                    maxWidth: sizeNormalx,
                                    maxHeight: sizeNormalx,
                                    minWidth: sizeNormalx,
                                    minHeight: sizeNormalx),
                                fillColor: Colors.transparent,
                                shape: const CircleBorder(),
                                child: const FaIcon(
                                  Icons.mail,
                                  size: sizeNormal,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          )),
                    ),
                  ),
                  const SizedBox(height: sizeNormalxx),
                  GestureDetector(
                    onTap: () {
                      NavigateUtil.openPage(context, LegalPolicyPage.routeName,
                          argument: {
                            'title': Lang.settings_privacy_policy.tr(),
                            'html': state.staticContent.policyPrivacy,
                          });
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: Lang.login_by_registering_you_agree_with_the.tr(),
                        style: textSmallx.copyWith(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: Lang.login_application_policy.tr(),
                              style: textSmallx.copyWith(
                                color: const Color(0xff212237),
                                fontFamily: MyFontFamily.graphik,
                                fontWeight: MyFontWeight.medium,
                                decoration: TextDecoration.underline,
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _registerOptBloc.close();
    super.dispose();
  }
}
