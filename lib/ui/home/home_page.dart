import 'dart:async';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:location/location.dart';
import 'package:marvista/common/widget/my_button.dart';
import 'package:marvista/common/widget/my_social_media.dart';
import 'package:marvista/data/source/api_end_point.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../common/constants.dart';
import '../../common/di/injection/injector.dart';
import '../../common/dialog/cupertino_picker_photo.dart';
import '../../common/dialog/experiences_dialog.dart';
import '../../common/dialog/filter_tool_dialog.dart';
import '../../common/localization/lang.dart';
import '../../common/theme/theme.dart';
import '../../common/widget/auto_hide_keyboard.dart';
import '../../common/widget/input_field_rect.dart';
import '../../common/widget/my_listview.dart';
import '../../common/widget/my_text_view.dart';
import '../../common/widget/search_empty_widget.dart';
import '../../data/model/activity_model.dart';
import '../../data/model/area_item.dart';
import '../../data/model/community_model.dart';
import '../../data/model/events.dart';
import '../../data/model/places_model.dart';
import '../../utils/app_const.dart';
import '../../utils/location_wrapper.dart';
import '../../utils/my_custom_route.dart';
import '../../utils/navigate_util.dart';
import '../../utils/ui_util.dart';
import '../assets/asset_detail/asset_detail_page.dart';
import '../assets/asset_see_all/asset_see_all_grid_page.dart';
import '../assets/asset_see_all/asset_see_all_list_page.dart';
import '../base/base_widget.dart';
import '../base/bloc/base_bloc.dart';
import '../community/community_detail/community_detail_page.dart';
import '../community/community_post_photo/community_post_photo_page.dart';
import '../community/community_see_all/community_see_all_page.dart';
import '../community/community_write_review/community_write_review_page.dart';
import '../event/detail/event_detail_page.dart';
import '../filter/filter_page.dart';
import '../login/login_page.dart';
import '../notification_history/notification_history_page.dart';
import '../weekend_activity/detail/weekend_activity_detail_page.dart';
import '../weekend_activity/see_all/weekend_activity_see_all_page.dart';
import 'bloc/home_bloc.dart';
import 'components/community_list.dart';
import 'components/events_list.dart';
import 'components/fancy_fab_view.dart';
import 'components/short_list_assets.dart';
import 'components/weather_widget.dart';
import 'components/weekend_activities_list.dart';
import 'search/bloc/homesearch_bloc.dart';
import 'search/search_widget.dart';

part 'home_action.dart';

class HomePage extends BaseWidget {
  static const String routeName = 'HomePage';
  final Function onClickSeeAllEvent;

  HomePage({Key key, this.onClickSeeAllEvent}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BaseState<HomePage> with AfterLayoutMixin {
  final GlobalKey keyHeader = GlobalKey();
  final RefreshController refreshController = RefreshController();
  final HomeBloc _homeBloc = sl<HomeBloc>();
  final BaseBloc _baseBloc = sl<BaseBloc>();
  final HomeSearchBloc _homeSearchBloc = sl<HomeSearchBloc>();
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _controllerSearch = TextEditingController();
  final StreamController<LocationData> _streamController = StreamController();
  final locationWrapper = sl<LocationWrapper>();
  var _isSearchForcus = false;

  void onFocusInputSearch() {
    _isSearchForcus = !_isSearchForcus;

    if (_isSearchForcus && _controllerSearch.text.isEmpty) {
      _homeSearchBloc.add(FocusFieldSearchEvent(
        _searchFocusNode.hasFocus,
        _homeBloc.state.listTrending,
        experienceId: _homeBloc.state?.currentArea?.id ?? 0,
      ));
    } else {
      if (_homeSearchBloc.state is HomeSearchDisplayed) {
      } else {
        _homeSearchBloc.add(ClearSearchEvent());
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _baseBloc.add(FetchUserProfile());
    _homeBloc.add(FetchAllData());
    //_homeBloc.add(FetchWeatherInfo('10.782560', '106.697497'));

    _searchFocusNode.addListener(onFocusInputSearch);
    _homeBloc.listen((state) {
      if (refreshController.isRefresh) {
        refreshController.refreshCompleted();
      } else if (state.homeRoute == HomeRoute.enterAssetDetailPage) {
        _homeBloc.add(EnterHomePage());
        NavigateUtil.openPage(context, AssetDetailScreen.routeName, argument: {
          state.assetDetail != null ? 'data' : state.assetDetail: null,
          state.assetDetail != null ? null : 'id': state.assetDetailId
        });
      } else if (state.homeRoute == HomeRoute.enterEventDetailPage) {
        _homeBloc.add(EnterHomePage());
        NavigateUtil.openPage(context, EventDetailScreen.routeName, argument: {
          state.eventDetailInfo != null ? 'data' : state.eventDetailInfo: null,
          state.eventDetailInfo != null ? null : 'id': state.assetDetailId
        });
      }
    });

    locationWrapper.addListener(_streamController);
    _streamController.stream.listen((location) {
      if (location != null) {
        _homeBloc.add(FetchWeatherInfo(
            location.latitude.toString(), location.longitude.toString()));
      }
    });
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    await initLocationService().then((locationData) {
      if (locationData != null) {
        _homeBloc.add(FetchWeatherInfo(locationData.latitude.toString(),
            locationData.longitude.toString()));
      }
    });
  }

  @override
  void dispose() {
    _homeBloc.close();
    _streamController.close();
    _homeSearchBloc.close();
    refreshController.dispose();
    _searchFocusNode.dispose();
    _controllerSearch.dispose();
    super.dispose();
  }

  Future<LocationData> initLocationService() async {
    if (Platform.isIOS) {
      final hasPermission = await locationWrapper.requestPermission();
      if (!hasPermission) {
        return null;
      }
    }
    final locationData = await locationWrapper.locationData();
    return locationData;
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    super.build(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (_) => _homeBloc,
        ),
        BlocProvider.value(
          value: _baseBloc,
        ),
        BlocProvider<HomeSearchBloc>(
          create: (_) => _homeSearchBloc,
        ),
      ],
      child: WillPopScope(
        onWillPop: () {
          if (_homeSearchBloc.state is HomeSearchDisplayed) {
            onClearSearch();
          }

          return Future(() => false);
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: AutoHideKeyboard(
              child: LayoutBuilder(builder: (context, constraints) {
                return BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                  return Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: UIUtil.makeImageDecoration(
                                state?.currentArea?.background ??
                                    Res.default_bg))),
                    child: homeContent(state, _baseBloc.state, constraints),
                  );
                });
              }),
            ),
          ),
          resizeToAvoidBottomInset: false,
          floatingActionButton: isMVP
              ? const SizedBox()
              : customFloatButton(context, bottomPadding),
        ),
      ),
    );
  }

  Widget customFloatButton(BuildContext context, double bottomPadding) {
    return SpeedDial(
      marginRight: sizeSmallxxx,
      marginBottom: bottomPadding + sizeExLarge,
      languageCode: context.locale.languageCode.toUpperCase(),
      animatedIconTheme:
          const IconThemeData(size: sizeNormalx, color: Color(0xff212237)),
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: const Color(0xff212237),
      overlayOpacity: 0.8,
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: const Color(0xff314697),
      foregroundColor: const Color(0xff212237),
      elevation: sizeVerySmallx,
      shape: const CircleBorder(),
      children: [
        SpeedDialChild(
          child: SvgPicture.asset(Res.icon_edit, fit: BoxFit.contain),
          backgroundColor: const Color(0xff212237),
          labelBackgroundColor: const Color(0xff212237),
          label: Lang.home_write_review_menu.tr(),
          labelStyle: const TextStyle(
              fontSize: sizeSmallxx,
              color: Colors.white,
              fontFamily: MyFontFamily.graphik,
              fontWeight: MyFontWeight.regular),
          onTap: () {
            onWriteReview();
          },
        ),
        SpeedDialChild(
            child: SvgPicture.asset(Res.icon_camera, fit: BoxFit.contain),
            backgroundColor: const Color(0xff212237),
            labelBackgroundColor: const Color(0xff212237),
            label: Lang.home_post_photos_menu.tr(),
            labelStyle: const TextStyle(
                fontSize: sizeSmallxx,
                color: Colors.white,
                fontFamily: MyFontFamily.graphik,
                fontWeight: MyFontWeight.regular),
            onTap: () {
              if (_baseBloc.state.userInfo != null &&
                  _baseBloc.state.userInfo.isUser()) {
                checkPermissionCamera();
              } else {
                NavigateUtil.openPage(context, LoginPage.routeName);
              }
            }),
      ],
    );
  }

  Widget activitiesAndCommunity(HomeState state) {
    // if (!(state?.amenities != null && state.amenities.isNotEmpty) &&
    //     !(state?.communityModel?.trendingPost != null &&
    //         state.communityModel.trendingPost.isNotEmpty)) {
    //   return const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }
    return Column(
      children: [
        if (!isMVP && state?.activities != null && state.activities.isNotEmpty)
          WeekendActivitiesList(
            padding: const EdgeInsets.only(
                left: sizeSmallxxx, top: sizeLargexx, right: sizeSmallxxx),
            onClickSeeAll: openSeeAllActivities,
            onItemClick: onClickActivity,
            activities: (state?.activities ?? []).length > 10
                ? state.activities.sublist(0, 10)
                : state.activities,
            isShowAll: state.activities.length > 10,
          ),
        if (!isMVP &&
            state?.communityModel?.trendingPost != null &&
            state.communityModel.trendingPost.isNotEmpty)
          CommunityList(
            onItemClickFav: addPostToFav,
            padding: const EdgeInsets.only(
                left: sizeSmallxxx, top: sizeLargexx, right: sizeSmallxxx),
            onClickSeeAll: openSeeAllCommunity,
            onItemClick: openCommunityDetail,
            isShowAll: true,
            listPost: (state?.communityModel?.trendingPost ?? []).length > 10
                ? state.communityModel.trendingPost.sublist(0, 10)
                : state.communityModel.trendingPost,
          ),
      ],
    );
  }

  Widget renderContentPage(HomeState state) {
    if (!(state?.listTrending != null && state.listTrending.isNotEmpty) &&
        !(state?.listRestaurants != null && state.listRestaurants.isNotEmpty) &&
        !(state?.listFacilities != null && state.listFacilities.isNotEmpty) &&
        !(state?.listActivities != null && state.listActivities.isNotEmpty) &&
        !(state?.listFoodTrucks != null && state.listFoodTrucks.isNotEmpty) &&
        !(state?.listEvents != null && state.listEvents.isNotEmpty)) {
      return SearchEmptyWidget(
        justInformEmpty: true,
      );
    }
    return Column(
      children: <Widget>[
        if (state?.listTrending != null && state.listTrending.isNotEmpty)
          TweenAnimationBuilder(
              tween: Tween<Offset>(
                  begin: const Offset(1, 0), end: const Offset(0, 0)),
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
              builder: (_, offset, __) {
                return FractionalTranslation(
                  translation: offset,
                  child: ShortListAssets(
                      onItemClick: openAssetDetail,
                      onClickAll: onClickSeeAllList,
                      title: Lang.home_trending_this_week.tr(),
                      shortAssetType: ShortAssetType.SMALL_ETA,
                      padding: const EdgeInsets.only(
                          left: sizeSmallxxx,
                          top: sizeLargexx,
                          right: sizeSmallxxx),
                      isShowAll: state.listTrending.length > 10,
                      listActivities: (state?.listTrending ?? []).length > 10
                          ? state.listTrending.sublist(0, 10)
                          : state.listTrending),
                );
              }),
        if (state?.listTopRate != null && state.listTopRate.isNotEmpty)
          TweenAnimationBuilder(
              tween: Tween<Offset>(
                  begin: const Offset(1, 0), end: const Offset(0, 0)),
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
              builder: (_, offset, __) {
                return ShortListAssets(
                    onItemClick: openAssetDetail,
                    onClickAll: () => onClickSeeAllGrid(ViewAssetType.TOP_RATE),
                    title: Lang.home_top_rated.tr(),
                    shortAssetType: ShortAssetType.SMALL_RATE,
                    padding: const EdgeInsets.only(
                        left: sizeSmallxxx,
                        top: sizeLargexx,
                        right: sizeSmallxxx),
                    isShowAll: state.listTopRate.length > 10,
                    listActivities: (state?.listTopRate ?? []).length > 10
                        ? state.listTopRate.sublist(0, 10)
                        : state?.listTopRate ?? []);
              }),
        if (state?.listMightLike != null && state.listMightLike.isNotEmpty)
          TweenAnimationBuilder(
              tween: Tween<Offset>(
                  begin: const Offset(1, 0), end: const Offset(0, 0)),
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
              builder: (_, offset, __) {
                return ShortListAssets(
                    onItemClick: openAssetDetail,
                    onClickAll: () =>
                        onClickSeeAllGrid(ViewAssetType.MIGHT_LIKE),
                    title: Lang.home_places_you_might_like.tr(),
                    shortAssetType: ShortAssetType.NORMAL_ETA,
                    padding: const EdgeInsets.only(
                        left: sizeSmallxxx,
                        top: sizeLargexx,
                        right: sizeSmallxxx),
                    isShowAll: state.listMightLike.length > 10,
                    listActivities: (state?.listMightLike ?? []).length > 10
                        ? state.listMightLike.sublist(0, 10)
                        : (state?.listMightLike ?? []));
              }),
        if (state?.listFacilities != null && state.listFacilities.isNotEmpty)
          TweenAnimationBuilder(
              tween: Tween<Offset>(
                  begin: const Offset(1, 0), end: const Offset(0, 0)),
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
              builder: (_, offset, __) {
                return FractionalTranslation(
                  translation: offset,
                  child: ShortListAssets(
                      onItemClick: openAssetDetail,
                      onClickAll: () =>
                          onClickSeeAllGrid(ViewAssetType.FACILITIES),
                      title: Lang.home_facilities.tr(),
                      shortAssetType: ShortAssetType.SMALL_ETA,
                      padding: const EdgeInsets.only(
                          left: sizeSmallxxx,
                          top: sizeLargexx,
                          right: sizeSmallxxx),
                      isShowAll: state.listFacilities.length > 10,
                      listActivities: (state?.listFacilities ?? []).length > 10
                          ? state.listFacilities.sublist(0, 10)
                          : state.listFacilities),
                );
              }),
        if (state?.listActivities != null && state.listActivities.isNotEmpty)
          TweenAnimationBuilder(
              tween: Tween<Offset>(
                  begin: const Offset(1, 0), end: const Offset(0, 0)),
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
              builder: (_, offset, __) {
                return FractionalTranslation(
                  translation: offset,
                  child: ShortListAssets(
                      onItemClick: openAssetDetail,
                      shortAssetType: ShortAssetType.SMALL_ETA,
                      onClickAll: () => onClickSeeAllGrid(ViewAssetType.ACTIVITIES),
                      title: Lang.home_activities.tr(),
                      padding: const EdgeInsets.only(
                          left: sizeSmallxxx,
                          top: sizeLargexx,
                          right: sizeSmallxxx),
                      isShowAll: state.listActivities.length > 10,
                      listActivities: (state?.listActivities ?? []).length > 10
                          ? state.listActivities.sublist(0, 10)
                          : state.listActivities),
                );
              }),
        if (state?.listRestaurants != null && state.listRestaurants.isNotEmpty)
          TweenAnimationBuilder(
              tween: Tween<Offset>(
                  begin: const Offset(1, 0), end: const Offset(0, 0)),
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
              builder: (_, offset, __) {
                return FractionalTranslation(
                  translation: offset,
                  child: ShortListAssets(
                      onItemClick: openAssetDetail,
                      onClickAll: () =>
                          onClickSeeAllGrid(ViewAssetType.RESTAURANTS),
                      title: Lang.home_restaurants.tr(),
                      shortAssetType: ShortAssetType.SMALL_ETA,
                      padding: const EdgeInsets.only(
                          left: sizeSmallxxx,
                          top: sizeLargexx,
                          right: sizeSmallxxx),
                      isShowAll: state.listRestaurants.length > 10,
                      listActivities: (state?.listRestaurants ?? []).length > 10
                          ? state.listRestaurants.sublist(0, 10)
                          : state.listRestaurants),
                );
              }),
        if (state?.listFoodTrucks != null && state.listFoodTrucks.isNotEmpty)
          TweenAnimationBuilder(
              tween: Tween<Offset>(
                  begin: const Offset(1, 0), end: const Offset(0, 0)),
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
              builder: (_, offset, __) {
                return FractionalTranslation(
                  translation: offset,
                  child: ShortListAssets(
                      title: Lang.home_food_trucks.tr(),
                      onItemClick: openAssetDetail,
                      onClickAll: () =>
                          onClickSeeAllGrid(ViewAssetType.FOOD_TRUCKS),
                      shortAssetType: ShortAssetType.SMALL_ETA,
                      padding: const EdgeInsets.only(
                          left: sizeSmallxxx,
                          top: sizeLargexx,
                          right: sizeSmallxxx),
                      isShowAll: state.listFoodTrucks.length > 10,
                      listActivities: (state?.listFoodTrucks ?? []).length > 10
                          ? state.listFoodTrucks.sublist(0, 10)
                          : state.listFoodTrucks),
                );
              }),
        if (state?.listEvents != null && state.listEvents.isNotEmpty)
          TweenAnimationBuilder(
              tween: Tween<Offset>(
                  begin: const Offset(1, 0), end: const Offset(0, 0)),
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
              builder: (_, offset, __) {
                return FractionalTranslation(
                  translation: offset,
                  child: EventsList(
                      onRemovePost: onRemoveEvent,
                      onTurnOffPost: onTurnOffEvent,
                      onItemClick: openEventDetail,
                      onSeeAllClick: () => widget.onClickSeeAllEvent(),
                      padding: const EdgeInsets.only(
                          left: sizeSmallxxx,
                          top: sizeLargexx,
                          right: sizeSmallxxx),
                      isShowSeeAll: state.listEvents.length > 10,
                      listActivities: (state?.listEvents ?? []).length > 10
                          ? state.listEvents.sublist(0, 9)
                          : state.listEvents),
                );
              }),
        const SizedBox(height: sizeNormal),
        MySocialMedia(
            title: context.locale.languageCode.toUpperCase() == PARAM_EN
                ? state?.appConfig?.titleSocialMediaEn
                : state?.appConfig?.titleSocialMediaAr,
            linkFacebook: state?.appConfig?.linkFacebook,
            linkInstagram: state?.appConfig?.linkInstagram,
            linkTwitter: state?.appConfig?.linkTwitter),
      ],
    );
  }

  void onClickActivity(ActivityModel item) {
    NavigateUtil.openPage(context, ActivityDetailScreen.routeName,
        argument: item);
  }

  Widget _getClearButton(state) {
    if (_homeSearchBloc.state is HomeSearchDisplayed) {
      return GestureDetector(
        onTap: onClearSearch,
        child: const Padding(
          padding: EdgeInsets.all(sizeVerySmall),
          child: Icon(
            Icons.clear,
            color: Colors.black,
            size: sizeNormal,
          ),
        ),
      );
    }
    return null;
  }

  Widget _getSearchButton(HomeState state) {
    return GestureDetector(
      onTap: () {
        onSubmitSearchKeyword(_controllerSearch.text);
      },
      child: const Icon(
        Icons.search,
        color: Colors.black,
        size: sizeNormal,
      ),
    );
  }

  void onClearSearch() {
    _controllerSearch.clear();
    _homeSearchBloc.add(ClearSearchEvent());
    _searchFocusNode.unfocus();
  }

  Widget homeContent(
      HomeState state, BaseBlocState stateBase, BoxConstraints constraints) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final hasFilter = state.currentArea?.filter?.isNotEmpty ?? false;
    return BlocBuilder<HomeSearchBloc, HomeSearchState>(
        builder: (context, stateSearch) {
      return MyRefreshList(
        enablePullDown: true,
        scrollPhysics: (_homeSearchBloc.state is HomeSearchDisplayed)
            ? const NeverScrollableScrollPhysics()
            : const ScrollPhysics(),
        scrollController: PrimaryScrollController.of(context),
        refreshController: refreshController,
        onRefresh: () {
          _homeBloc.add(FetchAllData());
          _baseBloc.add(FetchUserProfile());
        },
        listView: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              key: keyHeader,
              padding: const EdgeInsets.only(
                  left: sizeSmallxxx, right: sizeSmallxxx, bottom: sizeNormal),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: state.currentArea != null
                            ? GestureDetector(
                                onTap: () => onShowDialogArea(state),
                                child: Row(
                                  children: [
                                    UIUtil.makeCircleImageWidget(
                                        state?.currentArea?.icon,
                                        size: sizeNormal),
                                    const SizedBox(
                                      width: sizeVerySmall,
                                    ),
                                    MyTextView(
                                      text: state.currentArea?.name ?? '',
                                      textStyle: textNormalxxx.copyWith(
                                          color: Colors.black,
                                          fontFamily:
                                              MyFontFamily.publicoBanner,
                                          fontWeight: MyFontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: sizeVerySmall,
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      size: sizeNormalx,
                                    ),
                                  ],
                                ))
                            : Center(
                                child: Container(
                                height: sizeNormal,
                                width: sizeNormal,
                                child: const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.grey),
                                ),
                              )),
                      ),
                      if (stateBase?.userInfo?.isUser() ?? false)
                        GestureDetector(
                          onTap: () {
                            NavigateUtil.openPage(
                                context, NotificationHistoryScreen.routeName);
                          },
                          child: Material(
                            color: Colors.white,
                            type: MaterialType.circle,
                            child: Container(
                              padding: const EdgeInsets.all(sizeSmallx),
                              child: SvgPicture.asset(
                                  Res.home_icon_notification,
                                  width: sizeNormal,
                                  height: sizeNormal,
                                  color: Colors.black,
                                  fit: BoxFit.contain),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: sizeNormalxx,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: sizeLargex,
                          child: InputFieldRect(
                            controller: _controllerSearch,
                            focusNode: _searchFocusNode,
                            onSubmit: onSubmitSearchKeyword,
                            cusPreIcon: _getSearchButton(state),
                            cusSubIcon: _getClearButton(state),
                            textAlign: TextAlign.start,
                            borderColor: Colors.transparent,
                            borderRadius: sizeSmall,
                            hintStyle: textSmallx.copyWith(
                                color: const Color(0xffb9b9b9),
                                fontWeight: MyFontWeight.regular),
                            textStyle: textSmallx.copyWith(color: Colors.black),
                            hintText: Lang.home_looking_for_something.tr(),
                          ),
                        ),
                      ),
                      if (hasFilter)
                        const SizedBox(
                          width: sizeSmallxxx,
                        ),
                      if (hasFilter)
                        GestureDetector(
                            onTap: () {
                              openDialogFacilities(state);
                            },
                            child: Material(
                              color: Colors.white,
                              elevation: sizeVerySmall,
                              borderRadius: BorderRadius.circular(sizeSmall),
                              child: Container(
                                padding: const EdgeInsets.all(sizeSmall),
                                child: const Icon(
                                  Icons.filter_list,
                                  color: Color(0xff419c9b),
                                  size: sizeNormalx,
                                ),
                              ),
                            ))
                    ],
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: sizeSmallxxx,
                        right: sizeSmallxxx,
                      ),
                      child: BlocBuilder<BaseBloc, BaseBlocState>(
                          builder: (context, baseBlocState) {
                        if (baseBlocState is UpdateProfile ||
                            baseBlocState is BaseInitial) {
                          return WeatherWidget(
                            weatherInfo: state.weatherInfo,
                            userInfo: baseBlocState.userInfo,
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                    ),
                    if (!isMVP) activitiesAndCommunity(state),
                    renderContentPage(state),
                    SizedBox(
                      height: bottomPadding + sizeImageNormalx,
                    ),
                  ],
                ),
                BlocBuilder<HomeSearchBloc, HomeSearchState>(
                  builder: (context, state) {
                    if (state is HomeSearchDisplayed) {
                      return Container(
                        color: const Color.fromARGB(255, 250, 251, 243),
                        height: constraints.maxHeight - sizeImageNormal,
                        child: SearchWidget(
                          controllerSearch: _controllerSearch,
                          keyWord: _controllerSearch.text,
                          experienceId: _homeBloc.state?.currentArea?.id ?? 0,
                          listTrending: _homeBloc.state.listTrending,
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ],
        )),
      );
    });
  }
}
