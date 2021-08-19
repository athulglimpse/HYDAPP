import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../common/constants.dart';

import '../../../../common/localization/lang.dart';
import '../../../../common/theme/theme.dart';
import '../../../../common/widget/my_text_view.dart';

class ActivityTool extends StatelessWidget {
  final Function onClickReview;
  final Function onClickPhoto;
  final Function onClickReport;
  final Function onClickShare;

  const ActivityTool({
    Key key,
    this.onClickReview,
    this.onClickPhoto,
    this.onClickReport,
    this.onClickShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: sizeNormal),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: onClickReview,
            child: Container(
              color: const Color(0xffFDFBF5),
              padding: const EdgeInsets.all(sizeSmall),
              child: Column(
                children: [
                  SvgPicture.asset(
                    Res.icon_review,
                    fit: BoxFit.contain,
                    color: const Color(0xff212237),
                  ),
                  const SizedBox(
                    height: sizeVerySmall,
                  ),
                  MyTextView(
                    text: Lang.amenity_detail_review.tr(),
                    textStyle: textSmall.copyWith(
                        color: const Color(0xff212237),
                        fontWeight: MyFontWeight.regular,
                        fontFamily: MyFontFamily.graphik),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: onClickPhoto,
            child: Container(
              color: const Color(0xffFDFBF5),
              padding: const EdgeInsets.all(sizeSmall),
              child: Column(
                children: [
                  SvgPicture.asset(
                    Res.icon_photo,
                    fit: BoxFit.contain,
                    color: const Color(0xff212237),
                  ),
                  const SizedBox(
                    height: sizeVerySmall,
                  ),
                  MyTextView(
                    text: Lang.amenity_detail_photo.tr(),
                    textStyle: textSmall.copyWith(
                        color: const Color(0xff212237),
                        fontWeight: MyFontWeight.regular,
                        fontFamily: MyFontFamily.graphik),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: onClickReport,
            child: Container(
              color: const Color(0xffFDFBF5),
              padding: const EdgeInsets.all(sizeSmall),
              child: Column(
                children: [
                  SvgPicture.asset(Res.icon_flag, fit: BoxFit.contain),
                  const SizedBox(
                    height: sizeVerySmall,
                  ),
                  MyTextView(
                    text: Lang.amenity_detail_report.tr(),
                    textStyle: textSmall.copyWith(
                        color: const Color(0xff212237),
                        fontWeight: MyFontWeight.regular,
                        fontFamily: MyFontFamily.graphik),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: onClickShare,
            child: Container(
              color: const Color(0xffFDFBF5),
              padding: const EdgeInsets.all(sizeSmall),
              child: Column(
                children: [
                  SvgPicture.asset(Res.icon_share, fit: BoxFit.contain),
                  const SizedBox(
                    height: sizeVerySmall,
                  ),
                  MyTextView(
                    text: Lang.amenity_detail_share.tr(),
                    textStyle: textSmall.copyWith(
                        color: const Color(0xff212237),
                        fontWeight: MyFontWeight.regular,
                        fontFamily: MyFontFamily.graphik),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
