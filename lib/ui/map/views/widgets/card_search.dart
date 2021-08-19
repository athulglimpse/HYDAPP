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

class CardSearch extends StatelessWidget {
  final AmenityModel data;

  CardSearch({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const SizedBox();
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(sizeSmall),
      child: AspectRatio(
        aspectRatio: 1.4,
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: UIUtil.makeImageWidget(
                  data.parent?.image?.url ?? Res.image_lorem,
                  boxFit: BoxFit.cover,
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: sizeVerySmall, horizontal: sizeSmall),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MyTextView(
                              text: data?.parent?.title ?? ' ',
                              textStyle: textNormal.copyWith(
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                              maxLine: 1,
                            ),
                            MyTextView(
                              text: data?.address ?? ' ',
                              textStyle: textSmallxx.copyWith(
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                              maxLine: 1,
                            ),
                            LayoutBuilder(builder: (context, constraints) {
                              return ((data?.parent?.type ?? '') ==
                                      PARAM_EVENT_DETAILS)
                                  ? openAt(data.parent, context)
                                  : openNow(data.parent, context);
                            }),
                            // MyTextView(
                            //   textAlign: TextAlign.start,
                            //   text: '${Lang.amenity_detail_suitable_for.tr()} '
                            //       '${data.parent?.pickOneSuitable?.name ?? ''}',
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
                              double.parse(data.lat), double.parse(data.long));
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget openNow(
      SearchAmenitiesModel searchAmenitiesModel, BuildContext context) {
    final dateNow = DateTime.now();
    final openTime = DateUtil.convertStringToDateFormat(
        searchAmenitiesModel.pickOpenTimeByDay(dateNow.weekday - 1),
        formatData: DateUtil.DATE_FORMAT_HHMMSS,
        formatValue: DateUtil.DATE_FORMAT_HHMMA,
        local: context.locale.languageCode);
    final closeTime = DateUtil.convertStringToDateFormat(
        searchAmenitiesModel.pickCloseTimeByDay(dateNow.weekday - 1),
        formatData: DateUtil.DATE_FORMAT_HHMMSS,
        formatValue: DateUtil.DATE_FORMAT_HHMMA,
        local: context.locale.languageCode);
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
