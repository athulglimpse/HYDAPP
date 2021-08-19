import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../common/di/injection/injector.dart';
import '../../common/dialog/dialog_select_lang.dart';
import '../../common/localization/lang.dart';
import '../../common/theme/theme.dart';
import '../../common/widget/my_text_view.dart';
import '../../data/model/language.dart';
import '../../utils/navigate_util.dart';
import '../base/base_widget.dart';
import '../change_password/change_password_page.dart';
import '../deactivate_account/deactivate_account_page.dart';
import '../legalandpolicy/legal_policy_page.dart';
import '../main/main_page.dart';
import 'bloc/block.dart';
import 'component/account_settings_card.dart';
import 'component/app_settings_card.dart';
import 'component/legal_policy_card.dart';
import 'component/map_setting_card.dart';

class SettingsPage extends BaseWidget {
  static const routeName = 'SettingPage';

  SettingsPage();

  @override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends BaseState<SettingsPage> with AfterLayoutMixin {
  final _settingsBloc = sl<SettingsBloc>();
  bool hasChangeLang = false;
  bool isAppleAvaiable = false;
  bool isGoogleAvaiable = false;
  bool isWazeAvaiable = false;
  ProgressDialog _pbLoading;

  @override
  void initState() {
    super.initState();
    initBasicInfo();
  }

  void initBasicInfo() {
    _settingsBloc.listen((state) {
      if(_pbLoading.isShowing()){
        _pbLoading.hide();
      }
    });
    _settingsBloc.add(LoadLanguage());
    _settingsBloc.add(FetchNotificationData());
  }

  @override
  Widget build(BuildContext context) {
    _pbLoading = ProgressDialog(context, showLogs: true);
    _pbLoading.style(message: Lang.started_loading_please_wait.tr());
    return Container(
      color: const Color(0xffFDFBF5),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (hasChangeLang) {
              NavigateUtil.openPage(context, MainScreen.routeName,
                  release: true);
              return Future(() => false);
            }
            return Future(() => true);
          },
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                iconSize: sizeSmallxxx,
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  if (hasChangeLang) {
                    NavigateUtil.openPage(context, MainScreen.routeName,
                        release: true);
                    return;
                  }
                  NavigateUtil.pop(context);
                },
              ),
              elevation: 0,
              backgroundColor: const Color(0xffffffff),
              title: MyTextView(
                textStyle: textNormal.copyWith(
                    color: Colors.black,
                    fontFamily: MyFontFamily.publicoBanner,
                    fontWeight: MyFontWeight.bold),
                text: Lang.more_settings.tr(),
              ),
            ),
            body: BlocProvider(
              create: (_) => _settingsBloc,
              child: BlocBuilder<SettingsBloc, SettingsState>(
                  builder: (context, state) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      color: const Color(0xffFDFBF5),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            AppSettingsCard(
                              showNotificationSetting:
                                  state?.userInfo?.isUser() ?? false,
                              isNotification: state.isNotification,
                              onClickLanguage: showDialogSelectLang,
                              onClickNotification: onChangeNotificationSetting,
                            ),
                            const SizedBox(
                              height: sizeNormalxx,
                            ),
                            if (state?.userInfo?.isUser() ?? false)
                              Column(
                                children: [
                                  AccountSettingsCard(
                                    showChangePassword: state?.userInfo?.isPassword() ?? false,
                                    onClickDeactivateAccount:
                                        onClickDeactivateAccount,
                                    onClickChangePassword:
                                        onClickChangePassword,
                                  ),
                                  const SizedBox(
                                    height: sizeNormalxx,
                                  ),
                                ],
                              ),
                            LegalPolicySettingsCard(
                              onClickItemCondition: () {
                                onClickItemCondition(state);
                              },
                              onClickItemPolicy: () {
                                onClickItemPolicy(state);
                              },
                            ),
                            const SizedBox(
                              height: sizeNormalxx,
                            ),
                            if (Platform.isIOS)
                              MapSettingCard(
                                isAppleAvaiable: isAppleAvaiable,
                                isGoogleAvaiable: isGoogleAvaiable,
                                isWazeAvaiable: isWazeAvaiable,
                                onClickAppleMap: (value) {
                                  _settingsBloc.add(OnSetAppleMapDefault());
                                },
                                onClickGoogleMap: (value) {
                                  _settingsBloc.add(OnSetGoogleMapDefault());
                                },
                                onClickWazeMap: (value) {
                                  _settingsBloc.add(OnSetWazeMapDefault());
                                },
                                appleMapValue: state.isAppleMapEnable,
                                googleMapValue: state.isGoogleMapEnable,
                                wazeMapValue: state.isWazeMapEnable,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _settingsBloc.close();
    super.dispose();
  }

  void showDialogSelectLang() {
    showDialog<Language>(
      context: context,
      builder: (BuildContext context) =>
          DialogSelectLang(arrLanguage: _settingsBloc.state.arrLanguage),
    ).then(onSelectedLanguage);
  }

  void onChangeNotificationSetting(bool value) {
    _settingsBloc.add(OnSubmitNotificationSetting(isNotification: value));
  }

  void onSelectedLanguage(Language language) {
    if (context.locale.languageCode.toUpperCase() != language.code) {
      _pbLoading.show();
      hasChangeLang = true;
      changeLang(language);
      _settingsBloc.add(OnChangeLanguage(language: language));
    }
  }

  void onClickDeactivateAccount() {
    NavigateUtil.openPage(context, DeactivateAccountPage.routeName);
  }

  void onClickChangePassword() {
    NavigateUtil.openPage(context, ChangePasswordScreen.routeName);
  }

  void onClickItemPolicy(SettingsState state) {
    NavigateUtil.openPage(context, LegalPolicyPage.routeName, argument: {
      'title': Lang.settings_privacy_policy.tr(),
      'html': state.staticContent.policyPrivacy,
    });
  }

  void onClickItemCondition(SettingsState state) {
    NavigateUtil.openPage(context, LegalPolicyPage.routeName, argument: {
      'title': Lang.settings_terms_and_conditions.tr(),
      'html': state.staticContent.termCondition,
    });
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    if (Platform.isIOS) {
      setState(() async {
        isAppleAvaiable = await MapLauncher.isMapAvailable(MapType.apple);
        isGoogleAvaiable = await MapLauncher.isMapAvailable(MapType.google);
        isWazeAvaiable = await MapLauncher.isMapAvailable(MapType.waze);
      });
    }
  }
}
