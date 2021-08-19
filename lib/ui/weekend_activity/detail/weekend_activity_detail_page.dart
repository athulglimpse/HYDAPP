import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvista/ui/base/bloc/base_bloc.dart';
import 'package:marvista/ui/login/login_page.dart';
import 'package:share/share.dart';

import '../../../common/di/injection/injector.dart';
import '../../../common/dialog/cupertino_picker_photo.dart';
import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/utils.dart';
import '../../../common/widget/my_indicator.dart';
import '../../../common/widget/my_text_view.dart';
import '../../../data/model/activity_model.dart';
import '../../../data/model/community_model.dart';
import '../../../data/model/places_model.dart';
import '../../../utils/app_const.dart';
import '../../../utils/navigate_util.dart';
import '../../../utils/ui_util.dart';
import '../../assets/asset_detail/asset_detail_page.dart';
import '../../base/base_widget.dart';
import '../../community/community_detail/community_detail_page.dart';
import '../../community/community_post_photo/community_post_photo_page.dart';
import '../../community/community_see_all/community_see_all_page.dart';
import '../../community/community_write_review/community_write_review_page.dart';
import '../../home/components/community_list.dart';
import '../../home/components/weekend_activities_list.dart';
import '../../report/report_page.dart';
import 'bloc/weekend_activity_detail_bloc.dart';
import 'component/activity_place_info_card.dart';
import 'component/activity_title_group.dart';
import 'component/activity_tool.dart';

class ActivityDetailScreen extends BaseWidget {
  static const routeName = 'ActivityDetailScreen';

  final ActivityModel item;

  ActivityDetailScreen({this.item});

  @override
  State<StatefulWidget> createState() {
    return ActivityDetailScreenState();
  }
}

class ActivityDetailScreenState extends BaseState<ActivityDetailScreen> {
  final _amenityDetailBloc = sl<WeekendActivityDetailBloc>();

  final _indicatorState = GlobalKey<MyIndicatorState>();
  final PageController _controller = PageController(
    initialPage: 0,
    keepPage: false,
  );

  @override
  void initState() {
    super.initState();
    _amenityDetailBloc.add(CopyActivityInfo(widget.item));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => _amenityDetailBloc,
        child:
            BlocBuilder<WeekendActivityDetailBloc, WeekendActivityDetailState>(
                builder: (context, state) {
          if (state.activityModel == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return LayoutBuilder(builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  height: sizeImageLargexxx,
                  width: constraints.maxWidth,
                  child: UIUtil.makeImageWidget(state.activityModel.image.url,
                      boxFit: BoxFit.cover),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: sizeSmall, vertical: sizeSmall),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: sizeNormalxxx,
                          width: sizeNormalxxx,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: GestureDetector(
                            onTap: () {
                              NavigateUtil.pop(context);
                            },
                            child: Icon(
                              UIUtil.getCircleIconBack(context),
                              color: Colors.black,
                              size: sizeNormalxx,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                DraggableScrollableSheet(
                    maxChildSize: 0.88,
                    initialChildSize: 0.7,
                    minChildSize: 0.7,
                    builder: (context, scrollController) {
                      return Container(
                        padding: EdgeInsets.only(top: sizeVerySmall),
                        decoration: const BoxDecoration(
                            color: Color(0xffFDFBF5),
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(sizeNormalxx))),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: sizeSmallxxx,
                              right: sizeSmallxxx,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: sizeNormalxx),
                                ActivityTitleGroup(
                                  state: state,
                                ),
                                const SizedBox(height: sizeNormal),
                                Divider(
                                  height: 1,
                                  color:
                                      const Color(0xff212237).withOpacity(0.1),
                                ),
                                ActivityTool(
                                  onClickReview: onWriteReview,
                                  onClickPhoto: checkPermissionCamera,
                                  onClickShare: () {
                                    Share.share(
                                        state?.activityModel?.shareUrl ??
                                            'http://www.hudayriyat.com/');
                                  },
                                  onClickReport: () {
                                    NavigateUtil.openPage(
                                        context, ReportPage.routeName);
                                  },
                                ),
                                Divider(
                                  height: 1,
                                  color:
                                      const Color(0xff212237).withOpacity(0.1),
                                ),
                                const SizedBox(height: sizeNormalxxx),
                                if ((state.activityModel?.detail?.length ?? 0) >
                                    0)
                                  MyTextView(
                                    text: Lang
                                        // ignore: lines_longer_than_80_chars
                                        .amenity_detail_you_can_enjoy_this_amenity_at
                                        .tr(),
                                    textStyle: textSmallxxx.copyWith(
                                        color: Colors.black,
                                        fontWeight: MyFontWeight.semiBold,
                                        fontFamily: MyFontFamily.graphik),
                                  ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (e, index) {
                                    return Container(
                                        child: ActivityPlaceInfoCard(
                                      placeModel:
                                          state.activityModel?.detail[index],
                                      textSizeTitle: textSmallxxx.copyWith(
                                          fontFamily: MyFontFamily.graphik,
                                          fontWeight: MyFontWeight.medium),
                                      textSizeSubTitle: textSmallxx.copyWith(
                                          fontFamily: MyFontFamily.graphik,
                                          color: const Color(0xff212237)
                                              .withOpacity(0.5),
                                          fontWeight: MyFontWeight.regular),
                                      horizontalMarginInfoCard:
                                          const EdgeInsets.symmetric(
                                              horizontal: sizeNormal),
                                      margin: const EdgeInsets.only(
                                          bottom: sizeSmallx),
                                      onItemClick: openAssetDetail,
                                      onItemClickDirection: (e) {
                                        MapUtils.openMap(
                                            double.parse(
                                                e?.pickOneLocation?.lat ??
                                                    DEFAULT_LOCATION_LAT),
                                            double.parse(
                                                e?.pickOneLocation?.long ??
                                                    DEFAULT_LOCATION_LONG));
                                      },
                                    ));
                                  },
                                  itemCount:
                                      state.activityModel?.detail?.length ?? 0,
                                ),
                                const SizedBox(height: sizeSmallxxx),
                                if (state?.listCommunities?.isNotEmpty ?? false)
                                  CommunityList(
                                    listPost: state.listCommunities.length > 10
                                        ? state.listCommunities.sublist(0, 9)
                                        : state.listCommunities,
                                    isShowAll: true,
                                    onItemClick: openCommunityDetail,
                                    onClickSeeAll: openSeeAllCommunity,
                                    onItemClickFav: addPostToFav,
                                    padding: const EdgeInsets.all(0),
                                    margin: const EdgeInsets.all(0),
                                  ),
                                if ((state.activitiesAlsoLike?.length ?? 0) > 0)
                                  MyTextView(
                                    text: Lang
                                        .amenity_detail_you_might_also_like
                                        .tr(),
                                    textStyle: textSmallxxx.copyWith(
                                        fontWeight: MyFontWeight.semiBold,
                                        fontFamily: MyFontFamily.graphik),
                                  ),
                                if ((state.activitiesAlsoLike?.length ?? 0) > 0)
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: sizeVerySmall),
                                    height: sizeImageNormalxxx,
                                    child: AspectRatio(
                                      aspectRatio: 1.96,
                                      child: PageView.builder(
                                        physics: const ClampingScrollPhysics(),
                                        itemCount:
                                            state.activitiesAlsoLike?.length ??
                                                0,
                                        controller: _controller,
                                        onPageChanged: (index) {
                                          _indicatorState.currentState
                                              .pageChanged(index);
                                        },
                                        itemBuilder: (context, index) {
                                          return CardActivityWidget(
                                            onItemClick: onItemClick,
                                            padding:
                                                const EdgeInsets.all(sizeSmall),
                                            activityModel:
                                                state.activitiesAlsoLike[index],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                Container(
                                  child: MyIndicator(
                                    key: _indicatorState,
                                    normalColor: Colors.grey,
                                    selectedColor: Colors.black,
                                    needScaleSelected: false,
                                    controller: _controller,
                                    itemCount:
                                        state.activitiesAlsoLike?.length ?? 0,
                                  ),
                                ),
                                const SizedBox(height: sizeNormal),
                              ],
                            ),
                          ),
                        ),
                      );
                    })
              ],
            );
          });
        }),
      ),
    );
  }

  void openAssetDetail(PlaceModel value) {
    NavigateUtil.openPage(context, AssetDetailScreen.routeName,
        argument: {'data': value});
  }

  void onItemClick(ActivityModel item) {
    NavigateUtil.openPage(context, ActivityDetailScreen.routeName,
        argument: item);
  }

  void onWriteReview() {
    NavigateUtil.openPage(context, CommunityWriteReviewPage.routeName);
  }

  void onWriteReport() {
    NavigateUtil.openPage(context, ReportPage.routeName);
  }

  void checkPermissionCamera() {
    final baseBloc = sl<BaseBloc>();
    if (baseBloc.state.userInfo != null && baseBloc.state.userInfo.isUser()) {
      showCupertinoModalPopup(
          context: context,
          builder: (context) =>
              CupertinoPickerPhotoView(onSelectPhoto: onSelectPhoto));
    } else {
      NavigateUtil.openPage(context, LoginPage.routeName);
    }
  }

  void openSeeAllCommunity() {
    NavigateUtil.openPage(context, CommunitySeeAllScreen.routeName);
  }

  void openCommunityDetail(CommunityPost value) {
    NavigateUtil.openPage(context, CommunityDetailScreen.routeName,
        argument: value);
  }

  void addPostToFav(CommunityPost value) {
    final baseBloc = sl<BaseBloc>();
    if (baseBloc.state.userInfo.isUser()) {
      _amenityDetailBloc.add(AddPostFavorite(value));
    } else {
      NavigateUtil.openPage(context, LoginPage.routeName);
    }
  }

  void onSelectPhoto(String path) {
    NavigateUtil.openPage(context, CommunityPostPhotoPage.routeName,
        argument: {'path': path});
  }

  @override
  void dispose() {
    _amenityDetailBloc.close();
    super.dispose();
  }
}
