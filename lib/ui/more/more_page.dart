import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/constants.dart';
import '../../common/di/injection/injector.dart';
import '../../common/localization/lang.dart';
import '../../common/theme/theme.dart';
import '../../common/widget/my_text_view.dart';
import '../../data/model/more_item.dart';
import '../../utils/navigate_util.dart';
import '../base/base_widget.dart';
import '../getstarted/get_started_page.dart';
import '../help/help_page.dart';
import '../profile/profile_page.dart';
import '../setting/settings_page.dart';
import 'bloc/more_bloc.dart';
import 'const_items.dart';
import 'util/more_util.dart';

class MoreScreen extends BaseWidget {
  static const routeName = '/MoreScreen';

  MoreScreen();

  @override
  State<StatefulWidget> createState() {
    return MoreScreenState();
  }
}

class MoreScreenState extends BaseState<MoreScreen>
    with AutomaticKeepAliveClientMixin {
  final MoreBloc _moreBloc = sl<MoreBloc>();
  final List<MoreItem> moreItems = constMoreItems;
  final List<MoreItem> moreItemsForGuest = constMoreItemsForGuest;

  @override
  void initState() {
    super.initState();
    //Call this method first when LoginScreen init
    initBasicInfo();
  }

  void initBasicInfo() {
    _moreBloc.listen((state) {
      if (state is LogoutSuccess) {
        NavigateUtil.openPage(context, StartedScreen.routeName, release: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => _moreBloc,
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: BlocBuilder<MoreBloc, MoreState>(
            builder: (context, state) {
              return Column(
                children: <Widget>[
                  MyTextView(
                    text: Lang.more_more.tr(),
                    textStyle: textNormal.copyWith(color: Colors.black),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: sizeNormal,
                          right: sizeNormal,
                          bottom: sizeLarge),
                      child: Column(
                        children: (state.userInfo?.isUser() ?? false
                                ? moreItems
                                : moreItemsForGuest)
                            .asMap()
                            .map(
                              (index, e) => MapEntry(
                                index,
                                InkWell(
                                  onTap: () {
                                    onClickItemMenu(e);
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          SizedBox(
                                              width: sizeLarge,
                                              height: sizeLarge,
                                              child: SvgPicture.asset(
                                                  e.image.toString(),
                                                  fit: BoxFit.contain)),
                                          const SizedBox(width: sizeNormal),
                                          MyTextView(
                                            text: e.name,
                                            textStyle: textSmallxxx.copyWith(
                                                color: const Color(0xff212237),
                                                fontFamily:
                                                    MyFontFamily.graphik,
                                                fontWeight:
                                                    MyFontWeight.medium),
                                          )
                                        ],
                                      ),
                                      index == moreItems.length - 1
                                          ? const SizedBox()
                                          : const Padding(
                                              padding: EdgeInsets.only(
                                                  left: sizeLargexxx,
                                                  bottom: sizeSmall),
                                              child: Divider(
                                                  color: Colors.grey,
                                                  height: 1),
                                            )
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .values
                            .toList(),
                      ),
                    ),
                  ),
                  const Divider(height: 1, color: Colors.grey),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: sizeNormal, vertical: sizeNormal),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MyTextView(
                          text: Lang.more_follow_us_on_social_media.tr(),
                          textStyle: textNormal.copyWith(color: Colors.black),
                        ),
                        const SizedBox(height: sizeNormal),
                        Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              Res.icon_facebook,
                              fit: BoxFit.fill,
                              width: sizeNormalxx,
                              height: sizeNormalxx,
                            ),
                            const SizedBox(width: sizeSmall),
                            SvgPicture.asset(
                              Res.icon_insta,
                              fit: BoxFit.fill,
                              width: sizeNormalxx,
                              height: sizeNormalxx,
                            ),
                            const SizedBox(width: sizeSmall),
                            SvgPicture.asset(
                              Res.icon_twitter,
                              fit: BoxFit.fill,
                              width: sizeNormalxx,
                              height: sizeNormalxx,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Colors.grey),
                  Expanded(
                    flex: 1,
                    child: Container(
                        color: const Color(0xffFDFBF5), height: sizeExLargexxx),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _moreBloc.close();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void onClickItemMenu(MoreItem e) {
    switch (e.id) {
      case MORE_KEY_PROFILE:
        NavigateUtil.openPage(context, ProfilePage.routeName);
        break;
      case MORE_KEY_SETTINGS:
        NavigateUtil.openPage(context, SettingsPage.routeName);
        break;
      case MORE_KEY_HELP:
        NavigateUtil.openPage(context, HelpPage.routeName);
        break;
      case MORE_KEY_LOGOUT:
        _moreBloc.add(Logout());
        break;
      default:
        break;
    }
  }
}
