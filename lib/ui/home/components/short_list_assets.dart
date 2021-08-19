import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/asset_large.dart';
import '../../../common/widget/asset_normal.dart';
import '../../../common/widget/asset_normal_eta.dart';
import '../../../common/widget/asset_small.dart';
import '../../../common/widget/asset_small_eta.dart';
import '../../../common/widget/asset_small_rate.dart';
import '../../../common/widget/my_text_view.dart';
import '../../../data/model/places_model.dart';

class ShortListAssets extends StatelessWidget {
  final Function(PlaceModel) onItemClick;
  final Function() onClickAll;
  final List<PlaceModel> listActivities;
  final String title;
  final EdgeInsets padding;
  final bool isShowAll;
  final ShortAssetType shortAssetType;

  ShortListAssets({
    Key key,
    this.onItemClick,
    this.onClickAll,
    this.isShowAll = true,
    this.title,
    this.listActivities,
    this.padding =
        const EdgeInsets.only(left: sizeSmallxxx, right: sizeSmallxxx),
    this.shortAssetType = ShortAssetType.SMALL,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: padding,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              MyTextView(
                text: title ?? Lang.home_top_rated.tr(),
                textStyle: textSmallxxx.copyWith(
                    color: Colors.black,
                    fontFamily: MyFontFamily.graphik,
                    fontWeight: MyFontWeight.bold),
              ),
              if (isShowAll)
                MyTextView(
                  onTap: onClickAll,
                  text: Lang.home_see_all.tr(),
                  padding: const EdgeInsets.symmetric(vertical: sizeVerySmall),
                  textStyle: textSmallxx.copyWith(
                      color: const Color(0xff419C9B),
                      fontFamily: MyFontFamily.graphik,
                      fontWeight: MyFontWeight.medium),
                )
            ],
          ),
        ),
        const SizedBox(
          height: sizeSmall,
        ),
        Padding(
          padding: const EdgeInsets.only(left: sizeSmall),
          child: renderWidgetByType(),
        ),
      ],
    );
  }

  Widget renderWidgetByType() {
    switch (shortAssetType) {
      case ShortAssetType.SMALL_ETA:
        return LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth / 3;
            return Container(
              height: w / 0.75,
              child: ListView.builder(
                itemCount: listActivities?.length ?? 0,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.only(
                        left: sizeVerySmall,
                        right: sizeVerySmall,
                        bottom: sizeSmall),
                    width: w,
                    child: AssetSmallEtaItem(
                      item: listActivities[index],
                      onItemClick: onItemClick,
                    ),
                  );
                },
              ),
            );
          },
        );
      case ShortAssetType.SMALL:
        return LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth / 3;
            return Container(
              height: w / 0.75,
              child: ListView.builder(
                itemCount: listActivities?.length ?? 0,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.only(
                        left: sizeVerySmall,
                        right: sizeVerySmall,
                        bottom: sizeSmall),
                    width: w,
                    child: AssetSmallItem(
                      item: listActivities[index],
                      onItemClick: onItemClick,
                    ),
                  );
                },
              ),
            );
          },
        );
      case ShortAssetType.SMALL_RATE:
        return LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth / 3;
            return Container(
              height: w / 0.6,
              child: ListView.builder(
                itemCount: listActivities?.length ?? 0,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.only(
                        left: sizeVerySmall,
                        right: sizeVerySmall,
                        bottom: sizeSmall),
                    width: w,
                    child: AssetSmallRateItem(
                      item: listActivities[index],
                      onItemClick: onItemClick,
                    ),
                  );
                },
              ),
            );
          },
        );
      case ShortAssetType.NORMAL:
        return LayoutBuilder(builder: (context, constraints) {
          // final w = constraints.maxWidth / 2.3;
          return Container(
              height: sizeImageNormalx + sizeNormalxx,
              child: ListView.builder(
                  itemCount: listActivities?.length ?? 0,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: AssetNormalItem(
                        item: listActivities[index],
                        onItemClick: onItemClick,
                      ),
                    );
                  }));
        });
      case ShortAssetType.NORMAL_ETA:
        return LayoutBuilder(builder: (context, constraints) {
          // final w = constraints.maxWidth / 2.3;
          return Container(
              height: sizeImageNormalx + sizeNormalxx,
              child: ListView.builder(
                  itemCount: listActivities?.length ?? 0,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: AssetNormalETAItem(
                        item: listActivities[index],
                        onItemClick: onItemClick,
                      ),
                    );
                  }));
        });
      case ShortAssetType.LARGE:
        return LayoutBuilder(builder: (context, constraints) {
          final w = constraints.maxWidth;
          return Container(
              height: w * 0.65,
              child: ListView.builder(
                  itemCount: listActivities?.length ?? 0,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(
                          left: sizeVerySmall, right: sizeVerySmall),
                      child: AssetLargeItem(
                        onItemClick: onItemClick,
                        item: listActivities[index],
                        ratio: 1.3,
                        height: w * 0.50,
                      ),
                    );
                  }));
        });
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: sizeImageLarge,
        child: ListView.builder(
          itemCount: listActivities?.length ?? 0,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.only(
                  left: sizeVerySmall, right: sizeVerySmall),
              child: AssetLargeItem(
                item: listActivities[index],
                height: sizeImageNormalxx + sizeSmall,
              ),
            );
          },
        ),
      );
    });
  }
}

enum ShortAssetType {
  NORMAL,
  NORMAL_ETA,
  SMALL,
  SMALL_RATE,
  SMALL_ETA,
  LARGE,
}
