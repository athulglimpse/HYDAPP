import 'dart:io';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marvista/common/dialog/event_time_dialog.dart';
import 'package:marvista/data/model/open_time_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/constants.dart';
import '../../../../common/localization/lang.dart';
import '../../../../common/theme/theme.dart';
import '../../../../common/widget/my_read_more_text.dart';
import '../../../../common/widget/my_text_view.dart';
import '../../../../common/widget/timeline/defaults.dart';
import '../../../../common/widget/timeline/event_item.dart';
import '../../../../common/widget/timeline/indicator_position.dart';
import '../../../../common/widget/timeline/timeline.dart';
import '../../../../common/widget/timeline/timeline_theme.dart';
import '../../../../common/widget/timeline/timeline_theme_data.dart';
import '../../../../utils/date_util.dart';
import '../../../../utils/ui_util.dart';
import '../bloc/event_detail_bloc.dart';

class EventTitleGroup extends StatelessWidget {
  final EventDetailState state;
  final Function onClickAddFa;
  final Function onClickShare;
  int currentIndex = 0;

  EventTitleGroup({Key key, this.state, this.onClickAddFa, this.onClickShare})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MyTextView(
                  text: state.eventDetailInfo.title ?? '',
                  textAlign: TextAlign.start,
                  textStyle: textNormalxxx.copyWith(
                      color: Colors.black,
                      fontWeight: MyFontWeight.bold,
                      fontFamily: MyFontFamily.publicoBanner),
                ),
                const SizedBox(
                  height: sizeVerySmall,
                ),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: onClickAddFa,
                child: Container(
                  padding: const EdgeInsets.all(sizeSmall),
                  margin: const EdgeInsets.only(
                    left: sizeVerySmall,
                    right: sizeVerySmall,
                    bottom: sizeVerySmall,
                  ),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset:
                              const Offset(0, 1), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                          Radius.circular(sizeSmallxxx))),
                  child: Icon(
                    Icons.favorite,
                    color: state?.eventDetailInfo?.isFavorite ?? false
                        ? Colors.red
                        : Colors.grey,
                    size: sizeNormalx,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onClickShare,
                child: Container(
                  padding: const EdgeInsets.all(sizeSmall),
                  margin: const EdgeInsets.only(
                    left: sizeVerySmall,
                    right: sizeVerySmall,
                    bottom: sizeVerySmall,
                  ),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset:
                              const Offset(0, 1), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                          Radius.circular(sizeSmallxxx))),
                  child: SvgPicture.asset(
                    Res.icon_share,
                    fit: BoxFit.contain,
                    width: sizeNormalx,
                    height: sizeNormalx,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      const SizedBox(
        height: sizeSmall,
      ),
      state.eventDetailInfo.eventTime.length > 1
          ? multipleDayEvent(context)
          : oneDayEvent(context)
    ]);
  }

  Widget multipleDayEvent(BuildContext context) {
    var month = '';
    var day = '';
    String eventDate;
    if (state?.eventDetailInfo?.eventTime?.isNotEmpty ?? false) {
      eventDate = state.eventDetailInfo.eventTime[0].date;
      month = DateUtil.convertStringToDateFormat(
          state.eventDetailInfo.eventTime[0].date,
          formatData: DateUtil.DATE_FORMAT_DDMMYYYY,
          formatValue: DateUtil.DATE_FORMAT_MMM,
          local: context.locale.languageCode);
      day = DateUtil.convertStringToDateFormat(
          state.eventDetailInfo.eventTime[0].date,
          formatData: DateUtil.DATE_FORMAT_DDMMYYYY,
          formatValue: DateUtil.DATE_FORMAT_DD,
          local: context.locale.languageCode);
    }
    return Column(
      children: [
        Row(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: sizeVerySmall),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: sizeNormalxx, horizontal: sizeSmallxx),
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
                      const SizedBox(
                        height: sizeVerySmall,
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
              child: Padding(
                padding: const EdgeInsets.only(
                    left: sizeSmallxxx, right: sizeSmallxxx),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTimeline(context),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialogEventTime(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: sizeSmall,
                              vertical: sizeVerySmall,
                            ),
                            decoration: BoxDecoration(
                                color: const Color(0xff242655),
                                borderRadius: BorderRadius.circular(sizeNormal),
                                border: Border.all(
                                  color: const Color(0xff242655),
                                )),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(Res.ic_wall_clock,
                                    width: sizeSmallxxxx,
                                    height: sizeSmallxxxx,
                                    fit: BoxFit.contain),
                                const SizedBox(
                                  width: sizeVerySmall,
                                ),
                                MyTextView(
                                  text: Lang.event_check_schedule.tr(),
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
                        const SizedBox(width: sizeSmall),
                        if (state?.eventDetailInfo?.directUrl?.isNotEmpty ??
                            false)
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (state
                                    .eventDetailInfo.directUrl.isNotEmpty) {
                                  launch(state.eventDetailInfo.directUrl);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: sizeSmall,
                                  vertical: sizeVerySmall,
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff429C9B),
                                        width: 1),
                                    color: Colors.transparent,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(sizeNormal))),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      Res.ic_external,
                                      color: const Color(0xff429C9B),
                                      height: sizeSmallxxxx,
                                    ),
                                    const SizedBox(
                                      width: sizeVerySmall,
                                    ),
                                    MyTextView(
                                      text: Lang.event_register.tr(),
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
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: sizeSmallxx,
        ),
        if ((state.eventDetailInfo?.description ?? '').isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTextView(
                textAlign: TextAlign.start,
                text: Lang.event_about_event.tr(),
                textStyle: textSmallxxx.copyWith(
                    color: const Color(0xff212237),
                    fontWeight: MyFontWeight.semiBold,
                    fontFamily: MyFontFamily.graphik),
              ),
              const SizedBox(
                height: sizeSmallxx,
              ),
              ReadMoreText(
                state.eventDetailInfo?.description ?? '',
                trimLines: 4,
                trimMode: TrimMode.Line,
                trimCollapsedText: Lang.event_read_more.tr(),
                trimExpandedText: Lang.event_read_less.tr(),
                style: textSmallxx.copyWith(
                    color: const Color(0xff212237),
                    fontWeight: MyFontWeight.regular,
                    fontFamily: MyFontFamily.graphik),
                moreStyle: textSmallxx.copyWith(
                    color: const Color(0xff212237),
                    fontWeight: MyFontWeight.medium,
                    fontFamily: MyFontFamily.graphik),
                lessStyle: textSmallxx.copyWith(
                    color: const Color(0xff212237),
                    fontWeight: MyFontWeight.medium,
                    fontFamily: MyFontFamily.graphik),
              ),
            ],
          ),
      ],
    );
  }

  Widget oneDayEvent(BuildContext context) {
    var month = '';
    var day = '';
    String eventDate;
    if (state?.eventDetailInfo?.eventTime?.isNotEmpty ?? false) {
      eventDate = state.eventDetailInfo.eventTime[0].date;
      month = DateUtil.convertStringToDateFormat(
          state.eventDetailInfo.eventTime[0].date,
          formatData: DateUtil.DATE_FORMAT_DDMMYYYY,
          formatValue: DateUtil.DATE_FORMAT_MMM,
          local: context.locale.languageCode);
      day = DateUtil.convertStringToDateFormat(
          state.eventDetailInfo.eventTime[0].date,
          formatData: DateUtil.DATE_FORMAT_DDMMYYYY,
          formatValue: DateUtil.DATE_FORMAT_DD,
          local: context.locale.languageCode);
    }
    return Column(
      children: [
        Row(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: sizeVerySmall),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: sizeNormalxx, horizontal: sizeSmallxx),
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
              child: Padding(
                padding: const EdgeInsets.only(
                    left: sizeSmallxxx, right: sizeSmallxxx),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyTextView(
                      text: eventDate != null
                          ? DateUtil.convertStringToDateJiffyFormat(eventDate,
                              local: context.locale.languageCode)
                          : '',
                      textStyle: textSmallxx.copyWith(
                          color: const Color(0xff212237),
                          fontWeight: MyFontWeight.medium,
                          fontFamily: MyFontFamily.graphik),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        MyTextView(
                          text: eventDate != null
                              ? '${DateUtil.convertStringToDateFormat(state.eventDetailInfo.eventTime[0].openTime, formatData: DateUtil.DATE_FORMAT_HHMMSS, formatValue: DateUtil.DATE_FORMAT_HHMMA, local: context.locale.languageCode)}'
                              : '',
                          textStyle: textSmallxx.copyWith(
                              color: const Color(0xff212237),
                              fontWeight: MyFontWeight.regular,
                              fontFamily: MyFontFamily.graphik),
                        ),
                        MyTextView(
                          text: eventDate != null &&
                                  state.eventDetailInfo.eventTime[0]
                                          .closeTime !=
                                      null
                              ? ' - ${DateUtil.convertStringToDateFormat(state.eventDetailInfo.eventTime[0].closeTime, formatData: DateUtil.DATE_FORMAT_HHMMSS, formatValue: DateUtil.DATE_FORMAT_HHMMA, local: context.locale.languageCode)}'
                              : '',
                          textStyle: textSmallxx.copyWith(
                              color: const Color(0xff212237),
                              fontWeight: MyFontWeight.regular,
                              fontFamily: MyFontFamily.graphik),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: sizeVerySmallx,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            onAddEventCalendar(
                                state.eventDetailInfo.eventTime[0], false);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: sizeSmall,
                              vertical: sizeVerySmall,
                            ),
                            decoration: BoxDecoration(
                                color: const Color(0xff242655),
                                borderRadius: BorderRadius.circular(sizeNormal),
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
                                  text: Lang.event_add_to_calendar.tr(),
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
                        const SizedBox(width: sizeSmall),
                        if (state?.eventDetailInfo?.directUrl?.isNotEmpty ??
                            false)
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (state
                                    .eventDetailInfo.directUrl.isNotEmpty) {
                                  launch(state.eventDetailInfo.directUrl);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: sizeSmall,
                                  vertical: sizeVerySmall,
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff429C9B),
                                        width: 1),
                                    color: Colors.transparent,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(sizeNormal))),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      Res.ic_external,
                                      color: const Color(0xff429C9B),
                                      height: sizeSmallxxxx,
                                    ),
                                    const SizedBox(
                                      width: sizeVerySmall,
                                    ),
                                    MyTextView(
                                      text: Lang.event_register.tr(),
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
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: sizeSmallxx,
        ),
        if ((state.eventDetailInfo?.description ?? '').isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTextView(
                textAlign: TextAlign.start,
                text: Lang.event_about_event.tr(),
                textStyle: textSmallxxx.copyWith(
                    color: const Color(0xff212237),
                    fontWeight: MyFontWeight.semiBold,
                    fontFamily: MyFontFamily.graphik),
              ),
              const SizedBox(
                height: sizeSmallxx,
              ),
              ReadMoreText(
                state.eventDetailInfo?.description ?? '',
                trimLines: 4,
                trimMode: TrimMode.Line,
                trimCollapsedText: Lang.event_read_more.tr(),
                trimExpandedText: Lang.event_read_less.tr(),
                style: textSmallxx.copyWith(
                    color: const Color(0xff212237),
                    fontWeight: MyFontWeight.regular,
                    fontFamily: MyFontFamily.graphik),
                moreStyle: textSmallxx.copyWith(
                    color: const Color(0xff212237),
                    fontWeight: MyFontWeight.medium,
                    fontFamily: MyFontFamily.graphik),
                lessStyle: textSmallxx.copyWith(
                    color: const Color(0xff212237),
                    fontWeight: MyFontWeight.medium,
                    fontFamily: MyFontFamily.graphik),
              ),
            ],
          ),
      ],
    );
  }

  Future<void> onAddEventCalendar(
      OpenTimeModel openTimeModel, bool isAddAllCalender) async {
    if (Platform.isAndroid) {
      final status = await Permission.calendar.status;
      print(status);
      if (status.isPermanentlyDenied ) {
        await openAppSettings();
        return;
      } else if (status == null /*PermissionStatus.undetermined*/||status.isDenied) {
        final statusRequest = await Permission.calendar.request();
        if (statusRequest != PermissionStatus.granted) {
          UIUtil.showToast(Lang.event_you_need_enable_calendar_in_setting.tr(),
              backgroundColor: Colors.redAccent);
          return;
        }
      } else if (status != PermissionStatus.granted) {
        UIUtil.showToast(Lang.event_you_need_enable_calendar_in_setting.tr(),
            backgroundColor: Colors.redAccent);
        return;
      }
    }
    final startDate = openTimeModel.date + ' ' + openTimeModel.openTime;
    final endDate = openTimeModel.date +
        ' ' +
        (openTimeModel.closeTime ?? openTimeModel.openTime);
    final event = Event(
      title: state.eventDetailInfo.title,
      description: state.eventDetailInfo.description,
      location: state.eventDetailInfo.pickOneLocation?.address ?? '',
      startDate: DateUtil.convertStringToDate(startDate,
          formatData: DateUtil.FORMAT_DATE_TIME_CS),
      endDate: DateUtil.convertStringToDate(endDate,
          formatData: DateUtil.FORMAT_DATE_TIME_CS),
      alarmInterval: const Duration(minutes: 40),
      allDay: false,
    );
    await Add2Calendar.addEvent2Cal(event, androidNoUI: true).then((success) {
      if (success) {
        if (isAddAllCalender) {
          final list = state.eventDetailInfo.eventTime;
          currentIndex++;
          if (currentIndex < list.length) {
            if (currentIndex == list.length - 1) {
              onAddEventCalendar(list[currentIndex], false);
              currentIndex = 0;
              return;
            }
            onAddEventCalendar(list[currentIndex], true);
          }
        } else {
          UIUtil.showToast(Lang.event_add_calendar_success.tr(),
              backgroundColor: Colors.lightGreen);
        }
      } else {
        UIUtil.showToast(Lang.event_you_need_enable_calendar_in_setting.tr(),
            backgroundColor: Colors.redAccent);
      }
    }, onError: (e) {
      print(e);
    });
  }

  TimelineEventDisplay plainEventDisplay(
      BuildContext context, String title, String time) {
    return TimelineEventDisplay(
      anchor: IndicatorPosition.top,
      indicatorOffset: const Offset(-5, 3),
      child: TimelineEventCard(
        title: Row(
          children: [
            MyTextView(
              text: title,
              textStyle: textSmallxx.copyWith(
                  color: const Color(0xff212237),
                  fontWeight: MyFontWeight.bold,
                  fontFamily: MyFontFamily.graphik),
            ),
            const SizedBox(
              width: sizeIcon,
            ),
            MyTextView(
              text: time,
              textStyle: textSmallxx.copyWith(
                  color: const Color(0xff212237),
                  fontWeight: MyFontWeight.medium,
                  fontFamily: MyFontFamily.graphik),
            ),
          ],
        ),
        content: const SizedBox(),
      ),
      indicator: TimelineDots.of(context).simple,
    );
  }

  Widget _buildTimeline(BuildContext context) {
    final startDate = DateUtil.convertStringToDateFormat(
        state.eventDetailInfo.eventTime[0].date,
        formatData: DateUtil.DATE_FORMAT_DDMMYYYY,
        formatValue: DateUtil.DATE_FORMAT_DDMMMYYYY,
        local: context.locale.languageCode);
    final endDate = DateUtil.convertStringToDateFormat(
        state.eventDetailInfo
            .eventTime[state.eventDetailInfo.eventTime.length - 1].date,
        formatData: DateUtil.DATE_FORMAT_DDMMYYYY,
        formatValue: DateUtil.DATE_FORMAT_DDMMMYYYY,
        local: context.locale.languageCode);
    return TimelineTheme(
        data: TimelineThemeData(
            lineColor: const Color(0xffE4EBEE),
            itemGap: 0,
            lineGap: 0,
            strokeWidth: 2),
        child: Timeline(
          indicatorSize: sizeNormal,
          events: [
            plainEventDisplay(context, Lang.event_start_date.tr(), startDate),
            plainEventDisplay(context, Lang.event_end_date.tr(), endDate)
          ],
        ));
  }

  void showDialogEventTime(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => EventTimeDialog(
        listTime: state.eventDetailInfo.eventTime,
        onAddAllCalendar: (list) {
          onAddEventCalendar(list[currentIndex], true);
        },
        onAddTimeCalendar: (openTimeModel) {
          onAddEventCalendar(openTimeModel, false);
        },
      ),
    );
  }
}
