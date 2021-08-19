import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../common/constants.dart';
import '../../../../common/localization/lang.dart';
import '../../../../common/theme/theme.dart';
import '../../../../common/utils.dart';
import '../../../../common/widget/my_text_view.dart';
import '../../../../data/model/amenity_model.dart';
import '../../../../data/model/search_amenities_model.dart';
import '../../../../data/source/api_end_point.dart';
import '../../../../utils/date_util.dart';
import '../../../../utils/ui_util.dart';

class MapSearchResultWidget extends StatelessWidget {
  final List<AmenityModel> amenities;
  final BoxConstraints constraints;
  final Function(AmenityModel) onItemClick;

  const MapSearchResultWidget({
    Key key,
    this.amenities,
    this.constraints,
    this.onItemClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: sizeSmall),
        if (amenities?.isNotEmpty ?? false)
          ...amenities.map((e) {
            return GestureDetector(
              onTap: () => onItemClick(e),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: sizeSmall),
                    child: MyTextView(
                      text: e.parent?.title ?? ' ',
                      textStyle:
                          textNormal.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (e.parent?.listImage()?.isNotEmpty ?? false)
                    Container(
                      width: constraints.maxWidth,
                      height: sizeImageNormal,
                      margin: const EdgeInsets.symmetric(
                          horizontal: sizeSmall, vertical: sizeSmall),
                      child: ListView.builder(
                        itemCount: e.parent?.listImage()?.length ?? 0,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final img = e.parent?.listImage()[index];
                          return Container(
                            padding: const EdgeInsets.only(right: sizeSmall),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(sizeSmall),
                              child: UIUtil.makeImageWidget(
                                img.url,
                                size: const Size(
                                    sizeImageNormal, sizeImageNormal),
                                boxFit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: sizeSmall),
                    child: MyTextView(
                      textAlign: TextAlign.start,
                      maxLine: 1,
                      text: e.address ?? ' ',
                      textStyle: textSmallx,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: sizeSmall),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              LayoutBuilder(builder: (context, constraints) {
                                return ((e?.parent?.type ?? '') ==
                                        PARAM_EVENT_DETAILS)
                                    ? openAt(e.parent, context)
                                    : openNow(e.parent, context);
                              }),
                              // MyTextView(
                              //   textAlign: TextAlign.start,
                              //   text:
                              //       '${Lang.amenity_detail_suitable_for.tr()} '
                              //       '${e.parent?.pickOneSuitable?.name ?? ''}',
                              //   textStyle: textSmallx.copyWith(
                              //       color: Colors.grey,
                              //       fontWeight: MyFontWeight.medium,
                              //       fontFamily: MyFontFamily.graphik),
                              // ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: SvgPicture.asset(IconConstants.directions),
                          onPressed: () {
                            MapUtils.openMap(
                                double.parse(e.lat), double.parse(e.long));
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: double.infinity,
                    child: Divider(color: Colors.black26, thickness: 1),
                  ),
                  const SizedBox(height: sizeSmallxx),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget openNow(
      SearchAmenitiesModel searchAmenitiesModel, BuildContext context) {
    final dateNow = DateTime.now();
    var openTime = '';
    var closeTime = '';
    try {
      openTime = DateUtil.convertStringToDateFormat(
          searchAmenitiesModel.pickOpenTimeByDay(dateNow.weekday - 1),
          formatData: DateUtil.DATE_FORMAT_HHMMSS,
          formatValue: DateUtil.DATE_FORMAT_HHMMA,
          local: context.locale.languageCode);
      closeTime = DateUtil.convertStringToDateFormat(
          searchAmenitiesModel.pickCloseTimeByDay(dateNow.weekday - 1),
          formatData: DateUtil.DATE_FORMAT_HHMMSS,
          formatValue: DateUtil.DATE_FORMAT_HHMMA,
          local: context.locale.languageCode);
    } catch (e) {
      print(e.toString());
    }
    return (openTime != null && openTime.isNotEmpty)
        ? Row(
            children: [
              MyTextView(
                text: '${Lang.asset_detail_open_now.tr()}',
                textAlign: TextAlign.start,
                textStyle: textSmallx.copyWith(
                    color: Colors.black,
                    fontWeight: MyFontWeight.medium,
                    fontFamily: MyFontFamily.graphik),
              ),
              Expanded(
                child: MyTextView(
                    text: ' -'
                        ' $openTime - $closeTime'
                        '${Lang.asset_detail_today.tr()}',
                    textAlign: TextAlign.start,
                    maxLine: 1,
                    textStyle: textSmallx.copyWith(
                        color: Colors.grey,
                        fontWeight: MyFontWeight.medium,
                        fontFamily: MyFontFamily.graphik)),
              ),
            ],
          )
        : const SizedBox();
  }

  Widget openAt(
      SearchAmenitiesModel searchAmenitiesModel, BuildContext context) {
    if (searchAmenitiesModel.eventTime?.isEmpty ?? false) {
      return const SizedBox();
    }
    final month = DateUtil.convertStringToDateFormat(
        searchAmenitiesModel.eventTime[0].date,
        formatData: DateUtil.DATE_FORMAT_DDMMYYYY,
        formatValue: DateUtil.DATE_FORMAT_MMM,
        local: context.locale.languageCode);
    final day = DateUtil.convertStringToDateFormat(
        searchAmenitiesModel.eventTime[0].date,
        formatData: DateUtil.DATE_FORMAT_DDMMYYYY,
        formatValue: DateUtil.DATE_FORMAT_DD,
        local: context.locale.languageCode);
    return (month != null && month.isNotEmpty)
        ? Row(
            children: [
              MyTextView(
                text: '${Lang.asset_detail_open.tr()}',
                textAlign: TextAlign.start,
                textStyle: textSmallx.copyWith(
                    color: Colors.black,
                    fontWeight: MyFontWeight.medium,
                    fontFamily: MyFontFamily.graphik),
              ),
              Expanded(
                child: MyTextView(
                    text:
                        ': ${DateUtil.convertStringToDateFormat(searchAmenitiesModel.eventTime[0].openTime, formatData: DateUtil.DATE_FORMAT_HHMMSS, formatValue: DateUtil.DATE_FORMAT_HHMMA) ?? ''}'
                        ' ($month $day)',
                    textAlign: TextAlign.start,
                    maxLine: 1,
                    textStyle: textSmallx.copyWith(
                        color: Colors.grey,
                        fontWeight: MyFontWeight.medium,
                        fontFamily: MyFontFamily.graphik)),
              ),
            ],
          )
        : const SizedBox();
  }
}
