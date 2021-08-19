import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants.dart';

import '../../data/model/country.dart';
import '../../data/model/open_time_model.dart';
import '../../utils/date_util.dart';
import '../../utils/navigate_util.dart';
import '../../utils/ui_util.dart';
import '../../utils/utils.dart';
import '../localization/lang.dart';
import '../theme/theme.dart';
import '../widget/my_text_view.dart';
import 'normal_dialog_template.dart';

class EventTimeDialog extends StatelessWidget {
  final List<OpenTimeModel> listTime;
  final Function(List<OpenTimeModel>) onAddAllCalendar;
  final Function(OpenTimeModel) onAddTimeCalendar;

  const EventTimeDialog(
      {Key key, this.listTime, this.onAddAllCalendar, this.onAddTimeCalendar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NormalDialogTemplate.makeTemplate(
      Container(
        padding: const EdgeInsets.only(top: sizeNormal, bottom: sizeSmallxxxx),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(sizeNormalx),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyTextView(
                            text: Lang.event_schedule.tr(),
                            textStyle: textSmallxxx.copyWith(
                                color: const Color(0xff212237),
                                fontWeight: MyFontWeight.medium,
                                fontFamily: MyFontFamily.publicoBanner),
                          ),
                          const SizedBox(
                            height: sizeVerySmall,
                          ),
                          GestureDetector(
                            onTap: () {
                              onAddAllCalendar(listTime);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: sizeSmall,
                                vertical: sizeVerySmall,
                              ),
                              decoration: BoxDecoration(
                                  color: const Color(0xff242655),
                                  borderRadius:
                                      BorderRadius.circular(sizeNormal),
                                  border: Border.all(
                                    color: const Color(0xff242655),
                                  )),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    Res.ic_calendar,
                                    fit: BoxFit.cover,
                                    color: Colors.white,
                                    height: sizeSmallxxxx,
                                  ),
                                  const SizedBox(
                                    width: sizeVerySmall,
                                  ),
                                  MyTextView(
                                    text: Lang.event_add_all_calendar.tr(),
                                    textAlign: TextAlign.center,
                                    textStyle: textSmallx.copyWith(
                                        color: Colors.white,
                                        fontWeight: MyFontWeight.regular,
                                        fontFamily: MyFontFamily.graphik),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  child: Align(
                    alignment: UIUtil.getAlignmentENRight(context),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: sizeNormalx,
                          left: sizeNormalx,
                          top: sizeSmallx),
                      child: GestureDetector(
                        onTap: () => NavigateUtil.pop(context),
                        child: const Icon(
                          Icons.close,
                          color: Color(0xff212237),
                          size: sizeNormalx,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: sizeImageLarge,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listTime.length,
                itemBuilder: (BuildContext context, int index) {
                  return renderItemTime(context, index, listTime);
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      positionDialog: PositionDialog.center,
      insetMargin: const EdgeInsets.only(
          top: sizeLarge, right: sizeLarge, left: sizeLarge, bottom: sizeLarge),
      insetPadding: const EdgeInsets.all(0),
    );
  }

  Widget renderItemTime(
      BuildContext context, int index, List<dynamic> arrMenu) {
    final OpenTimeModel item = arrMenu[index];
    var month = '';
    var day = '';
    month = DateUtil.convertStringToDateFormat(item.date,
        formatData: DateUtil.DATE_FORMAT_DDMMYYYY,
        formatValue: DateUtil.DATE_FORMAT_MMM,
        local: UIUtil.languageCode(context));
    day = DateUtil.convertStringToDateFormat(item.date,
        formatData: DateUtil.DATE_FORMAT_DDMMYYYY,
        formatValue: DateUtil.DATE_FORMAT_DD,
        local: UIUtil.languageCode(context));
    return Material(
      color: const Color(0xffE4EBEE),
      child: Column(
        children: [
          Row(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: sizeSmall,
                      bottom: sizeVerySmall,
                      right: sizeSmallxxx,
                      left: sizeSmallxxx),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: sizeSmall, horizontal: sizeSmallxx),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(
                                0, 1.5), // changes position of shadow
                          ),
                        ],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(sizeSmall))),
                    child: Column(
                      children: [
                        MyTextView(
                          text: month.toUpperCase(),
                          textAlign: TextAlign.start,
                          maxLine: 1,
                          textStyle: textSmallx.copyWith(
                              color: const Color(0xff242655),
                              fontWeight: MyFontWeight.medium),
                        ),
                        MyTextView(
                          text: day,
                          textAlign: TextAlign.start,
                          maxLine: 1,
                          textStyle: textNormalx.copyWith(
                              color: const Color(0xff242655),
                              fontWeight: MyFontWeight.light),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    if (item.openTime != null)
                      Padding(
                        padding: const EdgeInsets.only(left: sizeSmall),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.fiber_manual_record,
                              color: Colors.black,
                              size: sizeVerySmall,
                            ),
                            MyTextView(
                              text: Lang.event_start_time.tr(),
                              textStyle: textSmallxx.copyWith(
                                  color: const Color(0xff212237),
                                  fontWeight: MyFontWeight.bold,
                                  fontFamily: MyFontFamily.graphik),
                            ),
                            const SizedBox(
                              width: sizeIcon,
                            ),
                            MyTextView(
                              text: DateUtil.convertStringToDateFormat(
                                  item.openTime,
                                  formatData: DateUtil.DATE_FORMAT_HHMMSS,
                                  formatValue: DateUtil.DATE_FORMAT_HHMMA,
                                  local: context.locale.languageCode),
                              textStyle: textSmallxx.copyWith(
                                  color: const Color(0xff212237),
                                  fontWeight: MyFontWeight.medium,
                                  fontFamily: MyFontFamily.graphik),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(
                      height: sizeVerySmall,
                    ),
                    if (item.closeTime != null)
                      Padding(
                        padding: const EdgeInsets.only(left: sizeSmall),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.fiber_manual_record,
                              color: Colors.black,
                              size: sizeVerySmall,
                            ),
                            MyTextView(
                              text: Lang.event_end_date.tr(),
                              textStyle: textSmallxx.copyWith(
                                  color: const Color(0xff212237),
                                  fontWeight: MyFontWeight.bold,
                                  fontFamily: MyFontFamily.graphik),
                            ),
                            const SizedBox(
                              width: sizeIcon,
                            ),
                            MyTextView(
                              text: DateUtil.convertStringToDateFormat(
                                  item.closeTime,
                                  formatData: DateUtil.DATE_FORMAT_HHMMSS,
                                  formatValue: DateUtil.DATE_FORMAT_HHMMA,
                                  local: context.locale.languageCode),
                              textStyle: textSmallxx.copyWith(
                                  color: const Color(0xff212237),
                                  fontWeight: MyFontWeight.medium,
                                  fontFamily: MyFontFamily.graphik),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  onAddTimeCalendar(item);
                },
                child: Container(
                  margin: const EdgeInsets.only(
                      left: sizeSmall, right: sizeSmallxxx),
                  padding: const EdgeInsets.all(sizeSmallx),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset:
                              const Offset(0, 1), // changes position of shadow
                        ),
                      ],
                      color: const Color(0xff242655),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(sizeLarge))),
                  child: SvgPicture.asset(
                    Res.ic_calendar,
                    fit: BoxFit.cover,
                    color: Colors.white,
                    height: sizeSmallxxxx,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: sizeSmall,
          ),
          Divider(
            height: 1,
            color: const Color(0xff212237).withOpacity(0.1),
          ),
        ],
      ),
    );
  }
}
