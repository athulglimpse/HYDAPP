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

class SliderView extends StatelessWidget {
  final FilterArea itemFilter;
  final double value;
  final double max;
  final double min;
  final Function(FilterArea) onClearSlider;
  final Function(FilterArea filterArea, int handlerIndex, double lowerValue,
      double upperValue) onChange;

  const SliderView({
    Key key,
    this.itemFilter,
    this.value = 50,
    this.max = 100,
    this.min = 0,
    this.onChange,
    this.onClearSlider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: sizeSmallxx),
              child: MyTextView(
                  textStyle: textSmallxxx.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  text: itemFilter?.name ?? ''),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: sizeSmallxx),
              child: MyTextView(
                onTap: () {
                  onClearSlider(itemFilter);
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: sizeSmallxx),
              child: MyTextView(
                  textStyle: textSmallxx.copyWith(color: Colors.grey),
                  text: itemFilter.filterItem[0].name +
                      ': ' +
                      itemFilter.filterItem[0].number +
                      itemFilter.unit),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: sizeSmallxx),
              child: MyTextView(
                  textStyle: textSmallx.copyWith(color: Colors.grey),
                  text: itemFilter.filterItem[1].name +
                      ': ' +
                      itemFilter.filterItem[1].number +
                      itemFilter.unit),
            ),
          ],
        ),
        FlutterSlider(
          values: [value],
          min: min,
          max: max,
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
          rtl: context.locale.languageCode.toUpperCase() != PARAM_EN,
          handlerAnimation: const FlutterSliderHandlerAnimation(scale: 1),
          onDragCompleted: (index, low, up) {
            onChange(itemFilter, index, low, up);
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
