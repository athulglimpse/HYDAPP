import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:marvista/utils/date_util.dart';

import '../../data/model/notification_history_model.dart';
import '../../data/source/api_end_point.dart';
import '../../ui/report/report_page.dart';
import '../../utils/navigate_util.dart';
import '../../utils/ui_util.dart';
import '../constants.dart';
import '../localization/lang.dart';
import '../theme/theme.dart';
import '../widget/my_text_view.dart';

class MenuNotificationDetailDialog extends StatelessWidget {
  final NotificationHistoryModel historyModel;
  final Function() onRemoveNotification;
  final Function() onTurnOffNotification;
  final Function() onReportIssue;

  MenuNotificationDetailDialog(
      {this.historyModel,
      this.onRemoveNotification,
      this.onTurnOffNotification,
      this.onReportIssue});

  @override
  Widget build(BuildContext context) {
    final type = parseType(historyModel?.type ?? '');
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
                      historyModel?.data?.image?.url ?? Res.image_lorem,
                      size: const Size(sizeExLargex, sizeExLargex),
                      boxFit: BoxFit.cover),
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
                        text: historyModel?.data?.content ?? '',
                        maxLine: 1,
                        textAlign: TextAlign.start,
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
                        text: DateUtil.convertDateTime(
                            historyModel?.datetime.toString() ?? '',
                            locale: context.locale.languageCode),
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
            GestureDetector(
              onTap: () {
                NavigateUtil.pop(context);
                onRemoveNotification();
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
                  MyTextView(
                    text: Lang.notification_remove_from_feed.tr(),
                    textStyle: textSmallx.copyWith(
                      color: const Color(0xff212237),
                      fontFamily: MyFontFamily.graphik,
                      fontWeight: MyFontWeight.regular,
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
                onTurnOffNotification();
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.power_settings_new,
                    color: Color(0xff212237),
                    size: sizeNormalxx,
                  ),
                  const SizedBox(
                    width: sizeSmallxxx,
                  ),
                  MyTextView(
                    text: '${Lang.notification_turn_off_by.tr()}'
                            ' $type' ??
                        '',
                    textStyle: textSmallx.copyWith(
                      color: const Color(0xff212237),
                      fontFamily: MyFontFamily.graphik,
                      fontWeight: MyFontWeight.regular,
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
                  const Icon(
                    Icons.outlined_flag,
                    color: Color(0xff212237),
                    size: sizeNormalxx,
                  ),
                  const SizedBox(
                    width: sizeSmallxxx,
                  ),
                  MyTextView(
                    onTap: () {
                      NavigateUtil.openPage(context, ReportPage.routeName);
                    },
                    text: Lang.community_detail_report_issue.tr(),
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
      ),
    );
  }

  String parseType(String type) {
    switch (type) {
      case PARAM_MY_POST:
        return Lang.notification_type_post.tr();
      case PARAM_COMMUNITY_POST:
        return Lang.notification_type_post.tr();
      case PARAM_COMMENT:
        return Lang.notification_type_comment.tr();
      case PARAM_EVENT_DETAILS:
        return Lang.notification_type_event.tr();
      default:
        return Lang.notification_type_event.tr();
    }
  }
}
