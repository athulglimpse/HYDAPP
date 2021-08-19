import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marvista/utils/date_util.dart';

import '../../../common/constants.dart';
import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/my_text_view.dart';
import '../../../data/model/user_community_model.dart';
import '../util/my_community_util.dart';

class CardMyCommunity extends StatelessWidget {
  final double height;
  final UserCommunityModel item;

  CardMyCommunity({Key key, this.item, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(sizeNormalxx),
              ),
              child: Container(
                  color: const Color(0xff212237),
                  child: getImageByType(item.type)),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: sizeNormal, right: sizeNormal),
              child: SizedBox(
                width: sizeImageNormalxx + sizeNormalxx,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextView(
                      padding: const EdgeInsets.only(right: 250),
                      textAlign: TextAlign.start,
                      maxLine: 1,
                      textStyle: textSmallxx.copyWith(
                          color: const Color(0xff212237),
                          fontWeight: MyFontWeight.regular),
                      text: item.caption,
                    ),
                    const SizedBox(
                      height: sizeVerySmall,
                    ),
                    MyTextView(
                      textAlign: TextAlign.start,
                      textStyle: textSmallx.copyWith(
                          color: const Color(0xff212237).withOpacity(0.5),
                          fontWeight: MyFontWeight.regular),
                      text:
                          Lang.profile_date_submit_post_and_review.tr().format([
                        DateUtil.convertDateTime(
                            item?.createdDate.toString() ?? '',
                            formatData: DateUtil.DATE_FORMAT_DDMMMYYYY,
                            locale: context.locale.languageCode)
                      ]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: sizeSmallxx,
            ),
            Expanded(
              flex: 2,
              child: MyTextView(
                textAlign: TextAlign.end,
                textStyle: textSmall.copyWith(
                    color: getColorsByStatus(item.status),
                    fontWeight: MyFontWeight.regular),
                text: getStatusByKey(item.status.toLowerCase()),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: sizeSmall,
        ),
        const Padding(
          padding: EdgeInsets.only(left: sizeLargexxx),
          child: Divider(height: 1, color: Colors.grey),
        ),
      ],
    );
  }

  Widget getImageByType(String type) {
    switch (type) {
      case MY_COMMUNITY_TYPE_PHOTO:
        return SvgPicture.asset(Res.icon_camera, fit: BoxFit.contain);
      case MY_COMMUNITY_TYPE_REVIEW:
        return SvgPicture.asset(Res.icon_edit, fit: BoxFit.contain);
      default:
        return const SizedBox();
    }
  }

  Color getColorsByStatus(String status) {
    switch (status) {
      case MY_COMMUNITY_STATUS_PENDING:
      case MY_COMMUNITY_STATUS_DRAFT:
        return const Color(0xffFBBC43);
      case MY_COMMUNITY_STATUS_POSTED:
      case MY_COMMUNITY_STATUS_APPROVED:
        return const Color(0xff185D30);
      case MY_COMMUNITY_STATUS_REJECTED:
        return const Color(0xffE75D52);
      default:
        return const Color(0xffffffff);
    }
  }

  String getStatusByKey(String status) {
    switch (status) {
      case 'approved':
        return Lang.from_the_community_approved.tr();
      case 'draft':
        return Lang.from_the_community_draft.tr();
      case 'rejected':
        return Lang.from_the_community_rejected.tr();
    }
    return '...';
  }
}
