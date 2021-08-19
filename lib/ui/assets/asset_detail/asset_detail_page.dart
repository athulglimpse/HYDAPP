import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marvista/common/widget/my_social_media.dart';
import 'package:marvista/data/source/api_end_point.dart';
import 'package:marvista/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/constants.dart';
import '../../../common/di/injection/injector.dart';
import '../../../common/dialog/cupertino_picker_photo.dart';
import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/my_listview.dart';
import '../../../common/widget/my_read_more_text.dart';
import '../../../common/widget/my_text_view.dart';
import '../../../common/widget/static_maps_provider.dart';
import '../../../data/model/location_model.dart';
import '../../../data/model/places_model.dart';
import '../../../utils/app_const.dart';
import '../../../utils/navigate_util.dart';
import '../../../utils/ui_util.dart';
import '../../../utils/utils.dart';
import '../../base/base_widget.dart';
import '../../base/bloc/base_bloc.dart';
import '../../community/community_detail/community_detail_page.dart';
import '../../community/community_post_photo/community_post_photo_page.dart';
import '../../community/community_see_all/community_see_all_page.dart';
import '../../community/community_write_review/community_write_review_page.dart';
import '../../home/components/community_list.dart';
import '../../home/components/short_list_assets.dart';
import '../../login/login_page.dart';
import '../../report/report_page.dart';
import 'bloc/asset_detail_bloc.dart';
import 'component/asset_title_group.dart';
import 'component/asset_tool.dart';

class AssetDetailScreen extends BaseWidget {
  static const routeName = 'AssetDetailScreen';
  final PlaceModel placeModel;
  final String id;

  AssetDetailScreen({
    this.placeModel,
    this.id,
  });

  @override
  State<StatefulWidget> createState() {
    return AssetDetailScreenState();
  }
}

class AssetDetailScreenState extends BaseState<AssetDetailScreen> {
  final _assetDetailBloc = sl<AssetDetailBloc>();
  final RefreshController refreshController = RefreshController();
  ValueNotifier<String> valueRefreshCommunity = ValueNotifier('');
  ValueNotifier<String> valueRefreshAssetFa = ValueNotifier('');

  @override
  void initState() {
    super.initState();
    //Call this method first when LoginScreen init
    if (widget.placeModel != null) {
      _assetDetailBloc.add(CopyAssetDetail(widget.placeModel));
      _assetDetailBloc.add(FetchAssetDetail(widget.placeModel.id.toString()));
      _assetDetailBloc.add(FetchAlsoLike(widget.placeModel.id.toString()));
    } else {
      _assetDetailBloc.add(FetchAssetDetail(widget.id));
      _assetDetailBloc.add(FetchAlsoLike(widget.id));
    }

    _assetDetailBloc.listen((state) {
      if (refreshController.isRefresh) {
        refreshController.refreshCompleted();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: BlocProvider(
          create: (_) => _assetDetailBloc,
          child: BlocBuilder<AssetDetailBloc, AssetDetailState>(
              builder: (context, state) {
                if (state.assetDetail == null || state.isRefreshing) {
                  return SafeArea(
                    child: Center(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        child: SvgPicture.asset(
                          Res.default_img_write_review,
                          fit: BoxFit.cover,
                          height: sizeImageNormalxxx + sizeNormalx,
                        ),
                      ),
                    ),
                  );
                }
                return LayoutBuilder(builder: (context, constraints) {
                  return Stack(
                    children: [
                      Container(
                        height: sizeImageLargexxx,
                        width: constraints.maxWidth,
                        child: UIUtil.makeImageWidget(
                            state?.assetDetail?.image?.url ?? Res.image_lorem,
                            boxFit: BoxFit.cover),
                      ),
                      Container(
                        height: sizeImageSmall,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.8),
                                  Colors.black.withOpacity(0)
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter)),
                      ),
                      MyRefreshList(
                          key: Key(state?.assetDetail?.id?.toString() ?? '0'),
                          textColorRefresh: Colors.white,
                          enablePullDown: true,
                          onRefresh: () {
                            _assetDetailBloc.add(
                                FetchAssetDetail(
                                    state.assetDetail.id.toString()));
                            _assetDetailBloc.add(
                                FetchAlsoLike(state.assetDetail.id.toString()));
                          },
                          refreshController: refreshController,
                          listView: Container(
                            height: sizeImageSmall,
                          )),
                      DraggableScrollableSheet(
                          maxChildSize: 0.88,
                          initialChildSize: 0.75,
                          minChildSize: 0.75,
                          builder: (context, scrollController) {
                            return Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: sizeLarge),
                                  padding: const EdgeInsets.only(
                                      top: sizeLarge),
                                  decoration: const BoxDecoration(
                                      color: Color(0xffFDFBF5),
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(sizeNormalxx))),
                                  child: SingleChildScrollView(
                                    controller: scrollController,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: sizeSmallxxx,
                                            right: sizeSmallxxx,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              AssetTitleGroup(
                                                state: state,
                                              ),
                                              const SizedBox(
                                                height: sizeNormal,
                                              ),
                                              Divider(
                                                height: 1,
                                                color: const Color(0xff212237)
                                                    .withOpacity(0.1),
                                              ),
                                              AssetTool(
                                                onClickShare: () {
                                                  Utils.shareContent(
                                                      state.assetDetail.title ??
                                                          '',
                                                      state?.assetDetail
                                                          ?.shareUrl ??
                                                          'http://www.hudayriyat.com/');
                                                },
                                                onClickReport: () {
                                                  NavigateUtil.openPage(context,
                                                      ReportPage.routeName);
                                                },
                                                onClickReview: onWriteReview,
                                                onClickPhoto: checkPermissionCamera,
                                              ),
                                              Divider(
                                                height: 1,
                                                color: const Color(0xff212237)
                                                    .withOpacity(0.1),
                                              ),
                                              if (state.assetDetail?.description
                                                  ?.isNotEmpty ??
                                                  false)
                                                const SizedBox(
                                                  height: sizeNormalxx,
                                                ),
                                              if (state.assetDetail?.description
                                                  ?.isNotEmpty ??
                                                  false)
                                                MyTextView(
                                                  text: Lang
                                                      .asset_detail_about_this_place
                                                      .tr(),
                                                  textStyle: textSmallxxx
                                                      .copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                      MyFontWeight.semiBold,
                                                      fontFamily:
                                                      MyFontFamily.graphik),
                                                ),
                                              if (state.assetDetail?.description
                                                  ?.isNotEmpty ??
                                                  false)
                                                const SizedBox(
                                                  height: sizeSmallxx,
                                                ),
                                              ReadMoreText(
                                                state.assetDetail
                                                    ?.description ??
                                                    '',
                                                trimLines: 4,
                                                trimMode: TrimMode.Line,
                                                trimCollapsedText:
                                                Lang.event_read_more.tr(),
                                                trimExpandedText:
                                                Lang.event_read_less.tr(),
                                                style: textSmallxx.copyWith(
                                                    color: const Color(
                                                        0xff212237),
                                                    fontWeight:
                                                    MyFontWeight.regular,
                                                    fontFamily:
                                                    MyFontFamily.graphik),
                                                moreStyle: textSmallxx.copyWith(
                                                    color: const Color(
                                                        0xff212237),
                                                    fontWeight: MyFontWeight
                                                        .medium,
                                                    fontFamily:
                                                    MyFontFamily.graphik),
                                                lessStyle: textSmallxx.copyWith(
                                                    color: const Color(
                                                        0xff212237),
                                                    fontWeight: MyFontWeight
                                                        .medium,
                                                    fontFamily:
                                                    MyFontFamily.graphik),
                                              ),
                                              const SizedBox(
                                                height: sizeNormalxx,
                                              ),
                                              MySocialMedia(
                                                  title: state
                                                      ?.assetDetail
                                                      ?.titleSocialMedia,
                                                  linkFacebook: state
                                                      ?.assetDetail?.linkFacebook,
                                                  linkInstagram: state
                                                      ?.assetDetail
                                                      ?.linkInstagram,
                                                  linkTwitter:
                                                  state?.assetDetail?.linkTwitter,
                                                  isHorizontal: false,
                                                  padding: const EdgeInsets.only(
                                                      left: 0, right: 0)),
                                              const SizedBox(
                                                height: sizeNormalxx,
                                              ),
                                              MyTextView(
                                                text:
                                                Lang.asset_detail_location.tr(),
                                                textStyle: textSmallxxx
                                                    .copyWith(
                                                    color: Colors.black,
                                                    fontWeight:
                                                    MyFontWeight.semiBold,
                                                    fontFamily:
                                                    MyFontFamily.graphik),
                                              ),
                                              const SizedBox(
                                                height: sizeNormal,
                                              ),
                                              BlocBuilder<AssetDetailBloc,
                                                  AssetDetailState>(
                                                  buildWhen: (previousState,
                                                      currentState) {
                                                    return previousState
                                                        .assetDetail
                                                        .pickOneSuitable !=
                                                        currentState.assetDetail
                                                            .pickOneSuitable;
                                                  }, builder: (context, state) {
                                                return SizedBox(
                                                  height: sizeImageLargex,
                                                  child: renderStaticMap(state
                                                      .assetDetail
                                                      .pickOneLocation),
                                                );
                                              }),
                                              const SizedBox(
                                                  height: sizeNormal),
                                            ],
                                          ),
                                        ),
                                        if (state?.communityModel != null &&
                                            (state?.communityModel?.trendingPost
                                                ?.isNotEmpty ??
                                                false))
                                          ValueListenableBuilder<String>(
                                              valueListenable:
                                              valueRefreshCommunity,
                                              builder: (context, mode,
                                                  snapshot) {
                                                return CommunityList(
                                                  onItemClickFav: (value) {
                                                    if (state.userInfo
                                                        .isUser()) {
                                                      valueRefreshCommunity
                                                          .value =
                                                          DateTime.now()
                                                              .toIso8601String();
                                                      _assetDetailBloc.add(
                                                          AddPostFavorite(
                                                              value));
                                                    } else {
                                                      NavigateUtil.openPage(
                                                          context,
                                                          LoginPage.routeName);
                                                    }
                                                  },
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: sizeSmall),
                                                  onClickSeeAll: () {
                                                    NavigateUtil.openPage(
                                                        context,
                                                        CommunitySeeAllScreen
                                                            .routeName,
                                                        argument: {
                                                          'experId': state
                                                              .assetDetail
                                                              ?.experience
                                                              ?.id ??
                                                              '',
                                                        });
                                                  },
                                                  margin: const EdgeInsets.only(
                                                      left: sizeSmall),
                                                  onItemClick: (value) {
                                                    NavigateUtil.openPage(
                                                        context,
                                                        CommunityDetailScreen
                                                            .routeName,
                                                        argument: {
                                                          'data': value
                                                        });
                                                  },
                                                  isShowAll: true,
                                                  listPost: (state
                                                      ?.communityModel
                                                      ?.trendingPost ??
                                                      [])
                                                      .length >
                                                      10
                                                      ? state.communityModel
                                                      .trendingPost
                                                      .sublist(0, 9)
                                                      : (state?.communityModel
                                                      ?.trendingPost ??
                                                      []),
                                                );
                                              }),
                                        const SizedBox(height: sizeNormal),
                                        if (state?.alsoLikeAssets?.isNotEmpty ??
                                            false)
                                          ShortListAssets(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: sizeSmall),
                                              listActivities:
                                              state?.alsoLikeAssets ?? [],
                                              shortAssetType:
                                              ShortAssetType.SMALL_RATE,
                                              onItemClick: (v) {
                                                openAssetDetail(v);
                                              },
                                              isShowAll: false,
                                              title: Lang
                                              // ignore: lines_longer_than_80_chars
                                                  .amenity_detail_you_might_also_like
                                                  .tr())
                                      ],
                                    ),
                                  ),
                                ),
                                if (state?.assetDetail?.thumb?.url
                                    ?.isNotEmpty ??
                                    false)
                                  Positioned.fill(
                                      right: sizeNormalxx,
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Wrap(
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius
                                                      .all(
                                                      Radius.circular(
                                                          sizeSmallxx))),
                                              height: sizeExLarge,
                                              width: sizeExLarge,
                                              padding: const EdgeInsets.all(
                                                  sizeVerySmall),
                                              child: UIUtil
                                                  .makeCircleImageWidget(
                                                state?.assetDetail?.thumb
                                                    ?.url ??
                                                    Res.image_lorem,
                                                color:Colors.transparent,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                              ],
                            );
                          }),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: sizeSmall, vertical: sizeSmall),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      NavigateUtil.pop(context);
                                    },
                                    child: Container(
                                      height: sizeNormalxxx,
                                      width: sizeNormalxxx,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      child: Icon(
                                        UIUtil.getCircleIconBack(context),
                                        color: Colors.black,
                                        size: sizeNormalxx,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (state.userInfo.isUser()) {
                                        valueRefreshAssetFa.value =
                                            DateTime.now().toIso8601String();
                                        _assetDetailBloc.add(AddFavorite(
                                            state.assetDetail.id.toString()));
                                      } else {
                                        NavigateUtil.openPage(
                                            context, LoginPage.routeName);
                                      }
                                    },
                                    child: ValueListenableBuilder<String>(
                                        valueListenable: valueRefreshAssetFa,
                                        builder: (context, mode, snapshot) {
                                          return Container(
                                            height: sizeNormalxxx,
                                            width: sizeNormalxxx,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white.withAlpha(
                                                    100)),
                                            child: Center(
                                              child: Icon(
                                                Icons.favorite,
                                                color:
                                                state.assetDetail?.isFavorite ??
                                                    false
                                                    ? Colors.red
                                                    : Colors.white,
                                                size: sizeNormal,
                                              ),
                                            ),
                                          );
                                        }),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                });
              }),
        ),
      ),
    );
  }

  Widget renderStaticMap(LocationModel locationModel) {
    return StaticMapsProvider(
      MAP_API_KEY,
      locationModel: locationModel,
      markers: [
        {
          'latitude': double.tryParse(
              locationModel?.lat ?? DEFAULT_LOCATION_LAT.toString()),
          'longitude': double.tryParse(
              locationModel?.long ?? DEFAULT_LOCATION_LONG.toString())
        },
      ],
      height: sizeImageLargex.round(),
      width: 400,
    );
  }

  void onWriteReview() {
    NavigateUtil.openPage(context, CommunityWriteReviewPage.routeName,
        argument: {
          'id': _assetDetailBloc.state.assetDetail.id.toString(),
        });
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

  void onSelectPhoto(String path) {
    NavigateUtil.openPage(context, CommunityPostPhotoPage.routeName, argument: {
      'path': path,
      'id': _assetDetailBloc?.state?.assetDetail?.id.toString() ?? ''
    });
  }

  void openAssetDetail(PlaceModel value) {
    NavigateUtil.openPage(context, AssetDetailScreen.routeName,
        argument: {'data': value}).then((value) {});
  }

  // void onClickSeeAllGrid(ViewAssetType viewAssetType) {
  //   NavigateUtil.openPage(context, AssetSeeAllGridScreen.routeName, argument: {
  //     'type': viewAssetType,
  //     'experId': _assetDetailBloc.state?.assetDetail?.experience?.id ?? '',
  //   });
  // }

  @override
  void dispose() {
    _assetDetailBloc.close();
    refreshController.dispose();
    super.dispose();
  }
}
