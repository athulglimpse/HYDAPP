import 'package:after_layout/after_layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../common/constants.dart';
import '../../common/di/injection/injector.dart';
import '../../common/dialog/dialog_select_lang.dart';
import '../../common/localization/lang.dart';
import '../../common/theme/theme.dart';
import '../../common/widget/my_button.dart';
import '../../common/widget/my_indicator.dart';
import '../../common/widget/my_text_view.dart';
import '../../data/model/language.dart';
import '../../data/source/api_end_point.dart';
import '../../utils/navigate_util.dart';
import '../../utils/ui_util.dart';
import '../base/base_widget.dart';
import '../login/login_page.dart';
import '../main/main_page.dart';
import '../register_opt/register_opt_page.dart';
import 'bloc/bloc.dart';
import 'components/started_item.dart';

class StartedScreen extends BaseWidget {
  static const routeName = '/StartedScreen';

  StartedScreen();

  @override
  State<StatefulWidget> createState() {
    return StartedScreenState();
  }
}

class StartedScreenState extends BaseState<StartedScreen>
    with AfterLayoutMixin {
  final _indicatorState = GlobalKey<MyIndicatorState>();
  final StartedBloc _startedBloc = sl<StartedBloc>();
  ProgressDialog _pbLoading;
  PageController _controller;
  String buildVersion;

  @override
  void initState() {
    super.initState();
    //Call this method first when LoginScreen init
    initBasicInfo();
    _startedBloc.listen((state) {
      _pbLoading.hide();
      if (state is StartedState && state.guestLoginSuccess) {
        NavigateUtil.openPage(context, MainScreen.routeName);
      }
    });
  }

  Future<void> initBasicInfo() async {
    _controller = PageController(
      initialPage: 0,
      keepPage: false,
    );
    final packageInfo = await PackageInfo.fromPlatform();
    buildVersion = '${packageInfo.buildNumber} (${packageInfo.version})';
  }

  void showDialogSelectLang() {
    showDialog<Language>(
      context: context,
      builder: (BuildContext context) =>
          DialogSelectLang(arrLanguage: _startedBloc.state.arrLanguage),
    ).then(onSelectedLanguage);
  }

  void onSelectedLanguage(Language language) {
    if (_startedBloc.state.selectedLanguage != language.code) {
      _pbLoading.show();
      changeLang(language);
      _startedBloc.add(OnChangeLanguage(language: language));
    }
  }

  @override
  Widget build(BuildContext context) {
    _pbLoading = ProgressDialog(context, showLogs: true);
    _pbLoading.style(message: Lang.started_loading_please_wait.tr());
    return Scaffold(
      body: BlocProvider(
        create: (_) => _startedBloc,
        child:
            BlocBuilder<StartedBloc, StartedState>(builder: (context, state) {
          if (state.staticContent == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Stack(
            fit: StackFit.expand,
            children: [
              UIUtil.makeImageWidget(
                Res.bg_onboarding,
                boxFit: BoxFit.cover,
              ),
              PageView.builder(
                itemCount: state?.staticContent?.staticData?.length ?? 0,
                controller: _controller,
                clipBehavior: Clip.none,
                onPageChanged: (index) {
                  _startedBloc.add(OnIndexContentChange(index));
                  _indicatorState.currentState.pageChanged(index);
                },
                itemBuilder: (context, index) {
                  return StartedItem(
                      itemIntro: state.staticContent.staticData[index]);
                },
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(sizeSmall),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: sizeSmallxxx),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () => {showDialogSelectLang()},
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  UIUtil.makeImageWidget(
                                      state.selectedLanguage == PARAM_EN
                                          ? Res.en_flag
                                          : Res.ar_flag,
                                      width: sizeSmallxxx),
                                  const SizedBox(width: sizeVerySmall),
                                  MyTextView(
                                      text: state.selectedLanguage == PARAM_EN
                                          ? Lang.started_en_flag.tr()
                                          : Lang.started_ar_flag.tr(),
                                      textStyle: textSmallx.copyWith(
                                          color: Colors.white,
                                          fontWeight: MyFontWeight.semiBold,
                                          fontFamily: MyFontFamily.graphik)),
                                ],
                              ),
                            ),
                            MyTextView(
                                onTap: () {
                                  _pbLoading.show();
                                  _startedBloc.add(DoLoginAsGuest());
                                },
                                padding: const EdgeInsets.all(sizeSmall),
                                text: Lang.started_continues_as_guest.tr(),
                                textStyle: textSmallx.copyWith(
                                    color: Colors.white,
                                    fontWeight: MyFontWeight.medium,
                                    fontFamily: MyFontFamily.graphik))
                          ],
                        ),
                      ),
                      const Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.all(sizeNormal),
                            child: SizedBox(),
                          )),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            MyIndicator(
                              key: _indicatorState,
                              controller: _controller,
                              itemCount: state?.staticContent?.staticData?.length ?? 0,
                            ),
                            const SizedBox(height: sizeNormalx),
                            MyButton(
                              text: Lang.started_get_started.tr(),
                              onTap: () {
                                NavigateUtil.openPage(
                                    context, RegisterOptPage.routeName);
                              },
                              paddingHorizontal: sizeExLarge,
                              textStyle:
                                  textSmallxxx.copyWith(color: Colors.black),
                              buttonColor: Colors.white,
                            ),
                            const SizedBox(height: sizeNormalx),
                            Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                MyTextView(
                                  text:
                                      Lang.started_already_have_an_account.tr(),
                                  textStyle: textSmallx.copyWith(
                                      color: const Color.fromARGB(
                                          153, 255, 255, 255)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: sizeSmall),
                                  child: MyTextView(
                                    text: Lang.started_login.tr(),
                                    onTap: () {
                                      NavigateUtil.openPage(
                                          context, LoginPage.routeName);
                                    },
                                    textStyle: textSmallx.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                  right: sizeSmall,
                  bottom: sizeSmall,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: MyTextView(
                      text: buildVersion ?? '',
                      textStyle:
                          textSmallxx.copyWith(fontWeight: MyFontWeight.black),
                    ),
                  ))
            ],
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    _startedBloc.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _startedBloc.add(InitLang(context.locale.languageCode.toUpperCase()));
    _startedBloc.add(LoadStartedContent());
  }
}
