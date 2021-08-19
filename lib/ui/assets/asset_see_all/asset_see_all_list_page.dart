import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marvista/common/constants.dart';
import 'package:marvista/data/source/api_end_point.dart';

import '../../../common/di/injection/injector.dart';
import '../../../common/dialog/sort_tool_dialog.dart';
import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/asset_large.dart';
import '../../../common/widget/my_text_view.dart';
import '../../../data/model/category_model.dart';
import '../../../data/model/places_model.dart';
import '../../../utils/navigate_util.dart';
import '../../../utils/ui_util.dart';
import '../../base/base_widget.dart';
import '../asset_detail/asset_detail_page.dart';
import 'asset_see_all_grid_page.dart';
import 'bloc/asset_see_all_bloc.dart';

class AssetSeeAllListScreen extends BaseWidget {
  final ViewAssetType viewAssetType;
  static const routeName = 'AssetSeeAllListScreen';
  final int experienceId;
  final String facilitesId;
  final Map<int, Map> filterAdv;

  AssetSeeAllListScreen({
    this.experienceId,
    this.viewAssetType,
    this.facilitesId,
    this.filterAdv,
  });

  @override
  State<StatefulWidget> createState() {
    return AssetSeeAllListScreenState();
  }
}

class AssetSeeAllListScreenState extends BaseState<AssetSeeAllListScreen> {
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
                icon: Icon(
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
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: sizeSmall, right: sizeSmall),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: sizeImageLarge,
                          child: ListView.builder(
                            itemCount:
                                (state.allAssets?.length ?? 0).clamp(0, 6),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              final e = state.allAssets[index];
                              return Container(
                                margin: const EdgeInsets.only(
                                    left: sizeVerySmall, right: sizeVerySmall),
                                child: AssetLargeItem(
                                  onItemClick: openAssetDetail,
                                  ratio: 1.3,
                                  height: sizeImageNormalxx + sizeSmall,
                                  item: e,
                                ),
                              );
                            },
                          ),
                        ),
                        categoriesRender(state),
                        const SizedBox(
                          height: sizeNormal,
                        ),
                        Expanded(
                          child: LayoutBuilder(builder: (context, constraints) {
                            final w = constraints.maxWidth;
                            return Container(
                              width: w,
                              child: getListItemByCategory(state, w * 0.55),
                            );
                          }),
                        ),
                      ],
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

  Widget getListItemByCategory(AssetSeeAllState state, double height) {
    var places = state.allAssets;
    if (state.currentCate != null) {
      places = state.listGroupCategories[state.currentCate];
    }
    return ListView.builder(
      itemCount: places?.length ?? 0,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        final e = places[index];
        return Container(
          margin: const EdgeInsets.only(
            left: sizeVerySmall,
            right: sizeVerySmall,
          ),
          alignment: Alignment.center,
          child: AssetLargeItem(
            onItemClick: openAssetDetail,
            ratio: 1.3,
            height: height,
            item: e,
          ),
        );
      },
    );
  }

  Widget categoriesRender(AssetSeeAllState state) {
    final list = state.listGroupCategories?.entries?.toList() ?? [];
    return Container(
      height: sizeNormalxxx,
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: sizeSmall),
          scrollDirection: Axis.horizontal,
          itemCount: (list?.length ?? 0) + 1,
          itemBuilder: (e, index) {
            if (index == 0) {
              return itemCategoryAll(state);
            }
            final mapEntry = list[index - 1];
            return itemCategory(mapEntry, state);
          }),
    );
  }

  Widget itemCategoryAll(AssetSeeAllState state) {
    return GestureDetector(
      onTap: () {
        onClickCategory(null);
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
            vertical: sizeVerySmallx, horizontal: sizeSmallxxx),
        margin: const EdgeInsets.only(right: sizeSmall),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: state.currentCate == null
                ? const Color(0xff419C9B)
                : Colors.transparent,
            borderRadius:
                const BorderRadius.all(Radius.circular(sizeVerySmall))),
        child: MyTextView(
          textAlign: TextAlign.center,
          text: Lang.asset_detail_all.tr(),
          textStyle: textSmallxx.copyWith(
              color: state.currentCate == null
                  ? Colors.white
                  : const Color(0xff419C9B)),
        ),
      ),
    );
  }

  Widget itemCategory(MapEntry<CategoryModel, List<PlaceModel>> mapEntry,
      AssetSeeAllState state) {
    return GestureDetector(
      onTap: () {
        onClickCategory(mapEntry.key);
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
            vertical: sizeVerySmallx, horizontal: sizeSmallxxx),
        margin: const EdgeInsets.only(right: sizeSmall),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: mapEntry.key == state.currentCate
                ? const Color(0xff419C9B)
                : Colors.transparent,
            borderRadius:
                const BorderRadius.all(Radius.circular(sizeVerySmall))),
        child: MyTextView(
          textAlign: TextAlign.center,
          text: mapEntry.key.name,
          textStyle: textSmallxx.copyWith(
              color: mapEntry.key == state.currentCate
                  ? Colors.white
                  : const Color(0xff419C9B)),
        ),
      ),
    );
  }

  void onClickCategory(CategoryModel cate) {
    _assetSeeAllBloc.add(OnChangeCategory(cate));
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
