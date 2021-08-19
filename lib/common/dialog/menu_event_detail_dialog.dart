import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../data/model/events.dart';
import '../../data/model/events_detail.dart';
import '../../data/repository/user_repository.dart';
import '../../ui/report/report_page.dart';
import '../../utils/date_util.dart';
import '../../utils/navigate_util.dart';
import '../../utils/ui_util.dart';
import '../constants.dart';
import '../di/injection/injector.dart';
import '../localization/lang.dart';
import '../theme/theme.dart';
import '../widget/my_text_view.dart';

class MenuEventDetailDialog extends StatelessWidget {
  final EventDetailInfo eventDetailInfo;
  final EventInfo eventInfo;
  final Function() onTurnOffPost;
  final Function() onRemovePost;
  final Function() onReportIssue;

  MenuEventDetailDialog(
      {this.eventDetailInfo,
      this.onTurnOffPost,
      this.onRemovePost,
      this.onReportIssue,
      this.eventInfo});

  @override
  Widget build(BuildContext context) {
    final userRepository = sl<UserRepository>();
    final userInfo = userRepository.getCurrentUser();

    final date = DateUtil.convertStringToDateJiffyFormat(eventDetailInfo != null
        ? eventDetailInfo.eventTime[0].date
        : eventInfo?.eventTime[0].date);
    final url = eventDetailInfo != null
        ? eventDetailInfo?.image?.url
        : eventInfo?.image?.url;
    final title =
        eventDetailInfo != null ? eventDetailInfo?.title : eventInfo?.title;
    return Padding(
      padding: const EdgeInsets.only(
          right: sizeNormal,
          left: sizeNormal,
          bottom: sizeNormal,
          top: sizeSmall),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                margin: const EdgeInsets.only(bottom: sizeSmallxxx),
                width: sizeNormalxxx,
                height: 4,
                decoration: const BoxDecoration(
                    color: Color(0x21212237),
                    borderRadius:
                        BorderRadius.all(Radius.circular(sizeVerySmall)))),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.all(Radius.circular(sizeNormal)),
                  child: UIUtil.makeImageWidget(
                    url ?? Res.image_lorem,
                    size: const Size(sizeExLargex, sizeExLargex),
                    boxFit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  width: sizeSmallxxx,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyTextView(
                        text: title ?? '',
                        textStyle: textSmallx.copyWith(
                          color: const Color(0xff212237),
                          fontFamily: MyFontFamily.graphik,
                          fontWeight: MyFontWeight.regular,
                        ),
                      ),
                      const SizedBox(
                        height: sizeSmall,
                      ),
                      MyTextView(
                        text: date ?? '',
                        textStyle: textSmallx.copyWith(
                          color: const Color(0xff212237),
                          fontFamily: MyFontFamily.graphik,
                          fontWeight: MyFontWeight.regular,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey[350]),
            const SizedBox(
              height: sizeSmallxx,
            ),
            if (userInfo?.isUser() ?? false)
              GestureDetector(
                onTap: () {
                  NavigateUtil.pop(context);
                  onRemovePost();
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.highlight_remove_outlined,
                      color: Color(0xff212237),
                      size: sizeNormalxx,
                    ),
                    const SizedBox(
                      width: sizeSmallxxx,
                    ),
                    Expanded(
                      child: MyTextView(
                        maxLine: 1,
                        textAlign: TextAlign.start,
                        text: Lang.event_remove_from_feed.tr(),
                        textStyle: textSmallx.copyWith(
                          color: const Color(0xff212237),
                          fontFamily: MyFontFamily.graphik,
                          fontWeight: MyFontWeight.regular,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(
              height: sizeSmallx,
            ),
            if (userInfo?.isUser() ?? false)
              GestureDetector(
                onTap: () {
                  NavigateUtil.pop(context);
                  onTurnOffPost();
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.power_settings_new_outlined,
                      color: Color(0xff212237),
                      size: sizeNormalxx,
                    ),
                    const SizedBox(
                      width: sizeSmallxxx,
                    ),
                    Expanded(
                      child: MyTextView(
                        text: '${Lang.event_turn_off_by.tr()}'
                                ' $title' ??
                            '',
                        maxLine: 1,
                        textAlign: TextAlign.start,
                        textStyle: textSmallx.copyWith(
                          color: const Color(0xff212237),
                          fontFamily: MyFontFamily.graphik,
                          fontWeight: MyFontWeight.regular,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(
              height: sizeSmallx,
            ),
            GestureDetector(
              onTap: () {
                NavigateUtil.pop(context);
                onReportIssue();
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    Res.icon_flag,
                    fit: BoxFit.contain,
                    height: sizeNormalxx,
                    color: const Color(0xff212237),
                  ),
                  const SizedBox(
                    width: sizeSmallxxx,
                  ),
                  Expanded(
                    child: MyTextView(
                      onTap: () {
                        NavigateUtil.openPage(context, ReportPage.routeName);
                      },
                      maxLine: 1,
                      textAlign: TextAlign.start,
                      text: Lang.community_detail_report_issue.tr(),
                      textStyle: textSmallx.copyWith(
                        color: const Color(0xff212237),
                        fontFamily: MyFontFamily.graphik,
                        fontWeight: MyFontWeight.regular,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
