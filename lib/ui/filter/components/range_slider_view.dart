import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marvista/data/source/api_end_point.dart';

import '../../../common/constants.dart';
import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/my_text_view.dart';
import '../../../data/model/area_item.dart';
import 'flutter_xlider.dart';

class RangeSliderView extends StatelessWidget {
  final FilterArea itemFilter;
  final double valueLeft;
  final double valueRight;
  final double max;
  final double min;
  final Function(FilterArea) onClearRangeSlider;
  final Function(FilterArea filterArea, int handlerIndex, dynamic lowerValue,
      dynamic upperValue) onDragCompleted;

  const RangeSliderView({
    Key key,
    this.itemFilter,
    this.max = 100,
    this.min = 0,
    this.onDragCompleted,
    this.valueLeft = 10,
    this.valueRight = 30,
    this.onClearRangeSlider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(horizontal: sizeSmallxx),
              child: MyTextView(
                  textStyle: textSmallxxx.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  text: itemFilter?.name ?? ''),
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.symmetric(horizontal: sizeSmallxx),
              child: MyTextView(
                onTap: () {
                  onClearRangeSlider(itemFilter);
                },
                textStyle: textSmallx.copyWith(
                    color: const Color(0xff419c9b),
                    fontWeight: FontWeight.bold),
                text: Lang.home_clear.tr(),
              ),
            ),
          ],
        ),
        const SizedBox(height: sizeNormal),
        Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: sizeSmallxxx),
                child: MyTextView(
                    textStyle: textSmallxx.copyWith(color: Colors.grey),
                    text: itemFilter.filterItem[0].name +
                        ': ' +
                        itemFilter.filterItem[0].number +
                        itemFilter.unit),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.only(right: sizeSmallxxx),
                child: MyTextView(
                    textStyle: textSmallx.copyWith(color: Colors.grey),
                    text: itemFilter.filterItem[1].name +
                        ': ' +
                        itemFilter.filterItem[1].number +
                        itemFilter.unit),
              ),
            ),
          ],
        ),
        FlutterSlider(
          values: [valueLeft, valueRight],
          min: min,
          max: max,
          rangeSlider: true,
          trackBar: FlutterSliderTrackBar(
            activeTrackBarHeight: sizeVerySmall,
            inactiveTrackBar: BoxDecoration(
              borderRadius: BorderRadius.circular(sizeNormal),
              color: Colors.grey[300],
            ),
            activeTrackBar: BoxDecoration(
                borderRadius: BorderRadius.circular(sizeVerySmall),
                color: const Color(0xfffbbc43).withOpacity(0.5)),
          ),
          rtl: context.locale.languageCode.toUpperCase() != PARAM_EN,
          handler: FlutterSliderHandler(
            decoration: const BoxDecoration(),
            child: Material(
              type: MaterialType.circle,
              color: const Color(0xfffbbc43),
              elevation: 1,
              child: Container(
                  child: const SizedBox(
                      width: sizeSmallxxx, height: sizeSmallxxx)),
            ),
          ),
          rightHandler: FlutterSliderHandler(
            decoration: const BoxDecoration(),
            child: Material(
              type: MaterialType.circle,
              color: const Color(0xfffbbc43),
              elevation: 1,
              child: Container(
                  child: const SizedBox(
                      width: sizeSmallxxx, height: sizeSmallxxx)),
            ),
          ),
          handlerAnimation: const FlutterSliderHandlerAnimation(scale: 1),
          onDragCompleted: (index, low, up) {
            onDragCompleted(itemFilter, index, low, up);
          },
          tooltip: FlutterSliderTooltip(
            custom: (value) {
              return Stack(
                fit: StackFit.passthrough,
                children: [
                  SvgPicture.asset(
                    Res.icon_tooltip,
                    fit: BoxFit.fill,
                    width: sizeNormalxxx,
                    height: sizeNormalx,
                  ),
                  Positioned.fill(
                    top: sizeIcon,
                    child: Align(
                      alignment: Alignment.center,
                      child: MyTextView(
                          textStyle: textSmallx.copyWith(color: Colors.white),
                          text: value.toString()),
                    ),
                  ),
                ],
              );
            },
            textStyle:
                const TextStyle(fontSize: sizeSmallx, color: Colors.white),
            boxStyle: FlutterSliderTooltipBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sizeVerySmall),
                color: const Color(0xfffbbc43),
              ),
            ),
            alwaysShowTooltip: true,
            direction: FlutterSliderTooltipDirection.top,
            positionOffset:
                FlutterSliderTooltipPositionOffset(top: sizeNormalx),
          ),
        ),
      ],
    );
  }
}
