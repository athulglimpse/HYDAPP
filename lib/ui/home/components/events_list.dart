import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../../common/constants.dart';
import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/my_text_view.dart';
import '../../../data/model/events.dart';
import '../../../utils/date_util.dart';
import '../../../utils/ui_util.dart';

@immutable
class EventsList extends StatelessWidget {
  final String title;
  final List<EventInfo> listActivities;
  final Function(EventInfo value) onItemClick;
  final Function(EventInfo value) onRemovePost;
  final Function(EventInfo value) onTurnOffPost;
  final Function onSeeAllClick;
  final bool isShowSeeAll;
  final EdgeInsets padding;

  EventsList({
    Key key,
    this.onItemClick,
    this.onSeeAllClick,
    this.isShowSeeAll = true,
    this.title,
    this.listActivities,
    this.padding = const EdgeInsets.only(left: sizeNormal, right: sizeNormal),
    this.onRemovePost,
    this.onTurnOffPost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            MyTextView(
              text: title ?? Lang.home_events.tr(),
              textStyle: textSmallxxx.copyWith(
                  color: Colors.black,
                  fontFamily: MyFontFamily.graphik,
                  fontWeight: MyFontWeight.semiBold),
            ),
            if (isShowSeeAll)
              MyTextView(
                onTap: onSeeAllClick,
                padding: const EdgeInsets.symmetric(
                    vertical: sizeVerySmall, horizontal: sizeVerySmall),
                text: Lang.home_see_all.tr(),
                textStyle: textSmallxx.copyWith(color: const Color(0xff419C9B)),
              )
          ],
        ),
      ),
      const SizedBox(
        height: sizeSmall,
      ),
      Container(
          margin: const EdgeInsets.only(left: sizeNormal),
          height: sizeImageLargex + sizeLargex,
          child: ListView.builder(
              itemCount: listActivities?.length ?? 0,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return CardEventItem(
                  eventInfo: listActivities[index],
                  onItemClick: onItemClick,
                  onRemovePost: onRemovePost,
                  onTurnOffPost: onTurnOffPost,
                );
              }))
    ]);
  }
}

class CardEventItem extends StatelessWidget {
  final EventInfo eventInfo;
  final Function(EventInfo) onItemClick;
  final Function(EventInfo) onRemovePost;
  final Function(EventInfo) onTurnOffPost;

  CardEventItem(
      {Key key,
      this.eventInfo,
      this.onItemClick,
      this.onRemovePost,
      this.onTurnOffPost})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final month = DateUtil.convertStringToDateFormat(
        eventInfo.eventTime[0].date,
        formatData: DateUtil.DATE_FORMAT_DDMMYYYY,
        formatValue: DateUtil.DATE_FORMAT_MMM,
        local: context.locale.languageCode);
    final day = DateUtil.convertStringToDateFormat(eventInfo.eventTime[0].date,
        formatData: DateUtil.DATE_FORMAT_DDMMYYYY,
        formatValue: DateUtil.DATE_FORMAT_DD,
        local: context.locale.languageCode);
    return Container(
      margin: const EdgeInsets.only(right: sizeNormal),
      child: GestureDetector(
        onTap: () => onItemClick(eventInfo),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(sizeSmall),
          child: AspectRatio(
            aspectRatio: 0.8,
            child: Container(
              color: Colors.transparent,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: sizeNormalxx),
                    child: UIUtil.makeImageWidget(
                        eventInfo?.image?.url ?? Res.image_lorem,
                        boxFit: BoxFit.cover),
                  ),
                  Positioned.fill(
                      child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: sizeVerySmall),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: sizeVerySmall),
                        padding: const EdgeInsets.symmetric(
                            vertical: sizeSmall, horizontal: sizeSmall),
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
                            borderRadius: const BorderRadius.all(
                                Radius.circular(sizeSmall))),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  MyTextView(
                                    text: eventInfo.title,
                                    textAlign: TextAlign.start,
                                    maxLine: 1,
                                    textStyle: textSmallx.copyWith(
                                        fontFamily: MyFontFamily.graphik,
                                        fontWeight: MyFontWeight.medium),
                                  ),
                                  const SizedBox(height: sizeSmall),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.room,
                                        color: Colors.grey[700],
                                        size: sizeSmallxxx,
                                      ),
                                      Expanded(
                                        child: MyTextView(
                                          text: eventInfo
                                                  ?.pickOneLocation?.address ??
                                              '',
                                          textAlign: TextAlign.start,
                                          maxLine: 1,
                                          textStyle: textSmall.copyWith(
                                              color:
                                                  Colors.black.withAlpha(128)),
                                        ),
                                      ),
                                      Icon(
                                        Icons.query_builder,
                                        color: Colors.grey[350],
                                        size: sizeSmallxxx,
                                      ),
                                      MyTextView(
                                        text:
                                            DateUtil.convertStringToDateFormat(
                                                    eventInfo
                                                        .eventTime[0].openTime,
                                                    formatData: DateUtil
                                                        .DATE_FORMAT_HHMMSS,
                                                    formatValue: DateUtil
                                                        .DATE_FORMAT_HHMMA,
                                                    local: context
                                                        .locale.languageCode) ??
                                                '',
                                        textAlign: TextAlign.start,
                                        maxLine: 1,
                                        textStyle: textSmall.copyWith(
                                            color: Colors.black.withAlpha(128)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                UIUtil.showEventDialogMenu(
                                  context: context,
                                  eventInfo: eventInfo,
                                  onRemovePost: () {
                                    onRemovePost(eventInfo);
                                  },
                                  onTurnOffPost: () {
                                    onTurnOffPost(eventInfo);
                                  },
                                );
                              },
                              child: const Icon(
                                Icons.more_vert,
                                color: Color(0xffD9D9E8),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
                  Positioned(
                      top: sizeSmallxx,
                      left: sizeSmallxx,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: sizeVerySmall),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: sizeSmall),
                            padding: const EdgeInsets.symmetric(
                                vertical: sizeSmallxxx,
                                horizontal: sizeSmallxx),
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
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(sizeSmall))),
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
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
