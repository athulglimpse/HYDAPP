import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constants.dart';
import '../../../common/di/injection/injector.dart';
import '../../../common/dialog/sort_tool_dialog.dart';
import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/asset_small.dart';
import '../../../common/widget/asset_small_rate.dart';
import '../../../common/widget/my_text_view.dart';
import '../../../data/model/places_model.dart';
import '../../../data/source/api_end_point.dart';
import '../../../utils/navigate_util.dart';
import '../../../utils/ui_util.dart';
import '../../base/base_widget.dart';
import '../asset_detail/asset_detail_page.dart';
import 'bloc/asset_see_all_bloc.dart';

class AssetSeeAllGridScreen extends BaseWidget {
  final ViewAssetType viewAssetType;
  static const routeName = 'AssetSeeAllScreen';
  final int experienceId;
  final String facilitesId;
  final Map<int, Map> filterAdv;

  AssetSeeAllGridScreen({
    this.experienceId,
    this.filterAdv,
    this.facilitesId,
    this.viewAssetType,
  });

  @override
  State<StatefulWidget> createState() {
    return AssetSeeAllGridScreenState();
  }
}

class AssetSeeAllGridScreenState extends BaseState<AssetSeeAllGridScreen> {
  final _assetSeeAllBloc = sl<AssetSeeAllBloc>();

  @override
  void initState() {
    super.initState();
    //Call this method first when LoginScreen init
    initBasicInfo();
    _assetSeeAllBloc.add(InitAssetFromCache(widget.viewAssetType));
    _assetSeeAllBloc.add(FetchAsset(
      viewAssetType: widget.viewAssetType,
      experienceId: widget.experienceId,
      filterAdv: widget.filterAdv,
      facilitesId: widget.facilitesId,
    ));
  }

  void initBasicInfo() {}

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => _assetSeeAllBloc,
      child: Container(
        color: const Color(0xffFDFBF5),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              actions: [
                BlocBuilder<AssetSeeAllBloc, AssetSeeAllState>(
                    builder: (context, state) {
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: sizeSmallxxx),
                    alignment: Alignment.center,
                    child: Wrap(
                      children: [
                        GestureDetector(
                            onTap: () {
                              UIUtil.showDialogAnimation(
                                      hasDragDismiss: true,
                                      child: SortToolDialog(
                                          currentValue: state.sortType),
                                      context: context)
                                  .then((value) {
                                if (value != null &&
                                    (value as Map).containsKey('sort_type')) {
                                  _assetSeeAllBloc
                                      .add(DoSortItems(value['sort_type']));
                                }
                              });
                            },
                            child: Material(
                              color: Colors.white,
                              elevation: sizeVerySmall,
                              borderRadius: BorderRadius.circular(sizeSmall),
                              child: Container(
                                  padding: const EdgeInsets.all(sizeSmall),
                                  child: UIUtil.makeImageWidget(
                                      (context.locale.languageCode
                                                  .toUpperCase() ==
                                              PARAM_EN)
                                          ? Res.sort_en
                                          : Res.sort_ar,
                                      width: sizeNormal,
                                      height: sizeNormal,
                                      color: const Color(0xff419c9b),
                                      boxFit: BoxFit.contain)),
                            )),
                      ],
                    ),
                  );
                })
              ],
              leading: IconButton(
                icon:  Icon(
                  UIUtil.getCircleIconBack(context),
                  color: Colors.black,
                  size: sizeNormalxx,
                ),
                onPressed: () {
                  NavigateUtil.pop(context);
                },
              ),
              backgroundColor: const Color(0xffFDFBF5),
              title: MyTextView(
                textStyle: textNormal.copyWith(color: Colors.black),
                text: getTitleByType(widget.viewAssetType),
              ),
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                return BlocBuilder<AssetSeeAllBloc, AssetSeeAllState>(
                    builder: (context, state) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: sizeSmall, right: sizeSmall),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: (widget.viewAssetType ==
                                    ViewAssetType.TOP_RATE)
                                ? GridView.count(
                                    primary: false,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    crossAxisCount: 3,
                                    childAspectRatio: 0.7,
                                    mainAxisSpacing: sizeVerySmall,
                                    children: state?.allAssets
                                            ?.map((e) => Container(
                                                  margin: const EdgeInsets.only(
                                                      left: sizeVerySmall,
                                                      bottom: sizeVerySmall,
                                                      right: sizeVerySmall),
                                                  child: AssetSmallRateItem(
                                                    item: e,
                                                    onItemClick:
                                                        openAssetDetail,
                                                  ),
                                                ))
                                            ?.toList() ??
                                        [],
                                  )
                                : GridView.count(
                                    primary: false,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    crossAxisCount: 3,
                                    childAspectRatio: 0.7,
                                    mainAxisSpacing: sizeVerySmall,
                                    children: state?.allAssets
                                            ?.map((e) => Container(
                                                  margin: const EdgeInsets.only(
                                                      left: sizeVerySmall,
                                                      bottom: sizeVerySmall,
                                                      right: sizeVerySmall),
                                                  child: AssetSmallItem(
                                                    item: e,
                                                    onItemClick:
                                                        openAssetDetail,
                                                  ),
                                                ))
                                            ?.toList() ??
                                        [],
                                  ),
                          ),
                          const SizedBox(
                            height: sizeNormal,
                          ),
                          // ShortListAssets(
                          //     padding: const EdgeInsets.all(0),
                          //     listActivities: state?.alsoLikeAssets ?? [],
                          //     isShowAll: false,
                          //     title:
                          //         Lang.amenity_detail_you_might_also_like.tr())
                        ],
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  void openAssetDetail(PlaceModel value) {
    NavigateUtil.openPage(context, AssetDetailScreen.routeName,
        argument: {'data': value});
  }

  @override
  void dispose() {
    _assetSeeAllBloc.close();
    super.dispose();
  }
}

enum ViewAssetType {
  TRENDING_THIS_WEEK,
  TEENS,
  MIGHT_LIKE,
  ADULTS,
  WORK,
  TOP_RATE,
  FAMILIES,
  RESTAURANTS,
  FACILITIES,
  ACTIVITIES,
  FOOD_TRUCKS,
}

String getTitleByType(ViewAssetType viewAssetType) {
  switch (viewAssetType) {
    case ViewAssetType.MIGHT_LIKE:
      return Lang.amenity_detail_you_might_also_like.tr();
    case ViewAssetType.TRENDING_THIS_WEEK:
      return Lang.home_trending_this_week.tr();
    case ViewAssetType.TEENS:
      return Lang.home_suitable_for_teens.tr();
    case ViewAssetType.ADULTS:
      return Lang.home_suitable_for_adults.tr();
    case ViewAssetType.FAMILIES:
      return Lang.home_suitable_for_families.tr();
    case ViewAssetType.TOP_RATE:
      return Lang.home_top_rated.tr();
    case ViewAssetType.WORK:
      return Lang.home_suitable_for_work.tr();
    case ViewAssetType.RESTAURANTS:
      return Lang.home_restaurants.tr();
    case ViewAssetType.FOOD_TRUCKS:
      return Lang.home_food_trucks.tr();
    case ViewAssetType.FACILITIES:
      return Lang.home_facilities.tr();
    case ViewAssetType.ACTIVITIES:
      return Lang.home_activities.tr();
  }
  return '';
}
