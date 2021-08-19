import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/constants.dart';
import '../../common/di/injection/injector.dart';
import '../../common/dialog/menu_profile_dialog.dart';
import '../../common/localization/lang.dart';
import '../../common/theme/theme.dart';
import '../../common/widget/my_text_view.dart';
import '../../data/model/more_item.dart';
import '../../data/model/user_info.dart';
import '../../utils/firebase_wrapper.dart';
import '../../utils/navigate_util.dart';
import '../../utils/ui_util.dart';
import '../base/base_widget.dart';
import '../base/bloc/base_bloc.dart';
import '../getstarted/get_started_page.dart';
import '../help/help_page.dart';
import '../my_community/my_community_page.dart';
import '../save_item/save_item_page.dart';
import '../setting/settings_page.dart';
import 'bloc/bloc.dart';
import 'component/profile_info_card.dart';
import 'component/profile_info_card_for_guest.dart';
import 'const_items.dart';
import 'util/more_util.dart';

class ProfilePage extends BaseWidget {
  static const routeName = 'ProfilePage';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends BaseState<ProfilePage> {
  final ProfileBloc _profileBloc = sl<ProfileBloc>();
  final List<MoreItem> moreItems = constMoreItems;
  final List<MoreItem> moreItemsForGuest = constMoreItemsForGuest;

  @override
  void initState() {
    super.initState();
    _profileBloc.listen((state) {
      if (state is LogoutSuccess) {
        NavigateUtil.openPage(context, StartedScreen.routeName, release: true);
      }
      if (state.status == ProfileStatus.SUCCESS) {
        sl<BaseBloc>().add(OnProfileChange());
      }
    });
    _profileBloc.add(LoadCountryCode());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final paddingTop = (_profileBloc.state.userInfo?.isUser() ?? false)
        ? sizeLargexxx
        : sizeImageNormalx;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    return BlocProvider(
      create: (_) => _profileBloc,
      child: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Scaffold(
              body: Container(
                color: const Color.fromARGB(255, 250, 251, 243),
                child: Stack(
                  children: [
                    BlocBuilder<ProfileBloc, ProfileState>(
                        buildWhen: (previousState, currentState) {
                      return previousState?.userInfo?.photo?.url !=
                          currentState?.userInfo?.photo?.url;
                    }, builder: (context, state) {
                      return SizedBox(
                        height: constraints.maxHeight * 0.6,
                        child: UIUtil.makeImageWidget(
                          state?.userInfo?.photo?.url ?? Res.bg_profile_guest,
                          boxFit: BoxFit.cover,
                          width: constraints.maxWidth,
                        ),
                      );
                    }),
                    if (state.userInfo?.isUser() ?? false) renderHeader(state),
                    DraggableScrollableSheet(
                        maxChildSize: 0.85,
                        initialChildSize: 0.75,
                        minChildSize: 0.6,
                        builder: (context, scrollController) {
                          return SingleChildScrollView(
                            padding: EdgeInsets.only(
                                bottom: bottomPadding + sizeLargexxx),
                            controller: scrollController,
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: paddingTop),
                                  padding:
                                      const EdgeInsets.only(top: sizeLarge),
                                  decoration: const BoxDecoration(
                                      color: Color(0xffFDFBF5),
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(sizeNormalxx))),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const SizedBox(height: sizeNormalxx),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: sizeNormalxxx,
                                            right: sizeNormalxxx),
                                        child: Column(
                                            children:
                                                (state.userInfo?.isUser() ??
                                                            false
                                                        ? moreItems
                                                        : moreItemsForGuest)
                                                    .asMap()
                                                    .map((index, e) => MapEntry(
                                                        index,
                                                        itemSetting(
                                                            e, index, state)))
                                                    .values
                                                    .toList()),
                                      ),
                                      const Divider(
                                          color: Colors.grey, height: 1),
                                      bottomSocial(),
                                    ],
                                  ),
                                ),
                                if (state.userInfo?.isUser() ?? false)
                                  ProfileInfoCard(
                                    state: state,
                                  )
                                else
                                  ProfileInfoCardForGuest(
                                    state: state,
                                  ),
                              ],
                            ),
                          );
                        }),

                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget renderHeader(ProfileState state) {
    return SafeArea(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              showDialogMenu(state.userInfo, state);
            },
            child: Container(
              width: sizeNormalxxx,
              height: sizeNormalxxx,
              margin: const EdgeInsets.only(
                  right: sizeSmall, top: sizeSmall, left: sizeSmall),
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(
                        width: 1.0,
                        color: Colors.white,
                      ),
                      left: BorderSide(
                        width: 1.0,
                        color: Colors.white,
                      ),
                      right: BorderSide(
                        width: 1.0,
                        color: Colors.white,
                      ),
                      bottom: BorderSide(
                        width: 1.0,
                        color: Colors.white,
                      )),
                  borderRadius:
                      BorderRadius.all(Radius.circular(sizeNormalxxx))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.fiber_manual_record_sharp,
                    color: Colors.white,
                    size: sizeVerySmall,
                  ),
                  SizedBox(
                    width: sizeIcon,
                  ),
                  Icon(
                    Icons.fiber_manual_record_sharp,
                    color: Colors.white,
                    size: sizeVerySmall,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void showDialogMenu(UserInfo userInfo, ProfileState state) {
    showModalBottomSheet(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(sizeNormal),
                topRight: Radius.circular(sizeNormal)),
          ),
          child: BlocProvider.value(
            value: _profileBloc,
            child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return MenuProfileDialog(
                    userInfo: userInfo,
                    profileBloc: _profileBloc,
                    state: state,
                  );
                },
              );
            }),
          ),
        ),
      ),
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
    ).then((value) {
      _profileBloc.add(ClearPhotoState());
    });
  }

  Future<void> onClickItemMenu(MoreItem e) async {
    switch (e.id) {
      case MORE_KEY_SETTINGS:
        await NavigateUtil.openPage(context, SettingsPage.routeName);
        break;
      case MORE_KEY_SAVE_ITEMS:
        await NavigateUtil.openPage(context, SaveItemPage.routeName);
        break;
      case MORE_KEY_HELP:
        await NavigateUtil.openPage(context, HelpPage.routeName);
        break;
      case MORE_KEY_POST_AND_REVIEW:
        await NavigateUtil.openPage(context, MyCommunityPage.routeName);
        break;
      case MORE_KEY_LOGOUT:
        if (_profileBloc.state.userInfo.isUser()) {
          final firebaseWrapper = sl<FirebaseWrapper>();
          await firebaseWrapper.signOut();
        }
        sl<BaseBloc>().add(Logout());
        break;
      default:
        break;
    }
  }

  Widget itemSetting(MoreItem e, int index, ProfileState state) {
    return InkWell(
      key: Key(e.id),
      onTap: () {
        onClickItemMenu(e);
      },
      child: Container(
        color: const Color.fromARGB(255, 250, 251, 243),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                    width: sizeLarge,
                    height: sizeLarge,
                    padding: const EdgeInsets.all(sizeVerySmall),
                    child: SvgPicture.asset(e.image.toString(),
                        fit: BoxFit.contain)),
                const SizedBox(
                  width: sizeNormal,
                ),
                MyTextView(
                  text: e.name.tr(),
                  textStyle: textSmallxxx.copyWith(
                    color: const Color(0xff212237),
                    fontFamily: MyFontFamily.graphik,
                    fontWeight: MyFontWeight.medium,
                  ),
                )
              ],
            ),
            index ==
                    (state.userInfo?.isUser() ?? false
                                ? moreItems
                                : moreItemsForGuest)
                            .length -
                        1
                ? const SizedBox()
                : const Padding(
                    padding: EdgeInsets.only(
                      left: sizeLargexxx,
                      bottom: sizeSmall,
                    ),
                    child: Divider(color: Colors.grey, height: 1),
                  )
          ],
        ),
      ),
    );
  }

  Widget bottomSocial() {
    return Padding(
      padding: const EdgeInsets.only(
          top: sizeSmall, left: sizeNormalxxx, right: sizeNormalxxx),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyTextView(
            text: Lang.more_follow_us_on_social_media.tr(),
            textStyle: textNormal,
          ),
          const SizedBox(height: sizeNormal),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  await launch('https://www.facebook.com/alhudayriyatIsland/');
                },
                child: SvgPicture.asset(
                  Res.icon_facebook,
                  fit: BoxFit.fill,
                  width: sizeNormalxx,
                  height: sizeNormalxx,
                ),
              ),
              const SizedBox(width: sizeSmallxxx),
              GestureDetector(
                onTap: () async {
                  await launch(
                      'https://www.instagram.com/hudayriyat.island/?hl=en');
                },
                child: SvgPicture.asset(
                  Res.icon_insta,
                  fit: BoxFit.fill,
                  width: sizeNormalxx,
                  height: sizeNormalxx,
                ),
              ),
              const SizedBox(width: sizeSmallxxx),
              GestureDetector(
                onTap: () async {
                  await launch('https://twitter.com/alhudayriyatad?lang=en');
                },
                child: SvgPicture.asset(
                  Res.icon_twitter,
                  fit: BoxFit.fill,
                  width: sizeNormalxx,
                  height: sizeNormalxx,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }

  bool get wantKeepAlive => true;
}
