import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:marvista/common/constants.dart';
import 'package:marvista/common/widget/my_button.icon.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/constants.dart';
import '../../../../common/localization/lang.dart';
import '../../../../common/theme/theme.dart';
import '../../../../common/widget/my_text_view.dart';
import '../../../../data/model/asset_detail.dart';
import '../../../../utils/app_const.dart';
import '../../../../utils/date_util.dart';
import '../bloc/asset_detail_bloc.dart';

class AssetTitleGroup extends StatelessWidget {
  final AssetDetailState state;

  const AssetTitleGroup({Key key, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalReviews = state?.assetDetail?.totalReview ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: sizeSmallxxx,
        ),
        Row(
          children: [
            Expanded(
              child: MyTextView(
                text: state?.assetDetail?.title ?? '',
                textAlign: TextAlign.start,
                textStyle: textNormalxxx.copyWith(
                    color: Colors.black,
                    fontWeight: MyFontWeight.bold,
                    fontFamily: MyFontFamily.publicoBanner),
              ),
            ),
            renderIconPhone(),
          ],
        ),
        const SizedBox(height: sizeSmall),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HtmlWidget(state.assetDetail?.shortDescription ?? ''),
                  MyTextView(
                    text: state.assetDetail?.pickOneLocation?.address ?? '',
                    textAlign: TextAlign.start,
                    textStyle: textSmallxx.copyWith(
                        color: Colors.black54,
                        fontWeight: MyFontWeight.medium,
                        fontFamily: MyFontFamily.graphik),
                  ),
                  const SizedBox(height: sizeSmallx),
                  if (state?.assetDetail?.directUrl?.isNotEmpty ?? false)
                  GestureDetector(
                    onTap: () {
                      if (state.assetDetail.directUrl.isNotEmpty) {
                        launch(state.assetDetail.directUrl);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: sizeSmall, right: sizeSmall, top: sizeVerySmall, bottom: sizeVerySmall),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xff429C9B), width: 1),
                          color: Colors.transparent,
                          borderRadius: const BorderRadius.all(
                              Radius.circular(sizeNormal))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            Res.ic_external,
                            color: const Color(0xff429C9B),
                            height: sizeSmallxx,
                          ),
                          const SizedBox(
                            width: sizeVerySmall,
                          ),
                          MyTextView(
                            text: Lang.asset_detail_visit_website.tr(),
                            textAlign: TextAlign.center,
                            textStyle: textSmallx.copyWith(
                                color: const Color(0xff429C9B),
                                fontWeight: MyFontWeight.regular,
                                fontFamily: MyFontFamily.graphik),
                          )
                        ],
                      ),
                    ),
                  ),
                  LayoutBuilder(builder: (context, constraints) {
                    return openNow(state.assetDetail, context);
                  }),
                  // MyTextView(
                  //   text: '${Lang.amenity_detail_suitable_for.tr()} '
                  //       '${state?.assetDetail?.pickOneSuitable?.name ?? ''}',
                  //   textStyle: textSmallx.copyWith(
                  //       color: Colors.grey,
                  //       fontWeight: MyFontWeight.medium,
                  //       fontFamily: MyFontFamily.graphik),
                  // ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: sizeSmall),
        if (!isMVP)
          Row(
            children: [
              if (totalReviews > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: sizeVerySmallx, horizontal: sizeSmall),
                  decoration: const BoxDecoration(
                      color: Color(0xffE6E4DE),
                      borderRadius:
                          BorderRadius.all(Radius.circular(sizeSmallxxx))),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xffFBBC43),
                        size: sizeSmallx,
                      ),
                      MyTextView(
                        text: state.assetDetail.rate?.toString() ?? '0',
                        textStyle: textSmall.copyWith(
                            color: const Color(0xff212237).withOpacity(0.5),
                            fontWeight: MyFontWeight.medium,
                            fontFamily: MyFontFamily.graphik),
                      ),
                    ],
                  ),
                ),
              const SizedBox(
                width: sizeVerySmall,
              ),
              MyTextView(
                text: '$totalReviews '
                    '${totalReviews == 1 ? Lang.asset_detail_review.tr() : Lang.asset_detail_reviews.tr()}',
                textStyle: textSmallx.copyWith(
                    color: Colors.black,
                    fontWeight: MyFontWeight.regular,
                    fontFamily: MyFontFamily.graphik),
              ),
            ],
          ),
      ],
    );
  }

  Widget openNow(AssetDetail assetDetail, BuildContext context) {
    final dateNow = DateTime.now();
    final openTime = DateUtil.convertStringToDateFormat(
        assetDetail.pickOpenTimeByDay(dateNow.weekday - 1),
        formatData: DateUtil.DATE_FORMAT_HHMMSS,
        formatValue: DateUtil.DATE_FORMAT_HHMMA,
        local: context.locale.languageCode);
    final closeTime = DateUtil.convertStringToDateFormat(
        assetDetail.pickCloseTimeByDay(dateNow.weekday - 1),
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
                    textStyle: textSmallx.copyWith(
                        color: Colors.grey,
                        fontWeight: MyFontWeight.medium,
                        fontFamily: MyFontFamily.graphik)),
              ),
            ],
          )
        : const SizedBox();
  }

  Widget renderIconPhone() {
    return Row(
      children: [
        if (state?.assetDetail?.mailTo?.isNotEmpty ?? false)
          GestureDetector(
            onTap: () {
              if (state.assetDetail.mailTo.isNotEmpty) {
                launch('mailto:${state.assetDetail.mailTo}');
              }
            },
            child: Container(
              margin: const EdgeInsets.only(left: sizeSmall),
              padding: const EdgeInsets.all(sizeSmallx),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.all(Radius.circular(sizeSmallxxx))),
              child: SvgPicture.asset(
                Res.ic_mail,
                fit: BoxFit.cover,
                color: const Color(0xff429C9B),
                height: sizeNormalx,
              ),
            ),
          ),
        const SizedBox(width: sizeSmall),
        if (state?.assetDetail?.phoneNumber?.isNotEmpty ?? false)
          GestureDetector(
            onTap: () {
              if (state.assetDetail.phoneNumber.isNotEmpty) {
                launch('tel://${state.assetDetail.phoneNumber}');
              }
            },
            child: Container(
              margin: const EdgeInsets.only(left: sizeSmall),
              padding: const EdgeInsets.all(sizeSmallx),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.all(Radius.circular(sizeSmallxxx))),
              child: SvgPicture.asset(
                Res.ic_call,
                fit: BoxFit.cover,
                color: const Color(0xff429C9B),
                height: sizeNormalx,
              ),
            ),
          ),
      ],
    );
  }
}
