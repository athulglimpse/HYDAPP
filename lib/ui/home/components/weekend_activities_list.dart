import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../common/constants.dart';
import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/my_indicator.dart';
import '../../../common/widget/my_text_view.dart';
import '../../../data/model/activity_model.dart';
import '../../../utils/ui_util.dart';

@immutable
class WeekendActivitiesList extends StatelessWidget {
  final Function(ActivityModel) onItemClick;
  final Function onClickSeeAll;
  final EdgeInsets padding;
  final List<ActivityModel> activities;

  final _indicatorState = GlobalKey<MyIndicatorState>();
  final bool isShowAll;
  final PageController _controller = PageController(
    initialPage: 0,
    keepPage: false,
  );

  WeekendActivitiesList({
    Key key,
    this.onItemClick,
    this.activities,
    this.onClickSeeAll,
    this.padding =
        const EdgeInsets.only(left: sizeSmallxxx, right: sizeSmallxxx),
    this.isShowAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: <Widget>[
          Padding(
            padding: padding,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                MyTextView(
                  text: Lang.home_it_a_sunny_weekend_to.tr(),
                  textStyle: textSmallxxx.copyWith(
                      color: Colors.black,
                      fontWeight: MyFontWeight.semiBold,
                      fontFamily: MyFontFamily.graphik),
                ),
                if (isShowAll)
                  MyTextView(
                    onTap: onClickSeeAll,
                    padding: const EdgeInsets.symmetric(
                        vertical: sizeVerySmall, horizontal: sizeVerySmall),
                    text: Lang.home_see_all.tr(),
                    textStyle: textSmallxx.copyWith(
                        color: const Color(0xff419C9B),
                        fontWeight: MyFontWeight.medium,
                        fontFamily: MyFontFamily.graphik),
                  )
              ],
            ),
          ),
          const SizedBox(height: sizeSmall),
          Container(
            height: (constraints.maxWidth - sizeNormal) / 1.96,
            child: PageView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: activities?.length ?? 0,
              controller: _controller,
              onPageChanged: (index) {
                _indicatorState.currentState.pageChanged(index);
              },
              itemBuilder: (context, index) {
                return CardActivityWidget(
                  activityModel: activities[index],
                  onItemClick: onItemClick,
                );
              },
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(top: sizeSmallxx, bottom: sizeVerySmall),
            child: MyIndicator(
              key: _indicatorState,
              normalColor: Colors.grey,
              selectedColor: Colors.black,
              needScaleSelected: false,
              controller: _controller,
              itemCount: activities?.length ?? 0,
            ),
          ),
        ],
      );
    });
  }
}

class CardActivityWidget extends StatelessWidget {
  final ActivityModel activityModel;
  final Function(ActivityModel) onItemClick;
  final EdgeInsets padding;
  final double aspectRatio;

  CardActivityWidget({
    Key key,
    this.activityModel,
    this.onItemClick,
    this.aspectRatio = 1.96,
    this.padding = const EdgeInsets.symmetric(horizontal: sizeNormal),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: GestureDetector(
        onTap: () => onItemClick(activityModel),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(sizeSmall),
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.3), BlendMode.multiply),
                    image: UIUtil.makeImageDecoration(
                        activityModel?.image?.url ?? Res.default_bg))),
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(sizeNormal),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MyTextView(
                          text: activityModel.title,
                          maxLine: 2,
                          textAlign: TextAlign.start,
                          textStyle: textNormalxxx.copyWith(
                              color: Colors.white,
                              fontWeight: MyFontWeight.medium,
                              fontFamily: MyFontFamily.graphik),
                        ),
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.end,
                        //   children: <Widget>[
                        //     const Icon(
                        //       Icons.group,
                        //       size: sizeSmallxxx,
                        //       color: Colors.white,
                        //     ),
                        //     const SizedBox(width: sizeSmall),
                        //     MyTextView(
                        //       text: Lang.amenity_detail_suitable_for.tr() +
                        //           ' ${amenityInfo.suitableAge}',
                        //       textStyle: textSmall.copyWith(
                        //           color: Colors.white,
                        //           fontWeight: MyFontWeight.medium,
                        //           fontFamily: MyFontFamily.graphik),
                        //     )
                        //   ],
                        // )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
