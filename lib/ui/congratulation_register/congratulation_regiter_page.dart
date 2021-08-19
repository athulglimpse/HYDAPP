import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:marvista/data/repository/config_repository.dart';
import 'package:marvista/data/source/api_end_point.dart';

import '../../common/constants.dart';
import '../../common/di/injection/injector.dart';
import '../../common/localization/lang.dart';
import '../../common/theme/theme.dart';
import '../../common/widget/my_button.dart';
import '../../common/widget/my_text_view.dart';
import '../../utils/navigate_util.dart';
import '../../utils/ui_util.dart';
import '../base/base_widget.dart';
import '../login/login_page.dart';
import '../main/main_page.dart';
import 'bloc/congratulation_regiter_bloc.dart';

class CongratulationRegisterScreen extends BaseWidget {
  static const routeName = 'CongratulationRegisterScreen';

  final CongratulationEnum congratulationEnum;

  CongratulationRegisterScreen(
      {this.congratulationEnum = CongratulationEnum.REGISTER});

  @override
  State<StatefulWidget> createState() {
    return CongratulationRegisterScreenState();
  }
}

class CongratulationRegisterScreenState
    extends BaseState<CongratulationRegisterScreen> {
  final _congratulationRegisterBloc = sl<CongratulationRegisterBloc>();
  final configRepository = sl<ConfigRepository>();
  @override
  void initState() {
    super.initState();
    //Call this method first when LoginScreen init
    initBasicInfo();
  }

  void initBasicInfo() {}

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () => Future(() => false),
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: UIUtil.makeImageDecoration(Res.default_bg_congrats),
                fit: BoxFit.fill,
              ),
            ),
            child: Stack(
              children: [
                if (widget.congratulationEnum == CongratulationEnum.HELP ||
                    widget.congratulationEnum == CongratulationEnum.REPORT ||
                    CongratulationEnum.ERROR == widget.congratulationEnum)
                  Positioned.fill(
                    right: sizeNormal,
                    top: sizeNormal,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          NavigateUtil.replacePage(
                              context, MainScreen.routeName);
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                          size: sizeNormalxx,
                        ),
                      ),
                    ),
                  ),
                getLayoutByCongratulationEnum(widget.congratulationEnum),
                if (CongratulationEnum.ERROR == widget.congratulationEnum)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: sizeNormalxx, bottom: sizeLarge),
                        child: MyButton(
                          minWidth: sizeImageLarge,
                          text: Lang.help_try_again.tr(),
                          onTap: () {
                            NavigateUtil.pop(context);
                          },
                          isFillParent: false,
                          textStyle: textNormal.copyWith(color: Colors.white),
                          buttonColor: const Color(0xff242655),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _congratulationRegisterBloc.close();
    super.dispose();
  }

  void onStartJourney() {
    NavigateUtil.replacePage(context, MainScreen.routeName);
  }

  void onChangePasswordSuccess() {
    NavigateUtil.openPage(context, LoginPage.routeName);
  }

  void onForgotPasswordSuccess() {
    NavigateUtil.replacePage(context, LoginPage.routeName);
  }

  Widget getLayoutByCongratulationEnum(CongratulationEnum congratulationEnum) {
    switch (congratulationEnum) {
      case CongratulationEnum.FORGOT_PASSWORD:
        return createForgotPassword();
      case CongratulationEnum.CHANGE_PASSWORD:
        return createChangePassword();
      case CongratulationEnum.REGISTER:
        return createRegister();
      case CongratulationEnum.ERROR:
        return createError();
      case CongratulationEnum.REPORT:
      case CongratulationEnum.HELP:
        return createHelp();
      default:
        return createRegister();
    }
  }

  Widget createForgotPassword() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.all(sizeNormalxxx),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(sizeSmall),
                  decoration: BoxDecoration(
                      color: const Color(0xff185D30),
                      borderRadius: BorderRadius.circular(sizeExLarge)),
                  child: const Icon(
                    Icons.check,
                    size: sizeLargexx,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: sizeLargexxx),
              MyTextView(
                text: Lang.congratulation_you_change_password.tr(),
                textStyle: textNormalxx.copyWith(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: sizeNormal),
              MyTextView(
                text: Lang
                    // ignore: lines_longer_than_80_chars
                    .congratulation_register_your_password_has_changed_successfully
                    .tr(),
                textStyle: textSmallx.copyWith(color: Colors.grey),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: sizeNormalxx, bottom: sizeSmall),
          child: MyButton(
            minWidth: sizeImageLarge,
            text: Lang.login_login.tr(),
            onTap: onForgotPasswordSuccess,
            isFillParent: false,
            textStyle: textNormal.copyWith(color: Colors.white),
            buttonColor: const Color(0xff242655),
          ),
        ),
      ],
    );
  }

  Widget createChangePassword() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.all(sizeNormalxxx),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(sizeSmall),
                  decoration: BoxDecoration(
                      color: const Color(0xff185D30),
                      borderRadius: BorderRadius.circular(sizeExLarge)),
                  child: const Icon(
                    Icons.check,
                    size: sizeLargexx,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: sizeLargexxx,
              ),
              MyTextView(
                text: Lang.congratulation_you_change_password.tr(),
                textStyle: textNormalxx.copyWith(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: sizeNormal,
              ),
              MyTextView(
                text: Lang
                    .congratulation_register_your_password_has_changed_successfully
                    .tr(),
                textStyle: textSmallx.copyWith(color: Colors.grey),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: sizeNormalxx, bottom: sizeSmall),
          child: MyButton(
            minWidth: sizeImageLarge,
            text: Lang.login_login.tr(),
            onTap: onChangePasswordSuccess,
            isFillParent: false,
            textStyle: textNormal.copyWith(color: Colors.white),
            buttonColor: const Color(0xff242655),
          ),
        ),
      ],
    );
  }

  Widget createRegister() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.all(sizeNormalxxx),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(sizeSmall),
                  decoration: BoxDecoration(
                      color: const Color(0xff185D30),
                      borderRadius: BorderRadius.circular(sizeExLarge)),
                  child: const Icon(
                    Icons.check,
                    size: sizeLargexx,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: sizeLargexxx,
              ),
              MyTextView(
                text: Lang
                    .congratulation_register_congratulation_you_created_your_profile
                    .tr(),
                textStyle: textNormalxx.copyWith(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: sizeNormal,
              ),
              MyTextView(
                text: Lang
                    .congratulation_register_now_you_can_start_your_journey_by
                    .tr(),
                textStyle: textSmallx.copyWith(color: Colors.grey),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: sizeNormalxx, bottom: sizeSmall),
          child: MyButton(
            minWidth: sizeImageLarge,
            text: Lang.congratulation_register_start_journey.tr(),
            onTap: onStartJourney,
            isFillParent: false,
            textStyle: textNormal.copyWith(color: Colors.white),
            buttonColor: const Color(0xff242655),
          ),
        ),
      ],
    );
  }

  Widget createHelp() {
    final appConfig = sl<ConfigRepository>().getAppConfig();
    var titleMess = Lang.help_message_sent_successfully.tr();
    var subTitleMess = Lang.help_thank_you_for_contacting_us.tr();
    if (widget.congratulationEnum == CongratulationEnum.REPORT &&
        appConfig.reportMessage != null) {
      if (context.locale.languageCode.toUpperCase() == PARAM_EN) {
        titleMess = appConfig.reportMessage.titleEn;
        subTitleMess = appConfig.reportMessage.contentEn;
      } else {
        titleMess = appConfig.reportMessage.titleAr;
        subTitleMess = appConfig.reportMessage.contentAr;
      }
    } else if (widget.congratulationEnum == CongratulationEnum.HELP &&
        appConfig.helpMessage != null) {
      if (context.locale.languageCode.toUpperCase() == PARAM_EN) {
        titleMess = appConfig.helpMessage.titleEn;
        subTitleMess = appConfig.helpMessage.contentEn;
      } else {
        titleMess = appConfig.helpMessage.titleAr;
        subTitleMess = appConfig.helpMessage.contentAr;
      }
    }
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.all(sizeNormalxxx),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(sizeSmall),
                  decoration: BoxDecoration(
                      color: const Color(0xff185D30),
                      borderRadius: BorderRadius.circular(sizeExLarge)),
                  child: const Icon(
                    Icons.check,
                    size: sizeLargexx,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: sizeLargexxx,
              ),
              MyTextView(
                text: titleMess,
                textStyle: textNormalxx.copyWith(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: sizeNormal,
              ),
              MyTextView(
                text: Lang.help_thank_you.tr(),
                textStyle: textSmallx.copyWith(color: Colors.black),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget createError() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.all(sizeNormalxxx),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(sizeSmall),
                  decoration: BoxDecoration(
                      color: Colors.red[700],
                      borderRadius: BorderRadius.circular(sizeExLarge)),
                  child: const Icon(
                    Icons.close_rounded,
                    size: sizeLargexx,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: sizeLargexxx,
              ),
              MyTextView(
                text: Lang.help_error_sending_message.tr(),
                textStyle: textNormalxx.copyWith(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: sizeNormal,
              ),
              MyTextView(
                text: Lang.help_we_have_encountered_an_error_please_try.tr(),
                textStyle: textSmallx.copyWith(color: Colors.black),
              )
            ],
          ),
        ),
      ],
    );
  }
}

enum CongratulationEnum {
  FORGOT_PASSWORD,
  CHANGE_PASSWORD,
  REGISTER,
  HELP,
  REPORT,
  ERROR
}
